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
import { f_linkNewUser } from "./callable/linkUser";
import { f_isUIDLinked, f_checkDocumentExists, f_checkDocumentLinked } from "./callable/checkDocsAndUID";
import { f_unlinkUser } from "./callable/unlinkUser";
import { f_calculateTotalYTD, f_calculateYTD } from "./callable/ytd";
