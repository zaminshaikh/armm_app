import {
    collection,
    getFirestore,
    getDocs,
    getDoc,
    doc,
    setDoc,
    deleteDoc,
    collectionGroup,
    query,
    where,
    writeBatch,
    Timestamp,
    DocumentData,
    CollectionReference,
    DocumentSnapshot,
    addDoc,
  } from 'firebase/firestore';
import { app } from '../App';
import config from '../../config.json';
import { getFunctions, httpsCallable } from 'firebase/functions';
import { formatDate, toSentenceCase } from 'src/utils/utilities';
import { emptyClient, emptyActivity, Client, Activity, ScheduledActivity, StatementData, AssetDetails, GraphPoint, Assets } from './models';
import { roundToNearestHour, formatCurrency, formatPDFDate } from './utils';

// With these lines instead:
import * as pdfMakeModule from 'pdfmake/build/pdfmake';
import * as pdfFontsModule from 'pdfmake/build/vfs_fonts';
import { format } from 'path';
import { armmBase64, armmWatermarkBase64 } from './logos';

// Get the correct reference to pdfMake
const pdfMake = (pdfMakeModule as any).default || pdfMakeModule as any;
// Properly initialize the virtual file system
pdfMake.vfs = (pdfFontsModule as any).pdfMake?.vfs;

const functions = getFunctions();

export class DatabaseService {
  private db = getFirestore(app);
  private clientsCollection: CollectionReference<DocumentData>;
  private cidArray: string[] = [];

  constructor() {
    this.clientsCollection = collection(this.db, config.FIRESTORE_ACTIVE_USERS_COLLECTION);
    this.initCIDArray();
  }

  // ============================================
  //           Helper & Utility Methods
  // ============================================

  /** Initializes the cidArray with client IDs from Firestore */
  async initCIDArray() {
    const querySnapshot = await getDocs(this.clientsCollection);
    for (const docSnap of querySnapshot.docs) {
      this.cidArray.push(docSnap.id);
    }
  }

  /** Generates a unique 8-digit ID by hashing an input string. */
  async hash(input: string): Promise<string> {
    function fnv1aHash(input: string): number {
      let hash = 2166136261;
      for (let i = 0; i < input.length; i++) {
        hash ^= input.charCodeAt(i);
        hash += (hash << 1) + (hash << 4) + (hash << 7) + (hash << 8) + (hash << 24);
      }
      return hash >>> 0;
    }

    const generateUniqueID = (baseID: string): string => {
      let uniqueID = baseID;
      let counter = 1;
      while (this.cidArray.includes(uniqueID)) {
        uniqueID = (parseInt(baseID, 10) + counter).toString().padStart(8, '0');
        counter++;
      }
      return uniqueID;
    };

    const hashValue = fnv1aHash(input);
    const baseID = (hashValue % 100000000).toString().padStart(8, '0');
    const id = generateUniqueID(baseID);
    this.cidArray.push(id);
    return id;
  }

  // ============================================
  //              Client Methods
  // ============================================

  /** Retrieves all clients from Firestore */
  async getClients(): Promise<Client[]> {
    const querySnapshot = await getDocs(this.clientsCollection);
    const clientPromises = querySnapshot.docs.map(async (clientSnapshot) => {
      const assetsSubcollection = collection(this.clientsCollection, clientSnapshot.id, config.ASSETS_SUBCOLLECTION);
      const assetDocs = await getDocs(assetsSubcollection);
      return this.getClientFromSnapshot(clientSnapshot, assetDocs);
    });
    const clients = await Promise.all(clientPromises);
    return clients.filter((client): client is Client => client !== null);
  }

  /** Retrieves a single client by CID */
  async getClient(cid: string): Promise<Client | null> {
    const clientRef = doc(this.db, config.FIRESTORE_ACTIVE_USERS_COLLECTION, cid);
    const clientSnapshot = await getDoc(clientRef);
    const assetsSubcollection = collection(this.clientsCollection, cid, config.ASSETS_SUBCOLLECTION);
    const assetDocs = await getDocs(assetsSubcollection);
    return this.getClientFromSnapshot(clientSnapshot, assetDocs);
  }

