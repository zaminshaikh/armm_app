import 'package:armm_app/client_model.dart';
import 'package:armm_app/database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:armm_app/screens/auth/auth.dart';
import 'signup_data.dart'; // (Not needed anymore here if we only require the CID)

// This widget now only requires a cid parameter.
class ClientInfoPage extends StatefulWidget {
  final String cid; // If signing up, pass the CID; if logging in, pass an empty string

  const ClientInfoPage({Key? key, required this.cid}) : super(key: key);

  @override
  _ClientInfoPageState createState() => _ClientInfoPageState();
}

class _ClientInfoPageState extends State<ClientInfoPage> {
  Client? _client;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _init(); // asynchronously determine the correct CID and fetch client data.
  }

  Future<void> _init() async {
    String? cid = widget.cid;
    // If no CID was provided (e.g. during login), look up the CID by UID.
    if (cid.isEmpty) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Assuming you have a method to fetch the CID from your Firestore mapping
        cid = (await DatabaseService.fetchCID(currentUser.uid, context)) as String?;
      }
    }

    if (cid == null || cid.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Client ID not found.")),
      );
      return;
    }

    print("Client ID: $cid");
    final client = await getClientData(cid);
    if (client != null) {
      setState(() {
        _client = client;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Client data not found.")),
      );
    }
  }

  Future<Client?> getClientData(String cid) async {
    if (cid.isEmpty) {
      print("Error: Client ID is empty.");
      return null;
    }
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(cid).get();
      print("Fetching Firestore document: users/$cid");
      if (doc.exists && doc.data() != null) {
        return Client.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        print("Client with id $cid does not exist.");
        return null;
      }
    } catch (e) {
      print("Error fetching client data: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Client ID received in client_info page: ${widget.cid}"); // DEBUG PRINT
    return Scaffold(
      appBar: AppBar(title: const Text("Client Info")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _client != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Client UID: ${_client!.uid}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Selected: ${_client!.selected}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("First Name: ${_client!.firstName}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Last Name: ${_client!.lastName}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Init Email: ${_client!.initEmail}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("App Email: ${_client!.appEmail}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Address: ${_client!.address}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Street: ${_client!.street}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("City: ${_client!.city}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("State: ${_client!.state}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Province: ${_client!.province}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Zip: ${_client!.zip}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Country: ${_client!.country}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Company Name: ${_client!.companyName}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Phone Number: ${_client!.phoneNumber}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Beneficiaries: ${_client!.beneficiaries.join(', ')}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Connected Users: ${_client!.connectedUsers.join(', ')}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text(
                          "Date of Birth: ${_client!.dob != null ? _client!.dob!.toDate().toString() : 'N/A'}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "First Deposit Date: ${_client!.firstDepositDate != null ? _client!.firstDepositDate!.toDate().toString() : 'N/A'}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text("Last Logged In: ${_client!.lastLoggedIn}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text("Notes: ${_client!.notes}", style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => AuthService().signOut(),
                          child: const Text('Log Out'),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(child: Text("No client data available.")),
    );
  }
}