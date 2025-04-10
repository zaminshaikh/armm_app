import 'package:armm_app/auth/login/login.dart';
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

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
  Client? client;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    client = Provider.of<Client?>(context);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _signOut() async {
    await AuthService().signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
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
      bottomNavigationBar: const BottomNavBar(
        currentItem: NavigationItem.profile,
      ),
    );
  }
}