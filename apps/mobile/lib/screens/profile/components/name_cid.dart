import 'dart:developer';
import 'dart:io';

import 'package:armm_app/components/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/database/database.dart'; // Import DatabaseService
import 'package:google_fonts/google_fonts.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:armm_app/utils/success_animation_helper.dart'; // Import for success animation
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart'; // Import for image cropping

class NameAndCID extends StatelessWidget {
  const NameAndCID({Key? key}) : super(key: key);

  // Method to crop selected image
  Future<File?> _cropImage(File imageFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Picture',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Profile Picture',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
      return null;
    } catch (e) {
      log('Error cropping image: $e');
      return null;
    }
  }

  // Helper method to upload profile picture with proper error handling
  Future<void> _uploadProfilePicture(BuildContext context, String cid, File imageFile) async {
    // Safety check for context
    if (!context.mounted) {
      log('Context not mounted, cannot upload profile picture');
      return;
    }
    
    // Store reference to overlay state - capturing it while context is valid
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
      
      // Remove loading overlay
      overlayEntry.remove();
      
      // Show success animation if context is still mounted
      if (context.mounted) {
        // Use the SuccessAnimationHelper to show a success animation
        await SuccessAnimationHelper.showSuccessAnimation(context);
        log('Profile picture success animation shown');
      }
      
    } catch (e) {
      // Log error
      log('Error uploading profile picture: $e');
      
      // Remove loading overlay if still exists
      overlayEntry.remove();
      
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

  // Method to select image and directly crop it
  Future<void> _selectAndPreviewImage(BuildContext parentContext, String cid, ImageSource source) async {
    final BuildContext stableContext = parentContext;
    final picker = ImagePicker();
    
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        log('Image selected: ${imageFile.path}');
        
        if (stableContext.mounted) {
          // Immediately crop the image after selection
          File? croppedFile = await _cropImage(imageFile);
          
          // If cropping was successful, show the preview modal with the cropped image
          // Otherwise use the original image (in case crop was cancelled)
          if (stableContext.mounted) {
            _showPreviewModal(stableContext, croppedFile ?? imageFile, cid);
          } else {
            log('Context no longer mounted after cropping image');
          }
        } else {
          log('Context no longer mounted after picking image');
        }
      }
    } catch (e) {
      log('Error picking image: $e');
      if (stableContext.mounted) {
        showDialog(
          context: stableContext,
          builder: (BuildContext errorContext) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to select image: ${e.toString()}'),
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

  // Method to show image preview modal
  void _showPreviewModal(BuildContext context, File imageFile, String cid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => WillPopScope(
        onWillPop: () async => false, // Prevent back button from dismissing
        child: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Preview title
                  Text(
                    'Preview',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Image preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                      height: 250,
                      width: 250,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Edit button
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          onPressed: () async {
                            // Don't dismiss the modal
                            File? croppedFile = await _cropImage(imageFile);
                            if (croppedFile != null) {
                              // Update the preview with the cropped image
                              setState(() {
                                imageFile = croppedFile;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFFB3E5FC), // Light blue pastel
                            foregroundColor: const Color(0xFF01579B), // Darker blue
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Upload button
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.cloud_upload),
                          label: const Text('Upload'),
                          onPressed: () async {
                            Navigator.pop(modalContext);
                            if (context.mounted) {
                              await _uploadProfilePicture(context, cid, imageFile);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFFC8E6C9), // Light green pastel
                            foregroundColor: const Color(0xFF1B5E20), // Darker green
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Cancel button
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancel'),
                          onPressed: () => Navigator.pop(modalContext),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFFFFCCBC), // Light coral/red pastel
                            foregroundColor: const Color(0xFFBF360C), // Darker red
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
      ),
    );
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
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _selectAndPreviewImage(stableContext, cid, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _selectAndPreviewImage(stableContext, cid, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(bottomSheetContext),
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
    
    // Create a list of possible image extensions to try
    Future<String?> getProfilePicUrl(String cid) async {
      // Try common image extensions
      for (final ext in ['.jpg', '.jpeg', '.png', '.gif', '.webp']) {
        try {
          final url = await FirebaseStorage.instance
              .ref('profilePics/$cid$ext')
              .getDownloadURL();
          return url;
        } catch (e) {
          // Continue to the next extension if this one fails
          log('Image with extension $ext not found for cid: $cid');
        }
      }
      // Return null if no image was found with any extension
      return null;
    }
    
    final profilePicFuture = client != null
        ? getProfilePicUrl(client.cid)
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