  /** Converts a Firestore snapshot into a Client object */
  private getClientFromSnapshot(
    clientSnapshot: DocumentSnapshot,
    assetDocs: any
  ): Client | null {
    if (!clientSnapshot.exists()) return null;
    const data = clientSnapshot.data();
    let generalAssetsData: any = {};
    const funds: { [fundName: string]: { [assetType: string]: AssetDetails } } = {};

    assetDocs.forEach((docItem: any) => {
      if (docItem.id === config.ASSETS_GENERAL_DOC_ID) {
        generalAssetsData = docItem.data();
      } else {
        funds[docItem.id] = this.parseAssetsData(docItem.data());
      }
    });

    const client: Client = {
      cid: clientSnapshot.id,
      uid: data?.uid ?? '',
      firstName: data?.firstName ?? '',
      lastName: data?.lastName ?? '',
      companyName: data?.companyName ?? '',
      address: data?.address ?? '',
      province: data?.province ?? '',
      state: data?.state ?? '',
      street: data?.street ?? '',
      city: data?.city ?? '',
      zip: data?.zip ?? '',
      country: data?.country ?? '',
      dob: data?.dob?.toDate() ?? null,
      initEmail: data?.initEmail ?? data?.email ?? '',
      appEmail: data?.appEmail ?? data?.email ?? 'Client has not logged in yet',
      connectedUsers: data?.connectedUsers ?? [],
      totalAssets: generalAssetsData.total ?? 0,
      ytd: generalAssetsData.ytd ?? 0,
      totalYTD: generalAssetsData.totalYTD ?? 0,
      phoneNumber: data?.phoneNumber ?? '',
      firstDepositDate: data?.firstDepositDate?.toDate() ?? null,
      beneficiaries: data?.beneficiaries ?? [],
      linked: data?.linked ?? false,
      lastLoggedIn:
        data?.lastLoggedIn instanceof Timestamp
          ? formatDate(data.lastLoggedIn.toDate())
          : (data?.uid ? 'Before 01/25' : 'N/A'),
      _selected: false,
      notes: data?.notes ?? '',
      assets: funds,
    };
    return client;
  }

  /** Parses asset data for a fund document */
  private parseAssetsData(assetsData: any): { [assetType: string]: AssetDetails } {
    const parsedAssets: { [assetType: string]: AssetDetails } = {};
    Object.keys(assetsData).forEach((assetType) => {
      if (assetType !== 'fund' && assetType !== 'total') {
        const asset = assetsData[assetType];
        parsedAssets[assetType] = {
          amount: asset.amount ?? 0,
          firstDepositDate: asset.firstDepositDate?.toDate?.() ?? null,
          displayTitle: asset.displayTitle ?? '',
          index: asset.index ?? 0,
        };
      }
    });
    return parsedAssets;
  }

  /** Creates a new client in Firestore */
  async createClient(newClient: Client): Promise<void> {
    const newClientDocId = await this.hash(
      newClient.firstName + '-' + newClient.lastName + '-' + newClient.initEmail
    );
    newClient = { ...newClient, cid: newClientDocId };
    await this.setClient(newClient);
    // Optionally, add initial asset-related activities here.
  }

  /** Writes (or updates) a client document along with its assets */
  async setClient(client: Client): Promise<void> {
    let newClientDocData: DocumentData = { ...client };
    ['email', 'cid', 'assets', 'activities', 'totalAssets', 'graphPoints', 'ytd', 'totalYTD'].forEach(key => {
      delete newClientDocData[key];
    });
    newClientDocData = Object.fromEntries(
      Object.entries(newClientDocData).filter(([_, value]) => value !== undefined)
    );
    const clientRef = doc(this.db, config.FIRESTORE_ACTIVE_USERS_COLLECTION, client.cid);
    await setDoc(clientRef, newClientDocData, { merge: true });
    await this.setAssets(client);
  }

