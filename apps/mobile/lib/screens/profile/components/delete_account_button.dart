// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/database/auth_helper.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/utils/resources.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAccountButton extends StatefulWidget { // Renamed widget
  final Client client;

  const DeleteAccountButton({super.key, required this.client});

  @override
  DeleteAccountButtonState createState() => DeleteAccountButtonState(); // Renamed state class
}

class DeleteAccountButtonState extends State<DeleteAccountButton> { // Renamed state class
  final TextEditingController _clientIdController = TextEditingController();
  final FocusNode _clientIdFocusNode = FocusNode(); // Add a FocusNode
  String? _errorText; // Added error text state variable

  @override
  void dispose() {
    _clientIdController.dispose();
    _clientIdFocusNode.dispose(); // Dispose the FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red, width: 1.5),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        onPressed: () => _showDeleteAccountDialog(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/trash.svg',
              width: 20,
              height: 20,
              color: Colors.red,
            ),
            const SizedBox(width: 12),
            const Text(
              'Delete Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    _clientIdController.clear(); // Clear the input field
    setState(() {
      _errorText = null;
    });

    showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Create the input widget with TextField
            Widget inputWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please enter your CID to confirm:",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _clientIdController,
                  focusNode: _clientIdFocusNode,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black), // Added style for black text
                  decoration: InputDecoration(
                  hintText: 'Your CID: ${widget.client.cid}',
                  errorText: _errorText,
                  ),
                  onChanged: (value) {
                  if (value.length >= 8) {
                    _clientIdFocusNode.unfocus();
                  }
                  // Clear error when user types
                  if (_errorText != null) {
                    setDialogState(() {
                    _errorText = null;
                    });
                  }
                  },
                ),
              ],
            );

            return CustomAlertDialog(
              title: "Confirm Delete Account",
              message: "Are you sure you want to permanently delete your account?",
              input: inputWidget,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (_clientIdController.text != widget.client.cid) {
                      setDialogState(() {
                        _errorText = 'CID does not match';
                      });
                      return;
                    }
                    Navigator.of(dialogContext).pop(true);
                    _deleteAccount();
                  },
                  child: const Text("Delete", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteAccount() async { // Renamed method
    log('delete_account_button.dart: Deleting account...'); 

    Future<void> handleDeleteAccount() async {
      await deleteFirebaseMessagingToken(FirebaseAuth.instance.currentUser, context);

      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('unlinkUser');
      final response = await callable.call({
        'uid': widget.client.uid,
        'cid': widget.client.cid,
        'usersCollectionID': Config.get('FIRESTORE_ACTIVE_USERS_COLLECTION'),
      });
      log('Cloud function unlinkUser called successfully: ${response.data}');

      await FirebaseAuth.instance.signOut();

      assert(FirebaseAuth.instance.currentUser == null);
    }

    unawaited(handleDeleteAccount());

    if (!mounted) {
        return;
    }

    await Navigator.of(context).pushNamedAndRemoveUntil('/onboarding', (route) => false);
     
    return;
  }
  
}


