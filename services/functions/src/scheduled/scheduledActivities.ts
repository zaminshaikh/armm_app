/**
 * @file scheduledActivities.ts
 * @description Cloud Function (Pub/Sub scheduled) that processes scheduled
 *              activity documents. If a scheduled time has arrived, it creates
<<<<<<< HEAD
<<<<<<< HEAD
 *              real activities and updates user assets, then marks them 'completed'.
=======
 *              actual activities and updates user assets, then marks them 'completed'.
>>>>>>> 6543ce9 (Imported CF from AGQ)
=======
 *              real activities and updates user assets, then marks them 'completed'.
>>>>>>> 3ccfbe5 (feat(scheduledActivities): dynamic asset updates for multiple funds)
 */

import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
<<<<<<< HEAD
import config from "../../config.json";
=======
import config from "../../lib/config.json";
>>>>>>> 6543ce9 (Imported CF from AGQ)

const db = admin.firestore();

/**
 * Scheduled: Runs every 12 hours (adjust as needed) to check for scheduled activities
<<<<<<< HEAD
<<<<<<< HEAD
 * where scheduledTime <= now and status == 'pending'.
 *
 * For each match:
 *  1) Creates a real Activity in the user's subcollection.
 *  2) Optionally updates clientState (any funds, YTD, totalYTD, etc.).
 *  3) Marks the scheduled activity doc as 'completed'.
=======
 * where scheduledTime <= now and status == 'pending'. 
 * 
 * For each match:
 * 1) Creates a real Activity in the user's subcollection.
 * 2) Optionally updates clientState (assets, ytd, totalYTD, etc.).
 * 3) Marks the scheduled activity doc as 'completed'.
>>>>>>> 6543ce9 (Imported CF from AGQ)
=======
 * where scheduledTime <= now and status == 'pending'.
 *
 * For each match:
 *  1) Creates a real Activity in the user's subcollection.
 *  2) Optionally updates clientState (any funds, YTD, totalYTD, etc.).
 *  3) Marks the scheduled activity doc as 'completed'.
>>>>>>> 3ccfbe5 (feat(scheduledActivities): dynamic asset updates for multiple funds)
 */
export const processScheduledActivities = functions.pubsub
  .schedule("0 */12 * * *") // Runs every 12 hours
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const scheduledActivitiesRef = db.collection("scheduledActivities");

<<<<<<< HEAD
<<<<<<< HEAD
    // Find all scheduled activities that are pending and due
=======
    // Find all scheduled activities that are pending and are due
>>>>>>> 6543ce9 (Imported CF from AGQ)
=======
    // Find all scheduled activities that are pending and due
>>>>>>> 3ccfbe5 (feat(scheduledActivities): dynamic asset updates for multiple funds)
    const querySnapshot = await scheduledActivitiesRef
      .where("scheduledTime", "<=", now)
      .where("status", "==", "pending")
      .get();

    if (querySnapshot.empty) {
      console.log("No scheduled activities to process at this time.");
      return null;
    }

    const batch = db.batch();
    console.log(`Found ${querySnapshot.size} scheduled activities to process.`);

<<<<<<< HEAD
<<<<<<< HEAD
=======
    // Process each pending doc