  /** Updates asset subcollections for a client */
  async setAssets(client: Client): Promise<void> {
    const clientRef = doc(this.db, config.FIRESTORE_ACTIVE_USERS_COLLECTION, client.cid);
    const assetCollectionRef = collection(clientRef, config.ASSETS_SUBCOLLECTION);
    let totalAllFunds = 0;
    for (const [fundName, fundAssets] of Object.entries(client.assets)) {
      let fundTotal = 0;
      const fundDoc: any = { fund: fundName };
      Object.keys(fundAssets).forEach((assetType) => {
        const asset = fundAssets[assetType];
        fundDoc[assetType] = {
          amount: asset.amount,
          firstDepositDate: asset.firstDepositDate 
            ? asset.firstDepositDate instanceof Date 
              ? Timestamp.fromDate(asset.firstDepositDate) 
              : asset.firstDepositDate 
            : null,
          displayTitle: asset.displayTitle,
          index: asset.index,
        };
        fundTotal += asset.amount;
      });
      fundDoc.total = fundTotal;
      totalAllFunds += fundTotal;
      const fundRef = doc(assetCollectionRef, fundName);
      await setDoc(fundRef, fundDoc, { merge: true });
    }
    const generalRef = doc(assetCollectionRef, config.ASSETS_GENERAL_DOC_ID);
    const general = {
      ytd: client.ytd ?? 0,
      totalYTD: client.totalYTD ?? 0,
      total: totalAllFunds,
    };
    await setDoc(generalRef, general, { merge: true });
  }

  /** Deletes a client document */
  async deleteClient(cid: string | undefined): Promise<void> {
    if (!cid) {
      console.log('No value provided for CID');
      return;
    }
    const clientRef = doc(this.db, config.FIRESTORE_ACTIVE_USERS_COLLECTION, cid);
    await deleteDoc(clientRef);
  }

  /** Unlinks a client’s user account via a Cloud Function */
  async unlinkClient(client: Client): Promise<void> {
    const unlinkUser = httpsCallable<{ cid: string; uid: string; usersCollectionID: string }, { success: boolean }>(
      functions,
      'unlinkUser'
    );
    try {
      const result = await unlinkUser({
        cid: client.cid,
        uid: client.uid,
        usersCollectionID: config.FIRESTORE_ACTIVE_USERS_COLLECTION,
      });
      console.log('Unlink user success:', result.data.success);
      if (!result.data.success) {
        throw new Error('Failed to unlink user.');
      }
    } catch (error) {
      console.error('Error unlinking user:', error);
      throw new Error('Failed to unlink user.');
    }
  }

  /** Updates an existing client */
  async updateClient(updatedClient: Client): Promise<void> {
    await this.setClient(updatedClient);
  }

  /** Retrieves YTD value via a Cloud Function */
  async getYTD(cid: string): Promise<number> {
    const calculateYTD = httpsCallable<{ cid: string; usersCollectionID: string }, { ytd: number }>(
      functions,
      'calculateYTD'
    );
    try {
      const result = await calculateYTD({ cid, usersCollectionID: config.FIRESTORE_ACTIVE_USERS_COLLECTION });
      console.log('YTD Total:', result.data);
      return result.data as unknown as number;
    } catch (error) {
      console.error('Error updating YTD:', error);
      throw new Error('Failed to update YTD.');
    }
  }

  /** Retrieves Total YTD value via a Cloud Function */
  async getTotalYTD(cid: string): Promise<number> {
    const calculateYTD = httpsCallable<{ cid: string; usersCollectionID: string }, { ytdTotal: number }>(
      functions,
      'calculateTotalYTD'
    );
    try {
      const result = await calculateYTD({ cid, usersCollectionID: config.FIRESTORE_ACTIVE_USERS_COLLECTION });
      console.log('Total YTD:', result.data.ytdTotal);
      return result.data as unknown as number;
    } catch (error) {
      console.error('Error updating Total YTD:', error);
      throw new Error('Failed to update Total YTD.');
    }
  }

  // ============================================
  //            Activity Methods
  // ============================================

  /** Retrieves all activities from Firestore */
  async getActivities(): Promise<Activity[]> {
    const activitiesCollectionGroup = collectionGroup(this.db, config.ACTIVITIES_SUBCOLLECTION);
    const q = query(activitiesCollectionGroup, where('parentCollection', '==', config.FIRESTORE_ACTIVE_USERS_COLLECTION));
    const querySnapshot = await getDocs(q);
    const activities: Activity[] = querySnapshot.docs.map((docSnap) => {
      const data = docSnap.data() as Activity;
      const parentPath = docSnap.ref.parent.path.split('/');
      const parentDocId = parentPath[parentPath.length - 2];
      let formattedTime = '';
      const time = data.time instanceof Timestamp ? data.time.toDate() : data.time;
      if (time instanceof Date) {
        formattedTime = formatDate(time);
      }
      return {
        ...data,
        id: docSnap.id,
        parentDocId,
        formattedTime,
      };
    });
    return activities;
  }

