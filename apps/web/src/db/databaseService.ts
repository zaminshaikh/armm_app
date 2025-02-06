import { collection, getFirestore, getDocs, getDoc, doc, Firestore, CollectionReference, DocumentData, addDoc, setDoc, deleteDoc, collectionGroup, DocumentSnapshot, where, query, writeBatch } from 'firebase/firestore';
import { app } from '../App.tsx';
import config from '../../config.json';
import { Timestamp } from 'firebase/firestore';
import { getFunctions, httpsCallable } from 'firebase/functions';
import { formatCurrency } from './utils';
import { roundToNearestHour } from './utils';
import { 
    AssetDetails, 
    Client, 
    Activity, 
    ScheduledActivity, 
    Notification, 
    GraphPoint, 
    StatementData, 
    emptyClient 
} from './models';

// ...existing code up to the declaration of DatabaseService...

export class DatabaseService {

    private db: Firestore = getFirestore(app);
    private clientsCollection: CollectionReference<DocumentData, DocumentData>;
    private cidArray: string[];

    constructor() {
        this.clientsCollection = collection(this.db, config.FIRESTORE_ACTIVE_USERS_COLLECTION);
        this.cidArray = [];
        this.initCIDArray();
    }

    // ...existing methods from initCIDArray to the end...
}
