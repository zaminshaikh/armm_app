// ignore_for_file: empty_catches

import 'package:armm_app/utils/config.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;


void downloadToFiles(String documentName) async {
  Directory downloadDir = await getApplicationDocumentsDirectory();
  var path = '${downloadDir.path}/$documentName';
  var file = File(path);
  var res = await http.get(Uri.parse('https://source.unsplash.com/random')); 
  await file.writeAsBytes(res.bodyBytes);

  // Open share options
}

Future<String> downloadFile(context, clientId, documentName) async {
  String filePath = '';

  try {
    final directory = await getTemporaryDirectory();

    filePath = '${directory.path}/$documentName';

    final ref = FirebaseStorage.instance.ref().child(Config.get('FIRESTORE_ACTIVE_USERS_COLLECTION')).child(clientId).child(documentName);

    final bytes = await ref.getData();
    if (bytes != null) {
      final file = File(filePath);
      await file.writeAsBytes(bytes);
    } else {
      print('No bytes retrieved for file: $documentName');
    }
  } catch (e) {
    print('Error downloading file $documentName: $e');
    
    // Try with URL encoded filename if the first attempt fails
    try {
      final encodedDocumentName = Uri.encodeComponent(documentName);
      final encodedRef = FirebaseStorage.instance.ref().child(Config.get('FIRESTORE_ACTIVE_USERS_COLLECTION')).child(clientId).child(encodedDocumentName);
      
      final bytes = await encodedRef.getData();
      if (bytes != null) {
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        print('Successfully downloaded file with encoded name: $encodedDocumentName');
      }
    } catch (encodedError) {
      print('Error downloading file with encoded name: $encodedError');
    }
  }

  return filePath;
}