  /** Creates a new activity under a specified client */
  async createActivity(activity: Activity, cid: string): Promise<void> {
    const clientRef = doc(this.db, config.FIRESTORE_ACTIVE_USERS_COLLECTION, cid);
    const activityCollectionRef = collection(clientRef, config.ACTIVITIES_SUBCOLLECTION);
    const activityWithParentId = { ...activity, parentCollection: config.FIRESTORE_ACTIVE_USERS_COLLECTION };
    const filteredActivity = Object.fromEntries(
      Object.entries(activityWithParentId).filter(([_, v]) => v !== undefined)
    );
    await addDoc(activityCollectionRef, filteredActivity);
  }

  /** Updates an activity document */
  async setActivity(activity: Activity, {activityDocId}: {activityDocId?: string}, cid: string): Promise<void> {
    const clientRef = doc(this.db, config.FIRESTORE_ACTIVE_USERS_COLLECTION, cid);
    const activityCollectionRef = collection(clientRef, config.ACTIVITIES_SUBCOLLECTION);
    const activityRef = doc(activityCollectionRef, activityDocId);
    await setDoc(activityRef, activity);
  }

  /** Deletes an activity */
  async deleteActivity(activity: Activity): Promise<void> {
    const cid = activity.parentDocId!;
    const activityDocID = activity.id!;
    try {
      const clientRef = doc(this.db, config.FIRESTORE_ACTIVE_USERS_COLLECTION, cid);
      const activityCollectionRef = collection(clientRef, config.ACTIVITIES_SUBCOLLECTION);
      const activityRef = doc(activityCollectionRef, activityDocID);
      await deleteDoc(activityRef);
    } catch (error) {
      console.error('Failed to delete activity:', error);
      throw error;
    }
  }

  /** Deletes any notifications related to a given activity */
  async deleteNotification(activity: Activity): Promise<void> {
    const cid = activity.parentDocId!;
    const clientRef = doc(this.db, config.FIRESTORE_ACTIVE_USERS_COLLECTION, cid);
    const notificationsCollectionRef = collection(clientRef, config.NOTIFICATIONS_SUBCOLLECTION);
    const q = query(notificationsCollectionRef, where('activityId', '==', activity.id));
    const querySnapshot = await getDocs(q);
    if (!querySnapshot.empty) {
      const batch = writeBatch(this.db);
      querySnapshot.forEach((docSnap) => {
        batch.delete(docSnap.ref);
      });
      await batch.commit();
    }
  }

  // ============================================
  //         Scheduled Activity Methods
  // ============================================

  /** Retrieves scheduled activities from Firestore */
  getScheduledActivities = async () => {
      const scheduledActivitiesCollection = collection(this.db, config.SCHEDULED_ACTIVITIES_COLLECTION);
      // const querySnapshot = await getDocs(scheduledActivitiesCollection);
      const q = query(scheduledActivitiesCollection, where('usersCollectionID', '==', config.FIRESTORE_ACTIVE_USERS_COLLECTION));
      const querySnapshot = await getDocs(q)

      const scheduledActivities: ScheduledActivity[] = querySnapshot.docs.map((doc) => {
          const data = doc.data() as ScheduledActivity;

          // Format the time field
          let formattedTime = '';
          const time = data.activity.time instanceof Timestamp ? data.activity.time.toDate() : data.activity.time;
          if (time instanceof Date) {
              formattedTime = formatDate(time);
          }

          // Process changed assets if they exist
          const processedChangedAssets = data.changedAssets ? { ...data.changedAssets } : null;
          if (processedChangedAssets) {
              Object.keys(processedChangedAssets).forEach((fundName) => {
                  const fund = processedChangedAssets[fundName];
                  Object.keys(fund).forEach((assetType) => {
                      if (fund[assetType].firstDepositDate && fund[assetType].firstDepositDate instanceof Timestamp) {
                          fund[assetType].firstDepositDate = fund[assetType].firstDepositDate.toDate();
                      }
                  });
              });
          }

          return {
              ...data,
              changedAssets: processedChangedAssets,
              id: doc.id,
              formattedTime,
              activity: {
                  ...data.activity,
                  formattedTime,
                  parentDocId: data.cid,
              },
          };
      });

      return scheduledActivities;
  }

