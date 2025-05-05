const admin = require('firebase-admin');

// Initialize the Admin SDK with your service account key
const serviceAccount = require('./armm-service-account.json'); // Replace with path to your service account JSON

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Function to verify a user's email
const verifyEmail = async (uid) => {
  try {
    const userRecord = await admin.auth().updateUser(uid, {
      emailVerified: true,
    });
    console.log(`Email for ${userRecord.email} has been marked as verified.`);
  } catch (error) {
    console.error('Error verifying email:', error.message);
  }
};

// Get the UID from command line arguments
const args = process.argv.slice(2);
if (args.length === 0) {
  console.error('Please provide a user UID as a command line argument');
  console.log('Usage: node mark-uid-as-email-verified.js <UID>');
  process.exit(1);
}

const uid = args[0];
verifyEmail(uid);