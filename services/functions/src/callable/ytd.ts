import {calculateTotalYTDForUser, calculateYTDForUser} from '../helpers/ytd';
import * as functions from "firebase-functions/v1";

export const calculateTotalYTD = functions.https.onCall(async (data: { cid: any; usersCollectionID: any; }, context: any): Promise<number> => {
    const cid = data.cid;
    const usersCollectionID = data.usersCollectionID;

    return calculateTotalYTDForUser(cid, usersCollectionID);
});

export const calculateYTD = functions.https.onCall(async (data: { cid: any; usersCollectionID: any; }, context: any): Promise<number> => {
    const cid = data.cid;
    const usersCollectionID = data.usersCollectionID;

    return calculateYTDForUser(cid, usersCollectionID);
});