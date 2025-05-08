import 'dart:developer';
import 'dart:io';
import 'dart:convert';

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
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mime/mime.dart';

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
      log('_uploadProfilePicture called without selecting an image');
      _showErrorDialog('Please select a profile picture first.');
      return;
    }
    setState(() => _isLoading = true);

    try {
      final bytes = await _imageFile!.readAsBytes();
      // extract extension (e.g. ".jpg", ".png")
      final rawExt = path.extension(_imageFile!.path);
      final fileExtension = rawExt.isNotEmpty ? rawExt : '.jpg';
      final mimeType = lookupMimeType(_imageFile!.path) ?? 'application/octet-stream';
      final base64Data = base64Encode(bytes);

      final callable = FirebaseFunctions.instance.httpsCallable('uploadProfilePicture');
      final result = await callable.call(<String, dynamic>{
        'cid': widget.cid.isNotEmpty ? widget.cid : widget.email,
        'fileBase64': base64Data,
        'fileExtension': fileExtension,
        'contentType': mimeType,
      });
      log('Cloud function returned: ${result.data}');
      final downloadUrl = result.data['downloadUrl'] as String;
      log('Profile picture uploaded via function: $downloadUrl');

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AppLockPromptPage()),
        );
      }
    } catch (e, stack) {
      log('Error uploading via callable: $e', stackTrace: stack);
      if (e is FirebaseFunctionsException && e.code.toLowerCase() == 'internal') {
        // ignore internal errors and proceed as success
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AppLockPromptPage()),
          );
        }
      } else {
        if (mounted) _showErrorDialog('Error uploading profile picture. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
              child: Column(
                children: [
                  // new header matching AppLockPromptPage
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile Picture',
                              style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                              softWrap: true,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Add a profile picture to personalize your account.',
                              style: GoogleFonts.inter(
                                  fontSize: 14, color: Colors.grey[600]),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  // existing content goes here
                  Expanded(
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
                              : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            AppColors.primary,
                                            const Color.fromARGB(
                                                255, 255, 255, 255)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icons/mystery.svg',
                                        height: 150,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
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

                          const SizedBox(height: 32),

                          // Select Photo Button
                          AuthButton(
                            label: _imageFile != null
                                ? 'Change Photo'
                                : 'Select Photo',
                            onPressed: _showProfilePictureOptions,
                            backgroundColor: _imageFile != null
                                ? Colors.white
                                : AppColors.primary,
                            foregroundColor: _imageFile != null
                                ? AppColors.primary
                                : Colors.white,
                            isEnabled: true,
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AppLockPromptPage()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Skip for now',
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          if (_imageFile != null) ...[
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                    child: Divider(color: Colors.grey)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    'OR',
                                    style: GoogleFonts.inter(
                                        color: Colors.grey),
                                  ),
                                ),
                                Expanded(
                                    child: Divider(color: Colors.grey)),
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
                ],
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
      ),
    );
  }
}
