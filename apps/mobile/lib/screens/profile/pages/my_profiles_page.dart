<<<<<<< HEAD
// ignore_for_file: deprecated_member_use, use_build_context_synchronously, duplicate_ignore, prefer_expression_function_bodies, unused_catch_clause, empty_catches

import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/profile/components/name_cid.dart';
import 'package:armm_app/utils/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      return const Center(child: CircularProgressIndicator());
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
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
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
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                'Connected Users',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),
            ],
          ),
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client's Name
            Text(
              '${c.firstName} ${c.lastName}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // Client ID
            Text(
              'Client ID: ${c.cid}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            // First Deposit Date
            Text(
              'First Deposit Date: ${c.firstDepositDate.toString()}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            // Communication Email
            Text(
              'Communication Email: ${c.initEmail}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            // Phone Number
            Text(
              'Phone Number: ${c.phoneNumber}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            // Address
            Text(
              'Address: ${c.address}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

=======
import 'package:flutter/material.dart';

class MyProfilesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profiles'),
      ),
      body: Center(
        child: Text('My Profiles Page'),
      ),
    );
  }
>>>>>>> 74eb99f (Made Dummy Sub-Pages For the Profile Page)
}
