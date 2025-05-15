import { Buffer } from 'buffer';
import * as functions from 'firebase-functions/v1';
import * as admin from 'firebase-admin';

export const uploadProfilePicture = functions.https.onCall(
  async (data, context) => {
    const { cid, fileBase64, fileExtension } = data;
    // auth guard
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'Must be signed in');
    }
    if (!cid || !fileBase64 || !fileExtension) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'cid, fileBase64, and fileExtension are required'
      );
    }
    const buffer = Buffer.from(fileBase64, 'base64');
    const bucket = admin.storage().bucket();

    // delete any existing file(s) under this cid
    await bucket.deleteFiles({ prefix: `profilePics/${cid}` });

    // save under the exact extension
    const filePath = `profilePics/${cid}${fileExtension}`;
    const remoteFile = bucket.file(filePath);
    await remoteFile.save(buffer, {
      contentType: data.contentType ?? 'application/octet-stream',
    });

    // Instead of using signed URLs (which requires specific IAM permissions),
    // use the public download URL pattern for Firebase Storage
    const storageBaseUrl = `https://storage.googleapis.com/${bucket.name}`;
    const encodedFilePath = encodeURIComponent(filePath);
    const downloadUrl = `${storageBaseUrl}/${encodedFilePath}`;
    
    return { downloadUrl };
  }
);
