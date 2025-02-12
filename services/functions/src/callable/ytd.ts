import {f_calculateTotalYTDForUser, f_calculateYTDForUser} from '../helpers/ytd';
import * as functions from "firebase-functions/v1";

export const f_calculateTotalYTD = functions.https.onCall(async (data, context): Promise<number> => {
    const cid = data.cid;
    const usersCollectionID = data.usersCollectionID;

    return f_calculateTotalYTDForUser(cid, usersCollectionID);
});

export const f_calculateYTD = functions.https.onCall(async (data, context): Promise<number> => {
    const cid = data.cid;
    const usersCollectionID = data.usersCollectionID;

    return f_calculateYTDForUser(cid, usersCollectionID);
});