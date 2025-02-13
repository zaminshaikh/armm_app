/**
 * @file index.ts
 * @description Main entry point for Firebase Functions. Imports and re-exports
 *              all triggers, callable, and scheduled functions for deployment.
 */

import * as admin from "firebase-admin";

// Initialize Firebase Admin SDK once here
admin.initializeApp();

// ======= TRIGGERS =======
import { f_handleActivity, f_onActivityWrite } from "./triggers/activityTriggers";
import { f_onAssetUpdate } from "./triggers/assetTriggers";
import { f_onConnectedUsersChange } from "./triggers/connectedUsersTriggers";

// ======= SCHEDULED =======
import { f_scheduledYTDReset } from "./scheduled/scheduledReset";
import { f_processScheduledActivities } from "./scheduled/scheduledActivities";

// ======= CALLABLE =======
<<<<<<< HEAD
import { linkNewUser } from "./callable/linkUser";
import { isUIDLinked, checkDocumentExists, checkDocumentLinked } from "./callable/checkDocsAndUID";
import { unlinkUser } from "./callable/unlinkUser";
import { calculateTotalYTD, calculateYTD } from "./callable/ytd";

// Expose Firestore triggers
<<<<<<< HEAD
<<<<<<< HEAD
export { handleActivity, onActivityWrite, onAssetUpdate, onConnectedUsersChange };

// Expose scheduled tasks
export { scheduledYTDReset, processScheduledActivities };

// Expose callable functions
export { linkNewUser, checkDocumentExists, checkDocumentLinked, unlinkUser, isUIDLinked, calculateTotalYTD, calculateYTD };
=======
export const f_handleActivity = handleActivity;
export const f_onActivityWrite = onActivityWrite;
export const f_onAssetUpdate = onAssetUpdate;
export const f_onConnectedUsersChange = onConnectedUsersChange;
=======
export { handleActivity, onActivityWrite, onAssetUpdate, onConnectedUsersChange };
>>>>>>> 0f6084e (Update Google services configuration and dependencies for improved authentication and push notifications)

// Expose scheduled tasks
export { scheduledYTDReset, processScheduledActivities };

// Expose callable functions
<<<<<<< HEAD
export const f_linkNewUser = linkNewUser;
export const f_checkDocumentExists = checkDocumentExists;
export const f_checkDocumentLinked = checkDocumentLinked;
export const f_unlinkUser = unlinkUser;
export const f_isUIDLinked = isUIDLinked;
export const f_calculateTotalYTD = calculateTotalYTD;
export const f_calculateYTD = calculateYTD;
>>>>>>> 6543ce9 (Imported CF from AGQ)
=======
import { f_linkNewUser } from "./callable/linkUser";
import { f_isUIDLinked, f_checkDocumentExists, f_checkDocumentLinked } from "./callable/checkDocsAndUID";
import { f_unlinkUser } from "./callable/unlinkUser";
import { f_calculateTotalYTD, f_calculateYTD } from "./callable/ytd";
>>>>>>> d743458 (Set the cloud functions)
=======
export { linkNewUser, checkDocumentExists, checkDocumentLinked, unlinkUser, isUIDLinked, calculateTotalYTD, calculateYTD };
>>>>>>> 0f6084e (Update Google services configuration and dependencies for improved authentication and push notifications)
