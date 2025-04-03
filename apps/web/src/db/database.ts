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
import { formatDate } from 'src/utils/utilities';
import { emptyClient, emptyActivity, Client, Activity, ScheduledActivity, StatementData, AssetDetails } from './models';
import { roundToNearestHour, formatCurrency } from './utils';

// With these lines instead:
import * as pdfMakeModule from 'pdfmake/build/pdfmake';
import * as pdfFontsModule from 'pdfmake/build/vfs_fonts';

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
          firstDepositDate: asset.firstDepositDate ? Timestamp.fromDate(asset.firstDepositDate) : null,
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
  async getScheduledActivities(): Promise<ScheduledActivity[]> {
    const scheduledActivitiesCollection = collection(this.db, config.SCHEDULED_ACTIVITIES_COLLECTION);
    const q = query(
      scheduledActivitiesCollection,
      where('usersCollectionID', '==', config.FIRESTORE_ACTIVE_USERS_COLLECTION)
    );
    const querySnapshot = await getDocs(q);
    const scheduledActivities: ScheduledActivity[] = querySnapshot.docs.map((docSnap) => {
      const data = docSnap.data() as ScheduledActivity;
      let formattedTime = '';
      const time = data.activity.time instanceof Timestamp ? data.activity.time.toDate() : data.activity.time;
      if (time instanceof Date) {
        formattedTime = formatDate(time);
      }
      return {
        ...data,
        id: docSnap.id,
        activity: {
          ...data.activity,
          formattedTime,
          parentDocId: data.cid,
        },
      };
    });
    return scheduledActivities;
  }

  /** Schedules a new activity */
  async scheduleActivity(activity: Activity, clientState: Client): Promise<void> {
    delete activity.id;
    const activityWithParentId = { ...activity, parentCollection: config.FIRESTORE_ACTIVE_USERS_COLLECTION };
    const filteredActivity = Object.fromEntries(
      Object.entries(activityWithParentId).filter(([_, v]) => v !== undefined)
    );
    const scheduledActivity = {
      cid: clientState.cid,
      scheduledTime: filteredActivity.time,
      activity: { ...filteredActivity, parentName: `${clientState.firstName} ${clientState.lastName}` },
      clientState,
      usersCollectionID: config.FIRESTORE_ACTIVE_USERS_COLLECTION,
      status: 'pending',
    };
    await addDoc(collection(this.db, config.SCHEDULED_ACTIVITIES_COLLECTION), scheduledActivity);
  }

  /** Updates a scheduled activity */
  async updateScheduledActivity(updatedActivity: Activity, clientState: Client): Promise<void> {
    const docRef = doc(this.db, config.SCHEDULED_ACTIVITIES_COLLECTION, updatedActivity.id ?? '');
    delete updatedActivity.id;
    const activityWithParentId = { ...updatedActivity, parentCollection: config.FIRESTORE_ACTIVE_USERS_COLLECTION };
    const filteredActivity = Object.fromEntries(
      Object.entries(activityWithParentId).filter(([_, v]) => v !== undefined)
    );
    const updatedScheduledActivity = {
      cid: clientState.cid,
      scheduledTime: filteredActivity.time,
      activity: { ...filteredActivity, parentName: `${clientState.firstName} ${clientState.lastName}` },
      clientState,
      usersCollectionID: config.FIRESTORE_ACTIVE_USERS_COLLECTION,
      status: 'pending',
    };
    await setDoc(docRef, updatedScheduledActivity, { merge: true });
  }

  /** Deletes a scheduled activity by ID */
  async deleteScheduledActivity(id: string): Promise<void> {
    const docRef = doc(this.db, config.SCHEDULED_ACTIVITIES_COLLECTION, id);
    await deleteDoc(docRef);
  }

  // ============================================
  //             Statement Methods
  // ============================================

  /** Adds a new statement document */
  async addStatement(statement: StatementData): Promise<void> {
    try {
      const statementsCollection = collection(this.db, 'statements');
      await addDoc(statementsCollection, statement);
    } catch (error) {
      console.error('Error adding statement:', error);
      throw error;
    }
  }

  /**
   * Generates a PDF Statement for a client given a start/end date.
   * The statement includes all activities in the specified date range.
   */
  public async generateStatementPDF(
    client: Client,
    startDate: Date,
    endDate: Date
  ): Promise<void> {
    // 1. Retrieve all activities for this client within the specified date range
    const clientRef = doc(this.db, config.FIRESTORE_ACTIVE_USERS_COLLECTION, client.cid);
    const activityCollectionRef = collection(clientRef, config.ACTIVITIES_SUBCOLLECTION);

    const startTimestamp = Timestamp.fromDate(startDate);
    const endTimestamp = Timestamp.fromDate(endDate);

    // Query for activities whose 'time' is between startTimestamp and endTimestamp
    const qActivities = query(
      activityCollectionRef,
      where('time', '>=', startTimestamp),
      where('time', '<=', endTimestamp)
    );

    const querySnapshot = await getDocs(qActivities);
    const filteredActivities: Activity[] = [];

    querySnapshot.forEach((docSnap) => {
      const data = docSnap.data() as Activity;
      // Convert Firestore Timestamp to JS Date if needed
      let activityDate = data.time instanceof Timestamp ? data.time.toDate() : data.time;

      filteredActivities.push({
        ...data,
        id: docSnap.id,
        time: activityDate,
        formattedTime: formatDate(activityDate), // Use your date formatting utility
      });
    });

    // 2. Build the PDF document definition
    const docDefinition: any = {
      pageSize: 'LETTER',
      pageMargins: [40, 60, 40, 60],
      footer: (currentPage: number, pageCount: number) => {
        return {
          columns: [
            {
              text: `Page ${currentPage} of ${pageCount}`,
              alignment: 'center',
              margin: [0, 5, 0, 0],
            },
          ],
        };
      },
      content: [
        // Statement Header
        {
          text: 'Account Statement',
          style: 'header',
          alignment: 'center',
        },
        {
          text: `${client.firstName} ${client.lastName}`,
          style: 'subheader',
          alignment: 'center',
        },
        {
          text: `Statement Period: ${formatDate(startDate)} - ${formatDate(endDate)}`,
          style: 'small',
          alignment: 'center',
          margin: [0, 0, 0, 20],
        },

        // A simple table of Activities
        {
          table: {
            widths: ['auto', 'auto', 'auto'],
            body: [
              // Table Header
              [
                { text: 'Date', style: 'tableHeader' },
                { text: 'Type', style: 'tableHeader' },
                { text: 'Amount', style: 'tableHeader', alignment: 'right' },
              ],

              // Table Rows (one per activity)
              ...filteredActivities.map((activity) => [
                activity.formattedTime ?? '',
                activity.type ?? '',
                {
                  text: activity.amount ? activity.amount.toFixed(2) : '0.00',
                  alignment: 'right',
                },
              ]),
            ],
          },
          layout: 'lightHorizontalLines',
        },
      ],
      styles: {
        header: {
          fontSize: 18,
          bold: true,
        },
        subheader: {
          fontSize: 14,
          margin: [0, 0, 0, 10],
        },
        small: {
          fontSize: 10,
        },
        tableHeader: {
          bold: true,
          fontSize: 11,
          color: 'black',
        },
      },
    };

    // 3. Generate the PDF and download or open it.
    // pdfMake supports several ways to output the PDF.
    // Example: open the PDF in a new browser tab
    const pdfDocGenerator = pdfMake.createPdf(docDefinition);
    pdfDocGenerator.open();

    // Alternatively, you could:
    // pdfDocGenerator.download(`Statement_${client.cid}_${Date.now()}.pdf`);
    // or get the PDF as Base64 data, etc.
  }
}

export * from './models';
export * from './utils';
