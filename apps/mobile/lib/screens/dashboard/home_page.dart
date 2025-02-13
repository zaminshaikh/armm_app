import 'package:armm_app/auth/auth_utils/auth_functions.dart';
import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/signup_data.dart';
import 'package:flutter/material.dart';

/// Stateless version
class HomePage extends StatelessWidget {
  final SignUpData signUpData;

  const HomePage({Key? key, required this.signUpData}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(signUpData: signUpData)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Client Info")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You are logged in!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _signOut(context),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stateful version
class HomePageStateful extends StatefulWidget {
  final SignUpData signUpData;

  const HomePageStateful({Key? key, required this.signUpData}) : super(key: key);

  @override
  _HomePageStatefulState createState() => _HomePageStatefulState();
}

class _HomePageStatefulState extends State<HomePageStateful> {
  final AuthService _authService = AuthService();

  Future<void> _signOut(BuildContext context) async {
    await _authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(signUpData: widget.signUpData)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Client Info")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You are logged in!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _signOut(context),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}