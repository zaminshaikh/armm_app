import 'dart:developer';
import 'dart:io';

import 'package:armm_app/components/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/database/database.dart'; // Import DatabaseService
import 'package:google_fonts/google_fonts.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class NameAndCID extends StatelessWidget {
  const NameAndCID({Key? key}) : super(key: key);

  // Helper method to upload profile picture with proper error handling
  Future<void> _uploadProfilePicture(BuildContext context, String cid, File imageFile) async {
    // Safety check for context
    if (!context.mounted) {
      log('Context not mounted, cannot upload profile picture');
      return;
    }
    
    // Store references to needed services - capturing them while context is valid
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    OverlayState overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    log('Uploading profile picture for CID: $cid');
    
    // Create overlay for loading indicator
    overlayEntry = OverlayEntry(
      builder: (overlayContext) => Positioned.fill(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CustomProgressIndicator(),
            ),
          ),
        ),
      ),
    );
    
    // Insert the overlay
    overlayState.insert(overlayEntry);

    try {
      // Create database service for uploading
      DatabaseService dbService = DatabaseService.withCID('', cid);
      
      // Upload through the database service
      final downloadUrl = await dbService.uploadProfilePicture(imageFile);
      
      // Log success
      log('Profile picture updated successfully. URL: $downloadUrl');
      
      // Remove overlay
      overlayEntry.remove();
      
      // Show success message if context is still mounted
      // Use ScaffoldMessengerState that we captured earlier to avoid animation issues
      if (context.mounted) {
        // Clear any existing SnackBars first to prevent animation controller conflicts
        scaffoldMessengerState.clearSnackBars();
        scaffoldMessengerState.showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      
    } catch (e) {
      // Log error
      log('Error uploading profile picture: $e');
      
      // Show error message if context is still mounted
      if (context.mounted) {
        // Safe way to show dialog without animation controller conflicts
        showDialog(
          context: context,
          builder: (BuildContext errorContext) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to upload profile picture: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(errorContext),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  // Method to show picker for selecting camera or gallery
  Future<void> _showImagePicker(BuildContext parentContext, String cid) async {
    // Store the parent context before showing the bottom sheet
    final BuildContext stableContext = parentContext;
    
    showModalBottomSheet(
      context: parentContext,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  // Close the bottom sheet
                  Navigator.pop(bottomSheetContext);
                  
                  // Use the image picker
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 1000,
                    maxHeight: 1000,
                    imageQuality: 80,
                  );
                  
                  // Use the stable context for all subsequent operations
                  if (pickedFile != null && stableContext.mounted) {
                    final file = File(pickedFile.path);
                    log('Picked file: ${file.path}');
                    await _uploadProfilePicture(stableContext, cid, file);
                    log('File uploaded: ${file.path}');
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  // Close the bottom sheet
                  Navigator.pop(bottomSheetContext);
                  
                  // Use the image picker
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 1000, 
                    maxHeight: 1000,
                    imageQuality: 80,
                  );
                  
                  // Use the stable context for all subsequent operations
                  if (pickedFile != null && stableContext.mounted) {
                    final file = File(pickedFile.path);
                    await _uploadProfilePicture(stableContext, cid, file);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<Client?>(context);
    final profilePicFuture = client != null
        ? FirebaseStorage.instance
            .ref('profilePics/${client.cid}.jpg')
            .getDownloadURL()
            .catchError((e) => Future.value(null as String?)) // Return empty string instead of null
        : Future.value(null as String?);

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
                      if (imageUrl != null && imageUrl.isNotEmpty) {
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
                      await _showImagePicker(context, cid);
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