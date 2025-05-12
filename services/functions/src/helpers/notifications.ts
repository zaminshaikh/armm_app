/**
 * @file notifications.ts
 * @description Provides helper functions to create and send push notifications
 *              in response to various user activities or system events.
 */

import * as admin from "firebase-admin";
import { Activity } from "../interfaces/activity.interface";
import { Notification } from "../interfaces/notification.interface";
import config from "../../config.json";

const messaging = admin.messaging();

/**
 * Generates a custom string message based on the type of activity.
 *
 * @param {Activity} activity - The activity object which provides data such as fund, amount, type, etc.
 * @return {string} - A user-friendly string that describes the activity event.
 */
export function getActivityMessage(activity: Activity): string {
  let message: string;
  switch (activity.type) {
    case "withdrawal":
      message = `New Withdrawal: ${activity.fund} Fund finished processing the withdrawal of $${activity.amount} from ${activity.recipient}'s account. View the Activity section for more details.`;
      break;
    case "profit":
      message = `New Profit: ${activity.fund} has posted the latest returns for ${activity.recipient}. View the Activity section for more details.`;
      break;
    case "deposit":
      message = `New Deposit: ${activity.fund} has finished processing the deposit of $${activity.amount} into ${activity.recipient}'s account. View the Activity section for more details.`;
      break;
    case "manual-entry":
      message = `New Manual Entry: ${activity.fund} Fund has made a manual entry of $${activity.amount} into your account. View the Activity section for more details.`;
      break;
    default:
      message = "New Activity: A new activity has been created. View the Activity section for more details.";
  }
  return message;
}

/**
 * Creates a new Notification document in Firestore based on a given Activity.
 *
 * @async
 * @param {Activity} activity - The activity data used to build the notification message/title/body.
 * @param {string} cid - The client/user's Firestore document ID.
 * @param {string} activityId - The Firestore document ID of the associated activity.
 * @param {string} usersCollectionID - The collection path for the user documents (e.g., "testUsers").
 * @returns {Promise<{ title: string; body: string; userRef: FirebaseFirestore.DocumentReference }>}
 *          An object containing the notification's title, body, and a userDoc reference.
 */
export async function createNotif(
  activity: Activity,
  cid: string,
  activityId: string,
  usersCollectionID: string
): Promise<{ title: string; body: string; userRef: FirebaseFirestore.DocumentReference }> {
  const userRef = admin.firestore().doc(`${usersCollectionID}/${cid}`);
  const notificationsCollectionRef = userRef.collection(config.NOTIFICATIONS_SUBCOLLECTION);

  // Derive an appropriate message from the activity type
  const message = getActivityMessage(activity);
  // Splitting the message to extract the first portion as "title" if desired
  const [title, body] = message.split(": ", 2);

  const notification: Notification = {
    activityId,
    recipient: activity.recipient,
    title,
    body,
    message,
    isRead: false,
    type: "activity",
    time: admin.firestore.FieldValue.serverTimestamp() as any,
  };

  // Create (add) a new notification document for this user
  await notificationsCollectionRef.add(notification);

  return { title, body, userRef };
}

/**
 * Sends a Firebase Cloud Messaging (FCM) notification to the user's registered device tokens.
 * 
 * @async
 * @function sendNotif
 * @param {string} title - Notification title to display on device.
 * @param {string} body - Notification body text to display on device.
 * @param {FirebaseFirestore.DocumentReference} userRef - Reference to the user’s Firestore document (used to retrieve tokens).
 * @return {Promise<string[]>} A Promise resolving to an array of message IDs that were successfully sent.
 * @throws {Error} If the user has no FCM tokens registered.
 */
export async function sendNotif(
  title: string,
  body: string,
  userRef: FirebaseFirestore.DocumentReference
): Promise<string[]> {
  const userDoc = await userRef.get();
  const userData = userDoc.data();

  // Check if user has token(s)
  if (userData && Array.isArray(userData.tokens) && userData.tokens.length > 0) {
    let tokensToRemove: string[] = [];
    const sendPromises = userData.tokens.map(async (token: string) => {
      console.log(`Sending notification to token: ${token}`);
      const fcmMessage = {
        token,
        notification: { title, body },
      };
      try {
        const response = await messaging.send(fcmMessage);
        console.log(`Successfully sent message to token ${token}:`, response);
        return response; // Successfully sent message ID
      } catch (error) {
        console.error(`Failed to send notification to token ${token}:`, error);
        // If sending failed due to an invalid token, remove it
        if ((error as any).code === 'messaging/registration-token-not-registered' || (error as any).code === 'messaging/invalid-registration-token' || (error as any).code === 'messaging/invalid-argument') {
          tokensToRemove.push(token);
          console.log(`Removed invalid token ${token} for user ${userRef.id}`);
        }
        return null; // Indicate failure for this token  
      }
    });
    const results = await Promise.all(sendPromises);
    await userRef.update({ tokens: userData.tokens.filter((token: string) => !tokensToRemove.includes(token)) });
    // Filter out nulls (failed sends) and return only successful message IDs
    return results.filter((result): result is string => result !== null);
  } else {
    throw new Error("FCM tokens not found");
  }
}