>>>>>>> 6543ce9 (Imported CF from AGQ)
=======
>>>>>>> 3ccfbe5 (feat(scheduledActivities): dynamic asset updates for multiple funds)
    querySnapshot.forEach((doc) => {
      const data = doc.data();
      const { cid, activity, clientState, usersCollectionID } = data;

      // Validate essential fields
      if (!cid || !activity) {
        console.error(`Scheduled activity ${doc.id} missing 'cid' or 'activity'.`);
        return;
      }

      // 1) Create the actual activity in user's subcollection
      const clientRef = db.collection(usersCollectionID).doc(cid);
      const activitiesRef = clientRef.collection(config.ACTIVITIES_SUBCOLLECTION);
      const newActivityRef = activitiesRef.doc(); // auto-generated doc ID

      batch.set(newActivityRef, {
        ...activity,
        parentCollection: usersCollectionID,
        formattedTime: admin.firestore.FieldValue.serverTimestamp(),
      });

<<<<<<< HEAD
<<<<<<< HEAD
      // 2) If clientState is provided, update the user's asset docs for ALL funds dynamically
      if (clientState) {
        const assetCollectionRef = clientRef.collection(config.ASSETS_SUBCOLLECTION);

        // Helper to shape the doc updates for a single fund
=======
      // 2) If clientState is provided, we update the user's asset docs
      if (clientState) {
        const assetCollectionRef = clientRef.collection(config.ASSETS_SUBCOLLECTION);

        // Helper to shape the doc updates
>>>>>>> 6543ce9 (Imported CF from AGQ)
=======
      // 2) If clientState is provided, update the user's asset docs for ALL funds dynamically
      if (clientState) {
        const assetCollectionRef = clientRef.collection(config.ASSETS_SUBCOLLECTION);

        // Helper to shape the doc updates for a single fund
>>>>>>> 3ccfbe5 (feat(scheduledActivities): dynamic asset updates for multiple funds)
        const prepareAssetDoc = (assets: any, fundName: string) => {
          let total = 0;
          const docObj: any = { fund: fundName };
          for (const key of Object.keys(assets)) {
            const asset = assets[key];
            docObj[key] = {
              amount: asset.amount,
<<<<<<< HEAD
<<<<<<< HEAD
              firstDepositDate: asset.firstDepositDate ? 
                admin.firestore.Timestamp.fromDate(asset.firstDepositDate) : 
                null,
=======
              firstDepositDate: asset.firstDepositDate
                ? admin.firestore.Timestamp.fromDate(asset.firstDepositDate)
                : null,
>>>>>>> 6543ce9 (Imported CF from AGQ)
=======
              firstDepositDate: asset.firstDepositDate ? 
                admin.firestore.Timestamp.fromDate(asset.firstDepositDate) : 
                null,
>>>>>>> 0080eca (update ESLint rules and improve code formatting across multiple files)
              displayTitle: asset.displayTitle,
              index: asset.index,
            };
            total += asset.amount;
          }
          docObj.total = total;
          return docObj;
        };

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 3ccfbe5 (feat(scheduledActivities): dynamic asset updates for multiple funds)
        // We’ll iterate over all fund keys in clientState.assets
        const allFunds = Object.keys(clientState.assets || {});
        let sumOfAllFunds = 0;

        allFunds.forEach((fundKey) => {
          const fundAssets = clientState.assets[fundKey];
          // For convenience, store the capitalized or original fundKey in "docObj.fund"
          const fundDocData = prepareAssetDoc(fundAssets, fundKey.toUpperCase());
          sumOfAllFunds += fundDocData.total;

          // For simplicity, let's assume we just name the doc the same as the fundKey:
          const docRef = assetCollectionRef.doc(fundKey);

          // Add this update to the batch
          batch.set(docRef, fundDocData, { merge: true });
        });

        // Now update the 'general' doc with updated total, ytd, totalYTD
        const genRef = assetCollectionRef.doc(config.ASSETS_GENERAL_DOC_ID);
        const generalData = {
<<<<<<< HEAD
          ytd: clientState.ytd ?? 0,
          totalYTD: clientState.totalYTD ?? 0,
          total: sumOfAllFunds,
        };
        batch.set(genRef, generalData, { merge: true });
=======
        // Recreate AGQ doc, AK1 doc, and general doc
        const agqDoc = prepareAssetDoc(clientState.assets.agq, "AGQ");
        const ak1Doc = prepareAssetDoc(clientState.assets.ak1, "AK1");
        const general = {
=======
>>>>>>> 3ccfbe5 (feat(scheduledActivities): dynamic asset updates for multiple funds)
          ytd: clientState.ytd ?? 0,
          totalYTD: clientState.totalYTD ?? 0,
          total: sumOfAllFunds,
        };
<<<<<<< HEAD

        const agqRef = assetCollectionRef.doc(config.ASSETS_AGQ_DOC_ID);
        const ak1Ref = assetCollectionRef.doc(config.ASSETS_AK1_DOC_ID);
        const genRef = assetCollectionRef.doc(config.ASSETS_GENERAL_DOC_ID);

        batch.update(agqRef, agqDoc);
        batch.update(ak1Ref, ak1Doc);
        batch.update(genRef, general);
>>>>>>> 6543ce9 (Imported CF from AGQ)
=======
        batch.set(genRef, generalData, { merge: true });
>>>>>>> 3ccfbe5 (feat(scheduledActivities): dynamic asset updates for multiple funds)
      }

      // 3) Mark this scheduled doc as 'completed'
      const scheduledActivityRef = scheduledActivitiesRef.doc(doc.id);
      batch.update(scheduledActivityRef, { status: "completed" });
    });

<<<<<<< HEAD
<<<<<<< HEAD
    // Attempt to commit the batch of updates
=======
    // Commit
>>>>>>> 6543ce9 (Imported CF from AGQ)
=======
    // Attempt to commit the batch of updates
>>>>>>> 3ccfbe5 (feat(scheduledActivities): dynamic asset updates for multiple funds)
    try {
      await batch.commit();
      console.log(`Processed ${querySnapshot.size} scheduled activities.`);
    } catch (error) {
      console.error("Error processing scheduled activities:", error);
    }

    return null;
  });