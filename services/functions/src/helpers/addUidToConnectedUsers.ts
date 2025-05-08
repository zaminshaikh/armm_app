/**
 * @file utils.ts
 * @description Contains shared helper utilities for callable functions, such as
 *              linking a user's UID to other user docs (connectedUsers).
 */

import { CollectionReference, DocumentData } from 'firebase-admin/firestore';

/**
 * Adds a newly linked user's UID into the `uidGrantedAccess` array of all connected user documents.
 *
 * @async
 * @function addUidToConnectedUsers
 * @param {string[]} connectedUsers - Array of Firestore doc IDs for users connected to the new user.
 * @param {string} uid - The newly linked user’s Firebase Auth UID.
 * @param {CollectionReference<DocumentData>} usersCollection - A reference to the user collection.
 * @return {Promise<void>} Resolves once all connected docs are updated.
 */
export async function addUidToConnectedUsers(
  connectedUsers: string[],
  uid: string,
  usersCollection: CollectionReference<DocumentData>
): Promise<void> {
  const updatePromises = connectedUsers.map(async (connectedUserId) => {
    const connectedUserRef = usersCollection.doc(connectedUserId);
    const connectedUserSnapshot = await connectedUserRef.get();
    if (!connectedUserSnapshot.exists) return;

    const data = connectedUserSnapshot.data() || {};
    let uidGrantedAccess: string[] = Array.isArray(data.uidGrantedAccess)
      ? data.uidGrantedAccess
      : [];

    if (!uidGrantedAccess.includes(uid)) {
      uidGrantedAccess.push(uid);
      await connectedUserRef.update({ uidGrantedAccess });
      console.log(`Added ${uid} to uidGrantedAccess of user ${connectedUserId}`);
    }
  });

  await Promise.all(updatePromises);
}