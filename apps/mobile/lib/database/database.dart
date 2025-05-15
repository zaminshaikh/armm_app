import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:armm_app/database/models/activity_model.dart';
import 'package:armm_app/database/models/assets_model.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/database/models/graph_point_model.dart';
import 'package:armm_app/database/models/notification_model.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:rxdart/rxdart.dart';

/// A service class for interacting with the Firestore database.
///
/// This class handles operations related to the user's data in Firestore,
/// such as fetching client data, updating fields, and managing notifications.
class DatabaseService {
  String? cid; // Client ID: Document ID in Firestore
  String? uid; // User ID: Firebase Auth UID

  // Flag to indicate if the user is connected to another user
  // This is so we don't fetch the connected user's connected users and avoid infinite recursion
  bool isConnectedUser = false;

  static final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection(Config.get('FIRESTORE_ACTIVE_USERS_COLLECTION'));

  CollectionReference? assetsSubCollection;
  CollectionReference? activitiesSubCollection;
  CollectionReference? notificationsSubCollection;
  CollectionReference? graphPointsSubCollection;
  List<dynamic>? connectedUsersCIDs;

  /// Constructs a [DatabaseService] instance with the given [uid].
  DatabaseService(this.uid);

  /// Constructs a [DatabaseService] instance for a connected user with the given [cid].
  DatabaseService.connectedUser(this.cid) {
    setSubCollections(this);
    isConnectedUser = true;
  }

  /// Constructs a [DatabaseService] instance with the given [uid] and [cid].
  DatabaseService.withCID(this.uid, this.cid);

  /// Asynchronously creates a [DatabaseService] instance by fetching the [cid] for the given [uid].
  ///
  /// Returns a [Future] that completes with a [DatabaseService] instance or `null` if the [uid] is not found.
  /// Each user in Firestore has a document with a unique [uid] field. If the [uid] is found, the method fetches the [cid] and connected users from the document.
  static Future<DatabaseService?> fetchCID(String uid, BuildContext context) async {
    print('fetchCID: Starting fetch for UID: $uid');
    
    // Create a new instance of DatabaseService using the provided uid.
    DatabaseService db = DatabaseService(uid);
    print('fetchCID: Created DatabaseService instance for UID: $uid');
    
    // Access Firestore and get the document
    QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: uid).get();
    print('fetchCID: Firestore query completed for UID: $uid');
    
    if (querySnapshot.size > 0) {
      print('fetchCID: UID $uid found in Firestore.');
      
      // Document found, access the 'cid' field
      QueryDocumentSnapshot snapshot = querySnapshot.docs.first;
      db.cid = snapshot.id;
      print('fetchCID: Document found. CID set to: ${db.cid}');
      
      // Cast snapshot.data() to Map<String, dynamic>
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      print('fetchCID: Document data cast to Map<String, dynamic>');
      
      // Check if 'connectedUsers' field exists before trying to access it
      if (data.containsKey('connectedUsers')) {
        db.connectedUsersCIDs = data['connectedUsers'] ?? [];
        print('fetchCID: connectedUsers field exists. Value: ${db.connectedUsersCIDs}');
      } else {
        print('fetchCID: Field "connectedUsers" does not exist in document.');
        db.connectedUsersCIDs = []; // Or handle this case as needed
      }
      
      setSubCollections(db);
      print('fetchCID: Sub-collections set for CID: ${db.cid}');
    } else {
      print('fetchCID: Document with UID $uid not found in Firestore.');
      // log('database.dart: User signed out.');
      // await FirebaseAuth.instance.signOut();
      return null;
    }
    
