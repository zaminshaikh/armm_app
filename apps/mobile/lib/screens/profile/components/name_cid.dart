import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class NameAndCID extends StatelessWidget {
  const NameAndCID({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<Client?>(context);
    final profilePicFuture = client != null
        ? FirebaseStorage.instance
            .ref('profilePics/${client.cid}.jpg')
            .getDownloadURL()
            .catchError((_) => null)
        : Future.value(null);

    void _showBottomSheet(BuildContext context, String? imageUrl, String cid) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => SingleChildScrollView(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16.0),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                    ListTile(
                    leading: const Icon(Icons.visibility),
                    title: const Text('View'),
                    onTap: () {
                      Navigator.pop(context);
                      if (imageUrl != null) {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.all(20),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                              ),
                              child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 24,
                              ),
                            ),
                            ),
                          ),
                          ],
                        ),
                        ),
                      );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Change'),
                    onTap: () async {
                      Navigator.pop(context);
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        final file = File(pickedFile.path);
                        await FirebaseStorage.instance
                            .ref('profilePics/$cid.jpg')
                            .putFile(file);
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.cancel),
                    title: const Text('Cancel'),
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FutureBuilder<String?>(
          future: profilePicFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GestureDetector(
                onTap: () => _showBottomSheet(context, null, client!.cid),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color.fromARGB(54, 255, 255, 255),
                  child: const CircularProgressIndicator(color: Colors.grey),
                ),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              return GestureDetector(
                onTap: () => _showBottomSheet(context, snapshot.data, client!.cid),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(snapshot.data!),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () => _showBottomSheet(context, null, client!.cid),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade300,
                  child: Text(
                    '${client?.firstName[0] ?? ''}${client?.lastName[0] ?? ''}',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              );
            }
          },
        ),
        const SizedBox(width: 10),
        // Name and Client ID
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatName(client?.firstName ?? '', client?.lastName ?? ''),
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              'Client ID: ${client?.cid}',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}