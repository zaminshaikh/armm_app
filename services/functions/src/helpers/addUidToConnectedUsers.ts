/**
 * @file utils.ts
 * @description Contains shared helper utilities for callable functions, such as
 *              linking a user's UID to other user docs (connectedUsers).
 */

import * as admin from "firebase-admin";

/**
 * Adds a newly linked user's UID into the `uidGrantedAccess` array of all connected user documents.
 *
 * @async
 * @function addUidToConnectedUsers
 * @param {string[]} connectedUsers - Array of Firestore doc IDs for users connected to the new user.
 * @param {string} uid - The newly linked user’s Firebase Auth UID.
 * @param {admin.firestore.CollectionReference} usersCollection - A reference to the user collection.
<<<<<<< HEAD
<<<<<<< HEAD
 * @return {Promise<void>} Resolves once all connected docs are updated.
=======
 * @returns {Promise<void>} Resolves once all connected docs are updated.
>>>>>>> 6543ce9 (Imported CF from AGQ)
=======
 * @return {Promise<void>} Resolves once all connected docs are updated.
>>>>>>> 0080eca (update ESLint rules and improve code formatting across multiple files)
 */
export async function addUidToConnectedUsers(
  connectedUsers: string[],
  uid: string,
  usersCollection: admin.firestore.CollectionReference
): Promise<void> {
  const updatePromises = connectedUsers.map(async (connectedUserId) => {
    const connectedUserRef = usersCollection.doc(connectedUserId);
    const connectedUserSnapshot = await connectedUserRef.get();

    if (!connectedUserSnapshot.exists) {
      console.log(`Connected user doc ${connectedUserId} does not exist`);
      return;
    }

    const data = connectedUserSnapshot.data() || {};
    let uidGrantedAccess: string[] = data.uidGrantedAccess || [];

    // Ensure it's an array
    if (!Array.isArray(uidGrantedAccess)) {
      uidGrantedAccess = [];
    }

    // If missing, add the new user's uid
    if (!uidGrantedAccess.includes(uid)) {
      uidGrantedAccess.push(uid);
      await connectedUserRef.update({ uidGrantedAccess });
      console.log(`Added ${uid} to uidGrantedAccess of user ${connectedUserId}`);
    }
  });

  await Promise.all(updatePromises);
}