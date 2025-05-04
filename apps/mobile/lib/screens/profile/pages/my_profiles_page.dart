// ignore_for_file: deprecated_member_use, use_build_context_synchronously, duplicate_ignore, prefer_expression_function_bodies, unused_catch_clause, empty_catches

import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/profile/components/name_cid.dart';
import 'package:armm_app/utils/app_bar.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:armm_app/components/custom_progress_indicator.dart';
import 'package:armm_app/utils/utilities.dart';

class MyProfilesPage extends StatefulWidget {
  const MyProfilesPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _MyProfilesPageState createState() => _MyProfilesPageState();
}

class _MyProfilesPageState extends State<MyProfilesPage> {
  Client? client;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    client = Provider.of<Client?>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (client == null) {
      return const CustomProgressIndicator(
        shouldTimeout: true,
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Profiles',
        implyLeading: true,
        showNotificationButton: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profilesForUser(),
            if (client!.connectedUsers != null &&
                client!.connectedUsers!.isNotEmpty)
              _profilesForConnectedUser(),
          ],
        ),
      ),
    );
  }

// This is the Profiless section
  Container _profilesForUser() => Container(
    child: Column(
      children: [

        clientCard(client!),

      ],
    ),
  
  );

// This is the Profiless section
  Container _profilesForConnectedUser() {
    if (client!.connectedUsers == null || client!.connectedUsers!.isEmpty) {
      return Container();
    }
    return Container(
      child: Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            itemCount: client!.connectedUsers!.length,
            itemBuilder: (context, index) {
              return 
              Column(
                children: [
                  clientCard(client!.connectedUsers![index]!),
                  const SizedBox(height: 20),
                ],
              );
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }


Widget clientCard(Client c) {
  // Example: formatting the "firstDepositDate" in dd.MM.yyyy at hh:mm a
  // e.g. 01.08.2014 at 08:00 PM
  final formattedDate = c.firstDepositDate != null ? DateFormat("MMM dd, yyyy 'at' hh:mm a").format(c.firstDepositDate!) : 'N/A';

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color.fromARGB(70, 0, 0, 0)
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2), // subtle shadow
          spreadRadius: 2,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Center align only the name and CID
        Center(
          child: Column(
            children: [
              // --- Name ---
              Text(
                formatName(c.firstName, c.lastName),
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // --- Client ID ---
              Text(
                'Client ID: ${c.cid}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Left align all the details below
        // --- First Deposit Date ---
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'First Deposit Date:',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(150, 0, 0, 0),
              ),
            ),
            Text(
              formattedDate,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // --- Communication Email ---
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Communication Email:',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(150, 0, 0, 0),
              ),
            ),
            Text(
              (c.initEmail == null || c.initEmail!.isEmpty) ? 'N/A' : c.initEmail!,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // --- Phone Number ---
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phone Number:',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(150, 0, 0, 0),
              ),
            ),
            Text(
              (c.phoneNumber == null || c.phoneNumber!.isEmpty) ? 'N/A' : c.phoneNumber!,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // --- Address ---
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Address:',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(150, 0, 0, 0),
              ),
            ),
            Text(
              (c.address == null || c.address!.isEmpty) ? 'N/A' : c.address!,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

}
