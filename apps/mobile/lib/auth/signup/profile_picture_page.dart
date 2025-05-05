import 'dart:developer';
import 'dart:io';

import 'package:armm_app/auth/auth_utils/auth_back.dart';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/components/custom_progress_indicator.dart';
import 'package:armm_app/auth/signup/app_lock_prompt_page.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/utils/resources.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ProfilePicturePage extends StatefulWidget {
  final String cid;
  final String email;

  const ProfilePicturePage({
    Key? key, 
    required this.cid, 
    required this.email
  }) : super(key: key);

  @override
  _ProfilePicturePageState createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  File? _imageFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final originalFile = File(pickedFile.path);
        File? croppedFile = await _cropImage(originalFile);
        setState(() {
          // if cropping failed or was canceled, show the original
          _imageFile = croppedFile ?? originalFile;
        });
      }
    } catch (e) {
      log('Error picking image: $e');
      _showErrorDialog('Error picking image. Please try again.');
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Picture',
            toolbarColor: AppColors.primary,
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

  Future<void> _uploadProfilePicture() async {
    if (_imageFile == null) {
      _showErrorDialog('Please select a profile picture first.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get file extension
      final fileExtension = path.extension(_imageFile!.path);
      
      // Reference to storage location
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profilePics')
          .child('${widget.cid}$fileExtension');
      
      // Upload file
      await storageRef.putFile(_imageFile!);
      
      // Get download URL if needed
      final downloadUrl = await storageRef.getDownloadURL();
      log('Profile picture uploaded: $downloadUrl');

      if (mounted) {
        // Navigate to AppLockPromptPage instead of Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AppLockPromptPage()),
        );
      }
    } catch (e) {
      log('Error uploading profile picture: $e');
      if (mounted) {
        _showErrorDialog('Error uploading profile picture. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showProfilePictureOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
               leading: SvgPicture.asset(
                 'assets/icons/gallery.svg',
                 width: 24,
                 height: 24,
               ),
                title: Text(
                  'Choose from Gallery',
                  style: GoogleFonts.inter(),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
               leading: SvgPicture.asset(
                 'assets/icons/camera.svg',
                 width: 24,
                 height: 24,
               ),
                title: Text(
                  'Take a Photo',
                  style: GoogleFonts.inter(),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Error',
        message: message,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 72),
                    // Top illustration or profile picture preview
                    _imageFile != null
                        ? Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(_imageFile!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : SvgPicture.asset(
                            'assets/icons/mystery.svg',
                            height: 200,
                          ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      'Add a Profile Picture',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Choose a profile picture to personalize your account',
                      style: GoogleFonts.inter(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Select Photo Button
                    AuthButton(
                      label: _imageFile != null ? 'Change Photo' : 'Select Photo',
                      onPressed: _showProfilePictureOptions,
                        backgroundColor: _imageFile != null ? Colors.white : AppColors.primary,
                        foregroundColor: _imageFile != null ? AppColors.primary : Colors.white,
                      isEnabled: true,
                    ),
                    if (_imageFile != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'OR',
                              style: GoogleFonts.inter(color: Colors.grey),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AuthButton(
                        label: 'Continue',
                        onPressed: _uploadProfilePicture,
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        isEnabled: true,
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CustomProgressIndicator(),
                ),
              ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AppLockPromptPage()),
                );
              },
              child: Text(
                'Skip for now',
                style: TextStyle(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
