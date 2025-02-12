/**
 * @file assetTriggers.ts
 * @description Contains a Firestore trigger to update the `recipient` field in
 *              a user's activities whenever the displayTitle of an asset changes.
 */

import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
import { QueryDocumentSnapshot } from "firebase-admin/firestore";

const db = admin.firestore();

/**
<<<<<<< HEAD
<<<<<<< HEAD
 * Trigger: onUpdate of a user's asset document
=======
 * Trigger: onUpdate of a user's asset document (e.g., assets/agq or assets/ak1).
>>>>>>> 6543ce9 (Imported CF from AGQ)
=======
 * Trigger: onUpdate of a user's asset document
>>>>>>> 7fba470 (Refactor asset update trigger to dynamically determine fund name from asset data)
 *
 * @description If the displayTitle of an asset changes, we reflect this change
 *              in the "recipient" field of any matching activities.
 */
export const f_onAssetUpdate = functions.firestore
  .document("/{userCollection}/{userId}/assets/{assetId}")
  .onUpdate(async (change, context) => {
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 0080eca (update ESLint rules and improve code formatting across multiple files)
    const { userCollection, userId } = context.params;
    console.log(`f_onAssetUpdate triggered for userCollection: ${userCollection}, userId: ${userId}`);

    const beforeData = change.before.data();
    const afterData = change.after.data();

    const fund = afterData.fund;

=======
    const { userCollection, userId, assetId } = context.params;
    console.log(`onAssetUpdate triggered for userCollection: ${userCollection}, userId: ${userId}`);;

    const beforeData = change.before.data();
    const afterData = change.after.data();

<<<<<<< HEAD
>>>>>>> 6543ce9 (Imported CF from AGQ)
=======
    const fund = afterData.fund;

>>>>>>> 7fba470 (Refactor asset update trigger to dynamically determine fund name from asset data)
    // Helper to filter out the keys "total" and "fund"
    const filterAssetEntries = (obj: object) =>
      Object.entries(obj)
        .filter(([key]) => !["total", "fund"].includes(key))
        .map(([key, value]) => ({ key, ...value }));

    const beforeAssets = filterAssetEntries(beforeData);
    const afterAssets = filterAssetEntries(afterData);

    // Convert the arrays into maps keyed by 'index'
    const beforeByIndex = new Map(beforeAssets.map((a: any) => [a.index, a]));
    const afterByIndex = new Map(afterAssets.map((a: any) => [a.index, a]));

    // Identify assets that changed displayTitle
    const assetsToUpdate = [];
    for (const [index, beforeAsset] of beforeByIndex) {
      const afterAsset = afterByIndex.get(index);
      if (afterAsset && beforeAsset.displayTitle !== afterAsset.displayTitle) {
        assetsToUpdate.push({
          index,
          oldDisplayTitle: beforeAsset.displayTitle,
          newDisplayTitle: afterAsset.displayTitle,
        });
      }
    }

    if (assetsToUpdate.length === 0) {
      console.log("No changes in displayTitles detected.");
      return null;
    }

    // Get the user's actual name (e.g., "John Doe") for the 'Personal' rename logic
    const userDocRef = db.doc(`${userCollection}/${userId}`);
    const userDocSnap = await userDocRef.get();
    const clientData = userDocSnap.data();
    const clientName = clientData ? clientData.name.first + " " + clientData.name.last : null;
    
    if (!clientName) {
      console.error(`Client name not found for user ${userId}`);
      return null;
    }

    // Prepare a batch to update all matching activities
    const activitiesRef = db.collection(`${userCollection}/${userId}/activities`);
    const batch = db.batch();

    for (const { oldDisplayTitle, newDisplayTitle } of assetsToUpdate) {
      // If the new title is "Personal", set it to the client's name
<<<<<<< HEAD
<<<<<<< HEAD
      const updatedNew = newDisplayTitle === "Personal" ? clientName : newDisplayTitle;
      // If the old title is "Personal", set it to the client's name
      const updatedOld = oldDisplayTitle === "Personal" ? clientName : oldDisplayTitle;
=======
      let updatedNew = newDisplayTitle === "Personal" ? clientName : newDisplayTitle;
      // If the old title is "Personal", set it to the client's name
      let updatedOld = oldDisplayTitle === "Personal" ? clientName : oldDisplayTitle;
>>>>>>> 6543ce9 (Imported CF from AGQ)
=======
      const updatedNew = newDisplayTitle === "Personal" ? clientName : newDisplayTitle;
      // If the old title is "Personal", set it to the client's name
      const updatedOld = oldDisplayTitle === "Personal" ? clientName : oldDisplayTitle;
>>>>>>> 0080eca (update ESLint rules and improve code formatting across multiple files)

      // Query all activities where fund == <fund> and recipient == oldDisplayTitle
      const snapshot = await activitiesRef
        .where("fund", "==", fund)
        .where("recipient", "==", updatedOld)
        .get();

      snapshot.forEach((doc: QueryDocumentSnapshot) => {
        // Update each activity's recipient field
        batch.update(doc.ref, { recipient: updatedNew });
      });
    }

    // Commit the batch
    try {
      await batch.commit();
      console.log("Batch commit successful: Updated recipient fields.");
    } catch (error) {
      console.error("Batch commit failed:", error);
    }

    return null;
  });