    print('fetchCID: Returning DatabaseService instance for UID: $uid');
    return db;
  }

  /// Sets the sub-collections for the given [DatabaseService] instance.
  ///
  /// This includes assets, activities, notifications, and graph points sub-collections.
  static void setSubCollections(DatabaseService db) {
    db.assetsSubCollection = usersCollection
        .doc(db.cid)
        .collection(Config.get('ASSETS_SUBCOLLECTION'));
    db.graphPointsSubCollection = usersCollection
        .doc(db.cid)
        .collection(Config.get('GRAPHPOINTS_SUBCOLLECTION'));
    db.activitiesSubCollection = usersCollection
        .doc(db.cid)
        .collection(Config.get('ACTIVITIES_SUBCOLLECTION'));
    db.notificationsSubCollection = usersCollection
        .doc(db.cid)
        .collection(Config.get('NOTIFICATIONS_SUBCOLLECTION'));
  }

  /// Returns a stream that listens to changes in the user's client data and sub-collections.
  ///
  /// The stream emits [Client] objects containing updated client data whenever changes occur.
  Stream<Client?> getClientStream() {
    if (cid == null) {
      return Stream.value(null);
    }

    log('database.dart: Fetching client stream for CID: $cid');

    try {
      // Stream for the main client document
      Stream<DocumentSnapshot> clientDocumentStream =
          usersCollection.doc(cid).snapshots();

      // Stream for connected users
      Stream<List<Client?>> connectedUsersStream;
      if (!isConnectedUser &&
          connectedUsersCIDs != null &&
          connectedUsersCIDs!.isNotEmpty) {
        connectedUsersStream =
            Rx.combineLatestList(connectedUsersCIDs!.map((connectedCid) {
          DatabaseService db = DatabaseService.connectedUser(connectedCid);
          return db.getClientStream().asBroadcastStream();
        }).toList())
                .asBroadcastStream();
      } else {
        connectedUsersStream = Stream.value([null]);
      }

      // Stream for the activities sub-collection
      Stream<List<Activity>> activitiesStream = activitiesSubCollection!
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                  (doc) => Activity.fromMap(doc.data() as Map<String, dynamic>))
              .toList());

      // Stream for the assets sub-collection
      Stream<Assets> assetsStream =
          assetsSubCollection!.snapshots().map((snapshot) {
        Map<String, Fund> funds = {};
        Map<String, dynamic> general = {};

        for (var doc in snapshot.docs) {
          if (doc.id == 'general') {
            general = doc.data() as Map<String, dynamic>;
          } else {
            funds[doc.id] = Fund.fromMap(doc.data() as Map<String, dynamic>);
          }
        }

        return Assets.fromMap(funds, general);
      });

      // Stream for the notifications sub-collection
      Stream<List<Notif?>> notificationsStream = notificationsSubCollection!
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                try {
                  return Notif.fromMap(<String, dynamic>{
                    ...doc.data() as Map<String, dynamic>,
                    'id': doc.id,
                    'parentCID': cid
                  });
                } catch (e) {
                  log('database.dart: Error creating Notif from map: $e');
                  return null;
                }
              }).toList());

      // Stream for the graphPoints sub-collection
      Stream<List<GraphPoint?>> graphPointsStream = graphPointsSubCollection!
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                try {
                  return GraphPoint.fromMap(doc.data() as Map<String, dynamic>);
                } catch (e) {
                  log('database.dart: Error creating GraphPoint from map: $e');
                  return null;
                }
              }).toList());

      // Combine all the streams into a single stream emitting Client objects
      return Rx.combineLatest6(
          clientDocumentStream,
          activitiesStream,
          assetsStream,
          notificationsStream,
          graphPointsStream,
          connectedUsersStream, (
        DocumentSnapshot clientDoc,
        List<Activity> activities,
        Assets assets,
        List<Notif?> notifications,
        List<GraphPoint?> graphPoints,
        List<Client?> connectedUsers,
      ) {
        final clientData = clientDoc.data() as Map<String, dynamic>?;

        if (clientData == null) {
          log('clientDoc.data() is null for cid: ${cid ?? 'unknown'}');
          return Client.empty();
        }

        // Filter out null values and sort the graphPoints
        List<GraphPoint> filteredGraphPoints =
            graphPoints.whereType<GraphPoint>().toList();
        filteredGraphPoints.sort((a, b) => a.time.compareTo(b.time));

        return Client.fromMap(
          cid: cid,
          clientData,
          activities: activities,
          assets: assets,
          notifications: notifications
              .whereType<Notif>()
              .toList(), // Filter out null values
          graphPoints: filteredGraphPoints,
          connectedUsers: connectedUsers.whereType<Client>().toList(),
        );
      });
    } catch (e) {
      log('database.dart: Error in getClientStream: $e');
      return Stream.value(null);
    }
  }

  /// Returns a field from the user document.
  ///
  /// Parameters:
  /// - [fieldName]: The name of the field to retrieve.
  ///
  /// Returns:
  /// - A [Future] that completes with the value of the specified field, or `null` if the field does not exist.
  Future<dynamic> getField(String fieldName) async {
    try {
      DocumentSnapshot userDoc = await usersCollection.doc(cid).get();
      if (userDoc.exists) {
        if ((userDoc.data() as Map<String, dynamic>).containsKey(fieldName)) {
          return userDoc.get(fieldName);
        } else {
          return null; // Field does not exist
        }
      } else {
        throw Exception('User document does not exist');
      }
    } catch (e) {
      log('database.dart: Error getting field: $e',
          stackTrace: StackTrace.current);
      return null;
    }
  }

  /// Updates a field in the user document.
  ///
  /// Parameters:
  /// - [fieldName]: The name of the field to update.
  /// - [newValue]: The new value to set for the field.
  ///
  /// Returns:
  /// - A [Future] that completes when the field is updated.
  Future<void> updateField(String fieldName, dynamic newValue) async {
    try {
      await usersCollection.doc(cid).update({fieldName: newValue});
    } catch (e) {
      throw Exception('Error updating field: $e');
    }
  }

  /// Marks a specific notification as read.
  ///
  /// Parameters:
  /// - [notificationId]: The ID of the notification to mark as read.
  ///
  /// Returns:
  /// - A [Future] that completes with `true` if successful, `false` otherwise.
  Future<bool> markNotificationAsRead(String notificationId) async {
    if (cid == null) {
      log('CID is null');
      return false;
    } else if (notificationsSubCollection == null) {
      setSubCollections(this);
    }
    if (notificationsSubCollection == null) {
      log('notificationsSubCollection is null, try checking the path.');
      return false;
    }
    try {
      DocumentReference docRef =
          notificationsSubCollection!.doc(notificationId);

      DocumentSnapshot docSnap = await docRef.get();

      if (docSnap.exists) {
        await docRef.update({'isRead': true});
        return true;
      }
    } catch (e) {
      log('Error updating notification: $e');
    }
    return false;
  }

  /// Marks all notifications as read for the current user and connected users.
  ///
  /// Returns:
  /// - A [Future] that completes with `true` if successful, `false` otherwise.
  Future<bool> markAllNotificationsAsRead() async {
    if (cid == null) {
      log('CID is null');
      return false;
    } else if (notificationsSubCollection == null) {
      setSubCollections(this);
    }
    if (notificationsSubCollection == null) {
      log('notificationsSubCollection is null, try checking the path.');
      return false;
    }
    try {
      DocumentSnapshot clientSnapshot = await usersCollection.doc(cid).get();
      QuerySnapshot querySnapshot = await notificationsSubCollection!.get();

      List<Future> futures = [];

      if (querySnapshot.size > 0) {
        for (DocumentSnapshot doc in querySnapshot.docs) {
          futures.add(doc.reference.update({'isRead': true}));
        }
      }

      Map<String, dynamic>? clientData =
          clientSnapshot.data() as Map<String, dynamic>?;
      if (clientData != null && clientData['connectedUsers'] != null) {
        for (String connectedCid in clientData['connectedUsers']) {
          futures.add(DatabaseService.withCID('', connectedCid)
              .markAllNotificationsAsRead());
        }
      }

      await Future.wait(futures);
      return true;
    } catch (e) {
      log('Error updating notifications: $e');
    }
    return false;
  }

  /// Links a new user to the database using the provided email.
  ///
  /// This method fetches the existing data for the user with the given [cid] (Client ID) from the database.
  /// Each [cid] corresponds to a document in the 'users' collection in the database.
  /// If the user already exists (determined by the presence of a [uid] in the existing data), an exception is thrown.
  /// Otherwise, the method updates the existing data with the new user's [uid] and [email] and sets the document in the database with the updated data.
  ///
  /// Throws a [FirebaseException] if:
  /// - **No document found**
  ///   - The document does not exist for the given [cid]
  /// - **User already exists**
  ///   - The document we pulled has a non-empty [uid], meaning a user already exists for the given [cid]
  ///
  /// Catches any other unhandled exceptions and logs an error message.
  ///
  /// Parameters:
  /// - [email]: The email of the new user to be linked to the database.
  ///
  /// Usage:
  /// ```dart
  /// try {
  ///   DatabaseService db = new DatabaseService(cid, uid);
  ///   await db.linkNewUser(email, cid);
  ///   log('database.dart: User linked to database successfully.');
  /// } catch (e) {
  ///   log('database.dart: Error linking user to database: $e');
  /// }
  /// ```
  ///
  /// Returns a [Future] that completes when the document is successfully set in the database.
  Future<void> linkNewUser(String email) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('linkNewUser');
      final result = await callable.call({
        'email': email,
        'cid': cid,
        'uid': uid,
        'usersCollectionID': Config.get('FIRESTORE_ACTIVE_USERS_COLLECTION')
      });
      print('Function result: ${result.data}');
    } catch (e) {
      print('Error calling cloud function: $e');
    }
  }

  /// Returns a stream of [DocumentSnapshot] containing a single user document.
  ///
  /// This stream will emit a new [DocumentSnapshot] whenever the user document is updated.
  Stream<DocumentSnapshot> get getUser => usersCollection.doc(cid).snapshots();

  /// Checks if a document exists in the Firestore 'users' collection.
  ///
  /// This function invokes a callable Cloud Function named 'checkDocumentExists' and passes it
  /// a document ID ('cid') to check for existence in the Firestore database. This is useful
  /// for client-side checks against database conditions without exposing direct database access.
  ///
  /// [cid] The ID of the document to check for existence.
  ///
  /// Returns a [Future] that completes with a boolean value indicating whether the document exists.
  /// If the Cloud Function call fails, it logs the error and returns false, assuming non-existence
  /// to safely handle potential failures.
  ///
  /// Usage:
  /// ```dart
  /// bool exists = await checkDocumentExists('some-document-id');
  /// ```
    Future<bool> checkDocumentExists(String cid) async {
      debugPrint('checkDocumentExists: Called with cid: $cid');
      
      // Retrieve the collection ID from config.
      final String usersCollectionID = "users";
      debugPrint('checkDocumentExists: Using usersCollectionID from config: $usersCollectionID');
      
      try {
        // Create an instance of the callable Cloud Function.
        final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'checkDocumentExists',
          options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
        );
        
        // Define parameters for the call.
        final Map<String, dynamic> params = {
          'cid': cid,
          'usersCollectionID': usersCollectionID,
        };
        debugPrint('checkDocumentExists: Calling Cloud Function with parameters: $params');
    
        // Call the function and await its response.
        final HttpsCallableResult result = await callable.call(params);
        debugPrint('checkDocumentExists: Cloud Function response: ${result.data}');
    
        // Check for the expected response format and extract "exists".
        if (result.data is Map<String, dynamic> && result.data.containsKey('exists')) {
          final bool exists = result.data['exists'] as bool;
          debugPrint('checkDocumentExists: Document existence returned: $exists');
          return exists;
        } else {
          debugPrint('checkDocumentExists: Unexpected response format: ${result.data}');
          return false;
        }
      } catch (error, stackTrace) {
        debugPrint('checkDocumentExists: Error encountered: $error');
        debugPrint('checkDocumentExists: Stack trace: $stackTrace');
        return false;
      }
    }

  /// Checks if a document with a specific ID is linked to a user.
  ///
  /// This function makes a call to a Firebase Cloud Function named 'checkDocumentLinked'
  /// to determine if the document in the Firestore 'users' collection has a non-empty
  /// 'uid' field, indicating it is linked to a user.
  ///
  /// The function is wrapped in a try-catch block to handle any potential errors
  /// that might occur during the execution of the cloud function, such as network issues
  /// or problems with the cloud function itself.
  ///
  /// [cid] The ID of the document to check.
  ///
  /// Returns a [Future] that completes with a boolean value indicating whether the document
  /// is linked to a user. If the cloud function call fails, it logs the error and returns false.
  ///
  /// Example usage:
  /// ```dart
  /// bool isLinked = await checkDocumentLinked('documentId123');
  /// ```
  Future<bool> checkDocumentLinked(String cid) async {
    try {
      // Create an instance of the callable function 'checkDocumentLinked' from Firebase Functions
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('checkDocumentLinked');

      // Call the function with 'cid' as the parameter
      final result = await callable.call({'cid': cid, 'usersCollectionID': Config.get('FIRESTORE_ACTIVE_USERS_COLLECTION')});

      // Return the boolean result from the function call
      return result.data['isLinked'] as bool;
    } catch (e) {
      // Log any errors encountered during the function call
      print('Error calling function: $e');

      // Return true by default if an error occurs to handle the error gracefully
      return true;
    }
  }

  /// Calls the Cloud Function `isUIDLinked` to check if a UID is linked.
  Future<bool> isUIDLinked(String uid) async {
    try {
      // Initialize the callable function
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'isUIDLinked',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 30),
        ),
      );

      // Call the function with the required parameters
      final HttpsCallableResult result = await callable.call({
        'uid': uid,
        'usersCollectionID': Config.get('FIRESTORE_ACTIVE_USERS_COLLECTION'),
      });

      // Extract the 'isLinked' value from the result
      final data = result.data as Map<String, dynamic>;
      final bool isLinked = data['isLinked'] as bool;

      return isLinked;
    } on FirebaseFunctionsException catch (e) {
      // Handle Firebase Functions errors
      print('Firebase Functions Exception: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      // Handle other errors
      print('Unknown error occurred while calling isUIDLinked: $e');
      return false;
    }
  }

  /// Uploads a profile picture for the user via Firebase Cloud Functions.
  ///
  /// This method handles the process of uploading a profile picture by:
  /// 1. Converting the image file to base64 encoded string
  /// 2. Sending the encoded image to a Firebase Cloud Function
  /// 3. The function handles storing the image in Firebase Storage
  /// 4. Returns the download URL of the uploaded image
  ///
  /// Parameters:
  /// - [imageFile]: The File object containing the image to upload
  /// - [imageIdentifier]: Either the cid or email to identify the user (optional - uses this.cid if not provided)
  ///
  /// Returns:
  /// - A [Future] that completes with the download URL of the uploaded image or null if upload fails
  /// - Throws an exception if the upload fails and shouldThrow is true
  Future<String?> uploadProfilePicture(
    File imageFile, {
    String? imageIdentifier,
    bool shouldThrow = false,
  }) async {
    try {
      // Read the file as bytes and encode to base64
      final bytes = await imageFile.readAsBytes();
      
      // Get file extension (default to .jpg if not found)
      final rawExt = path.extension(imageFile.path);
      final fileExtension = rawExt.isNotEmpty ? rawExt : '.jpg';
      
      // Determine MIME type
      final mimeType = lookupMimeType(imageFile.path) ?? 'application/octet-stream';
      
      // Encode image to base64
      final base64Data = base64Encode(bytes);

      // Use the provided identifier or fallback to cid
      final identifier = imageIdentifier ?? cid;
      if (identifier == null) {
        throw Exception('No valid identifier (cid/email) provided for profile picture upload');
      }

      // Call the Firebase Cloud Function
      final callable = FirebaseFunctions.instance.httpsCallable('uploadProfilePicture');
      final result = await callable.call(<String, dynamic>{
        'cid': identifier,
        'fileBase64': base64Data,
        'fileExtension': fileExtension,
        'contentType': mimeType,
      });

      // Extract the download URL from the result
      final downloadUrl = result.data['downloadUrl'] as String;
      log('database.dart: Profile picture uploaded successfully: $downloadUrl');
      
      return downloadUrl;
    } catch (e, stack) {
      log('database.dart: Error uploading profile picture: $e', stackTrace: stack);
      
      // More detailed error logging to help with debugging
      if (e is FirebaseFunctionsException) {
        log('database.dart: Firebase Functions error code: ${e.code}');
        log('database.dart: Firebase Functions error details: ${e.details}');
        
        // Handle permissions issues that might be related to signBlob permission
        if (e.code.toLowerCase() == 'permission-denied' || 
            (e.message?.contains('Permission') ?? false) ||
            (e.message?.contains('signBlob') ?? false)) {
          log('database.dart: Permission issue detected. This might be related to IAM permissions for signBlob');
        }
        
        // Handle special case for internal errors (which may be expected in some environments)
        if (e.code.toLowerCase() == 'internal') {
          log('database.dart: Internal error occurred but proceeding as success');
          return null;
        }
      }
      
      // Re-throw if requested, otherwise return null
      if (shouldThrow) {
        throw Exception('Failed to upload profile picture: $e');
      }
      return null;
    }
  }
}
