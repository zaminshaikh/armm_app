/**
 * @file index.ts
 * @description Main entry point for Firebase Functions. Imports and re-exports
 *              all triggers, callable, and scheduled functions for deployment.
 */

import * as admin from "firebase-admin";

// Initialize Firebase Admin SDK once here
admin.initializeApp();

// ======= TRIGGERS =======
import { handleActivity, onActivityWrite } from "./triggers/activityTriggers";
import { onAssetUpdate } from "./triggers/assetTriggers";
import { onConnectedUsersChange } from "./triggers/connectedUsersTriggers";

// ======= SCHEDULED =======
import { scheduledYTDReset } from "./scheduled/scheduledReset";
import { processScheduledActivities } from "./scheduled/scheduledActivities";

// ======= CALLABLE =======
import { linkNewUser } from "./callable/linkUser";
import { isUIDLinked, checkDocumentExists, checkDocumentLinked } from "./callable/checkDocsAndUID";
import { unlinkUser } from "./callable/unlinkUser";
import { calculateTotalYTD, calculateYTD } from "./callable/ytd";

// Expose Firestore triggers
export { handleActivity, onActivityWrite, onAssetUpdate, onConnectedUsersChange };

// Expose scheduled tasks
export { scheduledYTDReset, processScheduledActivities };

// Expose callable functions
export { linkNewUser, checkDocumentExists, checkDocumentLinked, unlinkUser, isUIDLinked, calculateTotalYTD, calculateYTD };