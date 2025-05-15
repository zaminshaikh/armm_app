import 'dart:developer';
import 'dart:io';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/components/custom_progress_indicator.dart';
import 'package:armm_app/auth/signup/app_lock_prompt_page.dart';
import 'package:armm_app/database/database.dart'; // Import the database service
import 'package:armm_app/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_functions/cloud_functions.dart';

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
      // Create a temporary database service for uploading
      DatabaseService dbService = DatabaseService.withCID('', '');
      
      // Use the imageIdentifier parameter since we don't have a proper CID yet
      final identifier = widget.cid.isNotEmpty ? widget.cid : widget.email;
      
      final downloadUrl = await dbService.uploadProfilePicture(
        _imageFile!, 
        imageIdentifier: identifier,
      );
      
      log('Profile picture uploaded successfully: $downloadUrl');

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AppLockPromptPage()),
        );
      }
    } catch (e, stack) {
      log('Error uploading profile picture: $e', stackTrace: stack);
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

  void _skipToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AppLockPromptPage()),
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
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              child: Column(
                children: [
                  // Modern header with improved layout
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Skip button above the title, right-aligned
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: _skipToNextPage,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Skip',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Title row without skip button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Profile Picture',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Subtitle
                      Text(
                        'Add a profile picture to personalize your account.',
                        style: GoogleFonts.inter(
                          fontSize: 14, 
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  // Main content with improved design
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          // Enhanced profile picture preview
                          _imageFile != null
                              ? Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width: 220,
                                      height: 220,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 6,
                                        ),
                                        image: DecorationImage(
                                          image: FileImage(_imageFile!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    // Edit icon overlay
                                    GestureDetector(
                                      onTap: _showProfilePictureOptions,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.edit_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade100,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            spreadRadius: 1,
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ShaderMask(
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            AppColors.primary,
                                            AppColors.primary.withOpacity(0.7),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icons/mystery.svg',
                                        height: 120,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // Camera icon overlay
                                    Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: _showProfilePictureOptions,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt_rounded,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 24),

                          // Title with updated styling
                          Text(
                            'Add a Profile Picture',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 26,
                              color: Colors.black,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 25),

                          // Help text instead of button when image is already selected
                          if (_imageFile != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: Text(
                                'Tap the edit button on your photo\nto change it.',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          // Select Photo Button with improved design when no image
                          else
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 40),
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _showProfilePictureOptions,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.add_photo_alternate_rounded, size: 20),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Select Photo',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          const SizedBox(height: 24),
                          
                          // Continue button shown only when image is selected
                          if (_imageFile != null) 
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 40),
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _uploadProfilePicture,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 1,
                                  shadowColor: AppColors.primary.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text(
                                  'Continue',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  
                  // Modern page indicator dots
                  Container(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: AppColors.primary,
                          ),
                        ),
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
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
