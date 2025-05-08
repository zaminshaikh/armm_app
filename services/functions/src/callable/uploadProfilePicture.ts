import { Buffer } from 'buffer';
import * as functions from 'firebase-functions/v1';
import * as admin from 'firebase-admin';

export const uploadProfilePicture = functions.https.onCall(
  async (data: { contentType?: any; cid?: any; fileBase64?: any; fileExtension?: any }, context: { auth: any }) => {
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

    const [downloadUrl] = await remoteFile.getSignedUrl({
      action: 'read',
      expires: '03-01-2500',
    });
    return { downloadUrl };
  }
);