  /**
   * Schedules an activity by adding it to the 'scheduledActivities' collection.
   *
   * @param scheduledActivity - The activity data along with scheduling details.
   * @returns A promise that resolves when the scheduled activity is added.
   */
  async scheduleActivity(activity: Activity, clientState: Client, changedAssets: Assets | null): Promise<void> {
      delete activity.id;
      // Add the parentCollectionId field to the activity
      const activityWithParentId = {
          ...activity,
          parentCollection: config.FIRESTORE_ACTIVE_USERS_COLLECTION,
      };
      
      // Filter out undefined properties
      const filteredActivity = Object.fromEntries(
          Object.entries(activityWithParentId).filter(([_, v]) => v !== undefined)
      );

      const scheduledActivity = {
          cid: clientState.cid,
          scheduledTime: filteredActivity.time,
          activity: { ...filteredActivity, parentName: clientState.firstName + ' ' + clientState.lastName },
          changedAssets,
          usersCollectionID: config.FIRESTORE_ACTIVE_USERS_COLLECTION,
          status: 'pending',
      };

      // Add the scheduled activity to the 'scheduledActivities' collection
      await addDoc(collection(this.db, 'scheduledActivities'), scheduledActivity);
  }

  async updateScheduledActivity(id: string | undefined, updatedActivity: Activity, clientState: Client, changedAssets: Assets | null) {
      const docRef = doc(this.db, config.SCHEDULED_ACTIVITIES_COLLECTION, id ?? '');

      const activityWithParentId = { 
          ...updatedActivity,
          parentCollection: config.FIRESTORE_ACTIVE_USERS_COLLECTION,
      }
      const filteredActivity = Object.fromEntries(
          Object.entries(activityWithParentId).filter(([_, v]) => v !== undefined)
      );
      const updatedScheduledActivity = {
          cid: clientState.cid,
          scheduledTime: filteredActivity.time,
          activity: { ...filteredActivity, parentName: clientState.firstName + ' ' + clientState.lastName },
          changedAssets,
          usersCollectionID: config.FIRESTORE_ACTIVE_USERS_COLLECTION,
          status: 'pending',
      };
      await setDoc(docRef, updatedScheduledActivity, { merge: true });
  }

  async deleteScheduledActivity(id: string) {
      const docRef = doc(this.db, 'scheduledActivities', id);
      await deleteDoc(docRef);
  }

  // ============================================
  //             Statement Methods
  // ============================================

  /**
   * Retrieves graph points for a specific client
   */
  async getClientGraphPoints(cid: string): Promise<GraphPoint[]> {
    try {
      const clientRef = doc(this.db, config.FIRESTORE_ACTIVE_USERS_COLLECTION, cid);
      const graphPointsCollectionRef = collection(clientRef, config.GRAPHPOINTS_SUBCOLLECTION);
      const querySnapshot = await getDocs(graphPointsCollectionRef);
      
      const graphPoints: GraphPoint[] = [];
      querySnapshot.forEach((doc) => {
        const data = doc.data();
        graphPoints.push({
          id: doc.id,
          time: data.time,
          amount: data.amount || 0,
          type: data.type,
          cashflow: data.cashflow || 0,
          account: data.account
        });
      });
      
      return graphPoints;
    } catch (error) {
      console.error('Error fetching graph points:', error);
      return [];
    }
  }
  
