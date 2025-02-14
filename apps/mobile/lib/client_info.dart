import 'package:armm_app/client_model.dart';
import 'package:armm_app/database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:armm_app/auth/auth_utils/auth_functions.dart';

class ClientInfoPage extends StatefulWidget {
  final String cid; // If signing up, pass the CID; if logging in, pass an empty string

  const ClientInfoPage({Key? key, required this.cid}) : super(key: key);

  @override
  _ClientInfoPageState createState() => _ClientInfoPageState();
}

class _ClientInfoPageState extends State<ClientInfoPage> {

  late final String cid;

  @override
  void initState() {
    super.initState();
    cid = widget.cid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Client Info")),
      body: cid.isEmpty 
          ? const Center(child: Text("Client ID not provided."))
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('users').doc(cid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("No client data available."));
                }
                final data = snapshot.data!.data();
                if (data == null) {
                  return const Center(child: Text("No client data available."));
                }
                final client = Client.fromMap(data, snapshot.data!.id);

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Client UID: ${client.uid}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Selected: ${client.selected}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("First Name: ${client.firstName}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Last Name: ${client.lastName}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Init Email: ${client.initEmail}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("App Email: ${client.appEmail}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Address: ${client.address}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Street: ${client.street}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("City: ${client.city}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("State: ${client.state}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Province: ${client.province}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Zip: ${client.zip}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Country: ${client.country}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Company Name: ${client.companyName}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Phone Number: ${client.phoneNumber}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Beneficiaries: ${client.beneficiaries.join(', ')}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Connected Users: ${client.connectedUsers.join(', ')}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text(
                          "Date of Birth: ${client.dob != null ? client.dob!.toDate().toString() : 'N/A'}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "First Deposit Date: ${client.firstDepositDate != null ? client.firstDepositDate!.toDate().toString() : 'N/A'}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text("Last Logged In: ${client.lastLoggedIn}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Notes: ${client.notes}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => AuthService().signOut(),
                          child: const Text('Log Out'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}