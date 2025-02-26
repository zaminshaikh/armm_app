// src/services/database/models.ts
import { Timestamp } from 'firebase/firestore';

export interface Client {
  companyName: string;
  cid: string;
  uid: string;
  firstName: string;
  lastName: string;
  address: string;
  province: string;
  state: string;
  street: string;
  city: string;
  zip: string;
  country: string;
  dob: Date | null;
  phoneNumber: string;
  appEmail: string;
  initEmail: string;
  firstDepositDate: Date | null;
  beneficiaries: string[];
  connectedUsers: string[];
  totalAssets: number;
  ytd: number;
  totalYTD: number;
  _selected?: boolean;
  lastLoggedIn?: string | null | undefined;
  notes?: string | undefined;
  activities?: Activity[];
  graphPoints?: GraphPoint[];
  assets: {
    [fundKey: string]: {
      [assetType: string]: AssetDetails;
    };
  };
}

export interface Activity {
  id?: string;
  notes?: string | number | string[] | undefined;
  parentDocId?: string;
  amount: number;
  fund: string;
  recipient: string;
  time: Date;
  formattedTime?: string;
  type: string;
  isDividend?: boolean;
  sendNotif?: boolean;
  amortizationCreated?: boolean;
  isAmortization?: boolean;
  principalPaid?: number;
  profitPaid?: number;
  parentName: string;
}

export interface ScheduledActivity {
  id: string;
  cid: string;
  activity: Activity;
  clientState: Client;
  status: string;
  scheduledTime: Date;
  usersCollectionID: string;
}

export interface Notification {
  activityId: string;
  recipient: string;
  title: string;
  body: string;
  message: string;
  isRead: boolean;
  type: string;
  time: Date | Timestamp;
}

export interface GraphPoint {
  time: Date | Timestamp | null;
  amount: number | null;
}

export interface StatementData {
  statementTitle: string;
  downloadURL: string;
  clientId: string;
}

export interface AssetDetails {
    amount: number;
    firstDepositDate: Date | null;
    displayTitle: string;
    index: number;
}

// Default objects
export const emptyClient: Client = {
  firstName: '',
  lastName: '',
  companyName: '',
  address: '',
  province: '',
  state: '',
  street: '',
  city: '',
  zip: '',
  country: 'US',
  dob: null,
  phoneNumber: '',
  firstDepositDate: null,
  beneficiaries: [],
  connectedUsers: [],
  cid: '',
  uid: '',
  appEmail: '',
  initEmail: '',
  totalAssets: 0,
  ytd: 0,
  totalYTD: 0,
  assets: {
    armm: {
      personal: {
        amount: 0,
        firstDepositDate: new Date(),
        displayTitle: 'Personal',
        index: 0,
      },
    },
  },
};

export const emptyActivity: Activity = {
  amount: 0,
  fund: 'ARMM',
  recipient: '',
  // You may adjust this later using roundToNearestHour if needed
  time: new Date(),
  type: 'profit',
  isDividend: false,
  sendNotif: true,
  isAmortization: false,
  notes: undefined,
  parentName: '',
};