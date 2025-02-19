import 'package:armm_app/auth/login/login.dart';
<<<<<<< HEAD
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
=======
import 'package:armm_app/screens/profile/components/name_cid.dart';
import 'package:armm_app/screens/profile/components/profile_buttons.dart';
>>>>>>> 8938814 (Changed File Structure of the Profile Page and its Components)
import 'package:armm_app/signup_data.dart';
import 'package:armm_app/utils/app_bar.dart';
import 'package:armm_app/utils/bottom_nav.dart';
import 'package:armm_app/client_model.dart';
import 'package:flutter/material.dart';
import 'package:armm_app/auth/auth_utils/auth_functions.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
<<<<<<< HEAD
  final String cid;

  const ProfilePage({Key? key, required this.cid}) : super(key: key);
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
=======
  const ProfilePage({Key? key}) : super(key: key);
>>>>>>> 1a0bccc (Made Custom Activity App Bar)

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
  Client? client;
=======
  late final String cid;
<<<<<<< HEAD
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
=======
  Client? client;
>>>>>>> 8938814 (Changed File Structure of the Profile Page and its Components)

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
<<<<<<< HEAD
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    client = Provider.of<Client?>(context);
=======
    cid = widget.cid;
<<<<<<< HEAD
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
=======
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
>>>>>>> 8938814 (Changed File Structure of the Profile Page and its Components)
=======
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    client = Provider.of<Client?>(context);
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======

>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
=======
>>>>>>> 8938814 (Changed File Structure of the Profile Page and its Components)
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
<<<<<<< HEAD
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
<<<<<<< HEAD
      )
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
=======
=======
        currentItem: NavigationItem.profile,
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
      ),
>>>>>>> 8938814 (Changed File Structure of the Profile Page and its Components)
    );
  }
}