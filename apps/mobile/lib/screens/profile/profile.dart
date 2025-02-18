import 'package:armm_app/auth/login/login.dart';
<<<<<<< HEAD
import 'package:armm_app/screens/profile/components/name_cid.dart';
import 'package:armm_app/screens/profile/components/profile_buttons.dart';
import 'package:armm_app/utils/app_bar.dart';
import 'package:armm_app/utils/bottom_nav.dart';
import 'package:armm_app/client_model.dart';
import 'package:flutter/material.dart';
import 'package:armm_app/auth/auth_utils/auth_functions.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
=======
import 'package:armm_app/screens/profile/name_cid.dart';
import 'package:armm_app/screens/profile/profile_buttons.dart';
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
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
<<<<<<< HEAD
  Client? client;
=======
  late final String cid;
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    client = Provider.of<Client?>(context);
=======
    cid = widget.cid;
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

<<<<<<< HEAD
=======

>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
  Future<void> _signOut() async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
<<<<<<< HEAD
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NameAndCID(),
            const SizedBox(height: 24),
            ProfileButtons(onLogout: _signOut),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentItem: NavigationItem.profile,
      ),
=======
      MaterialPageRoute(builder: (context) => LoginPage(signUpData: SignUpData())),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: const CustomAppBar(
        title: 'Profile',
      ),
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
    
    
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NameAndCID(client: client, cid: cid),
                  const SizedBox(height: 24),
                  ProfileButtons(onLogout: _signOut),

                ],
              ),
            );
          }
        ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      )
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
    );
  }
}