  /**
   * Generates a PDF Statement for a client given a start/end date.
   * The statement includes all activities in the specified date range.
   */
  public async generateStatementPDF(
    client: Client,
    startDate: Date,
    endDate: Date,
    selectedAccount: string // Added selectedAccount parameter
  ): Promise<void> {
    // 1. Find starting balance from graph points
    const graphPoints = await this.getClientGraphPoints(client.cid);
    
    // Find the last graph point before startDate with selectedAccount
    const startingPointArray = graphPoints
      .filter(point => {
        const pointDate = point.time instanceof Timestamp ? point.time.toDate() : point.time;
        return pointDate && 
               pointDate < startDate && 
               point.account === selectedAccount;
      })
      .sort((a, b) => {
        const dateA = a.time instanceof Timestamp ? a.time.toDate() : (a.time || new Date(0));
        const dateB = b.time instanceof Timestamp ? b.time.toDate() : (b.time || new Date(0));
        return dateB.getTime() - dateA.getTime(); // Sort descending to get most recent first
      });
    
    // Set starting balance (use the most recent point before startDate, or 0 if none exists)
    let runningBalance = startingPointArray.length > 0 ? startingPointArray[0].amount : 0;

    // 2. Get client's activities within the date range
    const clientRef = doc(this.db, config.FIRESTORE_ACTIVE_USERS_COLLECTION, client.cid);
    const activitiesCollection = collection(clientRef, config.ACTIVITIES_SUBCOLLECTION);
    
    let activitiesQuery;
    if (selectedAccount === "Cumulative") {
      activitiesQuery = query(activitiesCollection);
    } else {
      activitiesQuery = query(activitiesCollection, where("recipient", "==", selectedAccount));
    }
    const activitiesSnapshot = await getDocs(activitiesQuery);
    
    const activities: Activity[] = [];
    activitiesSnapshot.forEach(doc => {
      const data = doc.data();
      activities.push({
        id: doc.id,
        time: data.time,
        type: data.type,
        amount: data.amount || 0,
        parentDocId: client.cid,
        isDividend: data.isDividend || false,
      });
    });
    
    // Filter activities within date range
    const filteredActivities = activities.filter(activity => {
      const activityDate = activity.time instanceof Timestamp ? activity.time.toDate() : activity.time;
      return activityDate && activityDate >= startDate && activityDate <= endDate;
    });
    
    // Sort activities by date
    filteredActivities.sort((a, b) => {
      const dateA = a.time instanceof Timestamp ? a.time.toDate() : (a.time || new Date(0));
      const dateB = b.time instanceof Timestamp ? b.time.toDate() : (b.time || new Date(0));
      return dateA.getTime() - dateB.getTime();
    });
    
    // Create formatted activities with running balance
    const formattedActivities = filteredActivities.map(activity => {
      const activityDate = activity.time instanceof Timestamp ? activity.time.toDate() : activity.time;
      const amount = activity.amount || 0;

      console.log(`isDividend: ${activity.isDividend}`);

      // Update running balance based on activity type
      runningBalance = runningBalance + (activity.type == 'withdrawal'
        ? -1
        : (activity.type == 'profit' && !activity.isDividend 
          ? 0
          : 1)) * amount;
      
      return {
        date: activityDate ? formatPDFDate(activityDate) : 'N/A',
        type: activity.type || 'Transaction',
        amount: amount,
        formattedCashflow: (activity.type === 'withdrawal' ? '-' : '') + formatCurrency(amount),
        balance: runningBalance
      };
    });

    // Find the last graph point before or at endDate with selectedAccount
    const endingPointArray = graphPoints
      .filter(point => {
        const pointDate = point.time instanceof Timestamp ? point.time.toDate() : point.time;
        return pointDate && 
               pointDate <= endDate && 
               point.account === selectedAccount;
      })
      .sort((a, b) => {
        const dateA = a.time instanceof Timestamp ? a.time.toDate() : (a.time || new Date(0));
        const dateB = b.time instanceof Timestamp ? b.time.toDate() : (b.time || new Date(0));
        return dateB.getTime() - dateA.getTime(); // Sort descending to get most recent first
      });
    const endingBalance = endingPointArray.length > 0
      ? endingPointArray[0].amount
      : (formattedActivities.length > 0 ? formattedActivities[formattedActivities.length - 1].balance : runningBalance);

    const letterhead = {
      image: armmBase64,
      width: 110,
      alignment: 'center',
      margin: [0, 0, 0, 20],
    };
      // 3. Build the PDF document definition
    const docDefinition: any = {
      pageSize: 'LETTER',
      pageMargins: [40, 60, 40, 60],
      background: function (_currentPage: number, pageSize: any) {
          /*
            * Watermark: 110 % page width, rotated –45 °, and **truly centered**.
            * Original logo aspect ratio ≈ 28 : 16 (width : height).
            */
          const wmWidth  = pageSize.width * 0.7;
          const wmRatio  = 16 / 28;                 // height / width
          const wmHeight = wmWidth * wmRatio;

          return {
              image: armmWatermarkBase64,
              width: wmWidth,
              opacity: 0.1,
              absolutePosition: {
                  x: (pageSize.width  - wmWidth)  / 2,
                  y: (pageSize.height - wmHeight) / 2
              }
          };
      },
      footer: (currentPage: number, pageCount: number) => {
        return {
          columns: [
            {
              text: [
                { text: '6800 Jericho Turnpike, Suite 120W, Syosset, NY 11791\n', style: 'footerText' },
                { text: 'Contact: info@armmgroup.com', style: 'footerText' }
              ],
              alignment: 'center',
              margin: [0, 20, 0, 0], // Increased top margin for better spacing
            },
          ],
        };
      },
      content: [
        letterhead,
        // Statement Header
        {
          text: 'Account Statement',
          style: 'header',
          alignment: 'center',
          margin: [0, 0, 0, 15],
        },
        
        // Client Information Section
        {
          style: 'infoSection',
          margin: [0, 0, 0, 20],
          layout: {
            fillColor: function(i: number) { return (i % 2 === 0) ? '#f8f8f8' : null; }
          },
          table: {
            widths: ['50%', '50%'],
            body: [
              [
                { text: 'Investor:', style: 'labelText' }, 
                { text: `${client.firstName} ${client.lastName}`, style: 'valueText' }
              ],
              [
                { text: 'Client Since:', style: 'labelText' }, 
                { text: client.firstDepositDate ? formatPDFDate(client.firstDepositDate) : 'N/A', style: 'valueText' }
              ],
              [
                { text: 'Statement Period:', style: 'labelText' }, 
                { text: `${formatPDFDate(startDate)} - ${formatPDFDate(endDate)}`, style: 'valueText' }
              ],
            ]
          },
        },
        
        // Statement Summary
        {
          text: 'Statement Summary',
          style: 'subheader',
          margin: [0, 0, 0, 10],
        },
        {
          style: 'summaryTable',
          table: {
            widths: ['70%', '30%'],
            body: [
              [
                { text: 'Investment Account Total Balance:', style: 'labelText' }, 
                { text: formatCurrency(endingBalance), style: 'valueText', alignment: 'right' }
              ],
            ]
          },
          layout: 'noBorders'
        },
        
        // Transaction History Table
        {
          text: 'Transaction History',
          style: 'subheader',
          margin: [0, 20, 0, 10],
        },
        {
          table: {
            headerRows: 1,
            widths: ['25%', '25%', '25%', '25%'],
            body: [
              // Table Header
              [
                { text: 'Date', style: 'tableHeader', alignment: 'center' },
                { text: 'Type', style: 'tableHeader', alignment: 'center' },
                { text: 'Cashflow', style: 'tableHeader', alignment: 'center' },
                { text: 'Balance', style: 'tableHeader', alignment: 'center' },
              ],
              // Starting Balance Row
              [
                { text: 'Starting Balance', alignment: 'center' },
                { text: '', alignment: 'center' },
                { text: '', alignment: 'center' },
                { text: formatCurrency(startingPointArray.length > 0 ? startingPointArray[0].amount : 0), alignment: 'center' },
              ],
              // Table Rows
              ...formattedActivities.map((activity) => [
                { text: activity.date, alignment: 'center' },
                { text: toSentenceCase(activity.type), alignment: 'center' },
                { 
                  text: activity.formattedCashflow, 
                  alignment: 'center',
                },
                { 
                  text: formatCurrency(activity.balance), 
                  alignment: 'center',
                },
              ]),
            ],
          },
          // Full border layout
          layout: {
            hLineWidth: function() { return 1; },
            vLineWidth: function() { return 1; },
            hLineColor: function() { return '#dddddd'; },
            vLineColor: function() { return '#dddddd'; },
          },
          // Center the table
          alignment: 'center',
          margin: [0, 0, 0, 20],
        },
      ],
      
      // Styles
      styles: {
        header: {
          fontSize: 22,
          bold: true,
          color: '#2B41B8',
        },
        subheader: {
          fontSize: 16,
          bold: true,
          margin: [0, 5, 0, 5],
        },
        small: {
          fontSize: 10,
        },
        tableHeader: {
          bold: true,
          fontSize: 12,
          color: 'black',
          fillColor: '#f8f8f8',
          margin: [0, 5, 0, 5],
        },
        labelText: {
          bold: true,
          fontSize: 11,
        },
        valueText: {
          fontSize: 11,
        },
        summaryTable: {
          margin: [0, 0, 0, 10],
        },
        footerText: { // Style for the address and contact info
          fontSize: 10,
          color: '#2B41B8', // Blue color like the header
          italics: true,
        },
        footerPageNum: { // Style for the page number
          fontSize: 10,
          color: '#2B41B8',
        }
      },
    };
  
    // 4. Generate and open the PDF
    const pdfDocGenerator = pdfMake.createPdf(docDefinition);
    pdfDocGenerator.open();
  }

}

export * from './models';
export * from './utils';
