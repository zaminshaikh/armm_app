import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/screens/profile/components/name_cid.dart';
import 'package:armm_app/screens/profile/components/profile_buttons.dart';
import 'package:armm_app/signup_data.dart';
import 'package:armm_app/utils/app_bar.dart';
import 'package:armm_app/utils/bottom_nav.dart';
import 'package:armm_app/client_model.dart';
import 'package:armm_app/database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:armm_app/auth/auth_utils/auth_functions.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatefulWidget {
  final String cid;

  const ProfilePage({Key? key, required this.cid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
  late final String cid;
  Client? client;

  @override
  void initState() {
    super.initState();
    cid = widget.cid;
    _loadClient();
  }

  Future<void> _loadClient() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(cid).get();
      if (snapshot.exists && snapshot.data() != null) {
        Client loadedClient = Client.fromMap(snapshot.data()!, snapshot.id);
        setState(() {
          client = loadedClient;
        });
      } else {
        setState(() {
          client = null;
        });
      }
    } catch (e, stacktrace) {
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _signOut() async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(signUpData: SignUpData())),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If client is null, show a loader and log the null client state
    if (client == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: 'Profile'),
        body: const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      );
    }
    // Build UI with the loaded client model
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NameAndCID(client: client!, cid: cid),
            const SizedBox(height: 24),
            ProfileButtons(onLogout: _signOut),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}