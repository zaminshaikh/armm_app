// lib/screens/dashboard/dashboard.dart
import 'dart:developer';
import 'package:armm_app/components/assets_structure_section.dart';
import 'package:armm_app/database/models/activity_model.dart';
import 'package:armm_app/database/models/client_model.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:armm_app/screens/dashboard/components/dashboard_app_bar.dart';
=======
>>>>>>> 7b97856 (Migrated components for dashboard)
=======
import 'package:armm_app/screens/dashboard/components/dashboard_app_bar.dart';
>>>>>>> 431e0b9 (Replace Inter font files with updated versions and adjust pubspec.yaml for new font assets)
import 'package:armm_app/screens/dashboard/components/three_recent_activities.dart';
import 'package:armm_app/screens/dashboard/components/total_assets_section.dart';
import 'package:armm_app/screens/dashboard/components/user_breakdown_section.dart';
import 'package:armm_app/utils/app_bar.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:armm_app/utils/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:google_fonts/google_fonts.dart';
=======
>>>>>>> 7b97856 (Migrated components for dashboard)
=======
import 'package:google_fonts/google_fonts.dart';
>>>>>>> 5502a8a (Completed Dashboard App Bar)
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  final bool fromFaceIdPage;

  const DashboardPage({super.key, this.fromFaceIdPage = false});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  AuthState? authState;
  Client? client;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    _loadAppLockState();
    // Initialize the animation controller and set its value to 1.0 by default
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..value = 1.0; // Animation is at the end by default

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5), // Start position (offset)
      end: Offset.zero, // End position (no offset)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Initialize the transition state
    _initializeTransitionState();
    // Initialize the auth state and update the state
    _updateAuthState();
    // Validate whether the user is authenticated
    _validateAuth();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    client = Provider.of<Client?>(context);
    _retrieveActivities();
  }

  Future<void> _loadAppLockState() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('isAppLockEnabled') ?? false;
    context.read<AuthState>().setAppLockEnabled(isEnabled);
    print('Loaded app lock state: $isEnabled');
  }

  void _updateAuthState() {
    // Initialize our authState if it's null
    authState ??= AuthState();

    // Check if hasNavigatedToFaceIDPage is null and set it to false if it is
    if (authState?.hasNavigatedToFaceIDPage == null) {
      authState?.setHasNavigatedToFaceIDPage(false);
    }

    if (widget.fromFaceIdPage) {
      authState?.setHasNavigatedToFaceIDPage(false);
      authState?.setJustAuthenticated(true);
    } else {}
  }

  /// Initializes the transition state and handles the animation logic.
  Future<void> _initializeTransitionState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasTransitioned = prefs.getBool('hasTransitioned') ?? false;

    if (!hasTransitioned) {
      // Reset controller to start of animation
      _controller.value = 0.0;

      // Start the animation
      await _controller.forward().whenComplete(() async {
        // Set the flag to true after the animation completes
        await prefs.setBool('hasTransitioned', true);
      });
    } else {
      // Animation has already been shown; controller remains at end
      _controller.value = 1.0;
    }
  }

  Future<void> _validateAuth() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null && mounted) {
      log('dashboard.dart: User is not logged in');
      await Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _retrieveActivities() {
    activities = List.from(client?.activities ?? []);
    if (client?.connectedUsers != null && client!.connectedUsers!.isNotEmpty) {
      final connectedUserActivities = client!.connectedUsers!
          .where((user) => user != null)
          .expand((user) => user!.activities ?? [].cast<Activity>());
      activities.addAll(connectedUserActivities);
    }
  
    activities.sort((a, b) => b.time.compareTo(a.time)); 
    activities = activities.take(3).toList();
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> fundCharts = [];
    final funds = client?.assets?.funds ?? {};
  
    // Loop through each fund to see if it has a non-zero total
    funds.forEach((fundName, fund) {
      final totalAssets = fund.assets.values.fold(0.0, (sum, asset) => sum + asset.amount);
      if (totalAssets > 0) {
        fundCharts.add(
          Column(
            children: [
              SlideTransition(
                position: _offsetAnimation,
                child: AssetsStructureSection(
                  client: client!,
                  fundName: fundName, // Dynamically pass each fund's name
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }
    });
  
    if (client == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  
    return Scaffold(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      backgroundColor: const Color.fromARGB(255, 251, 251, 251),
=======
>>>>>>> 431e0b9 (Replace Inter font files with updated versions and adjust pubspec.yaml for new font assets)
=======
      backgroundColor: const Color.fromARGB(255, 251, 251, 251),
>>>>>>> b47751c (Set dashboard background color and remove font test button)
      appBar: client != null
      ? DashboardAppBar(
          showNotificationButton: true,
          onNotificationTap: () {
            Navigator.pushNamed(context, '/notifications');
          },
          client: client!,
        ) : null, // Show nothing if client is null
<<<<<<< HEAD
=======
      appBar: CustomAppBar(
        title: 'Dashboard',
        showNotificationButton: true,
        onNotificationTap: () {
          Navigator.pushNamed(context, '/notifications');
        },
      ),
>>>>>>> 7b97856 (Migrated components for dashboard)
=======
>>>>>>> 431e0b9 (Replace Inter font files with updated versions and adjust pubspec.yaml for new font assets)
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
<<<<<<< HEAD
<<<<<<< HEAD
=======
                  // Total assets section
                  SlideTransition(
                    position: _offsetAnimation,
                    child: TotalAssetsSection(client: client!),
                  ),
                  const SizedBox(height: 32),
>>>>>>> 7b97856 (Migrated components for dashboard)
=======
>>>>>>> 431e0b9 (Replace Inter font files with updated versions and adjust pubspec.yaml for new font assets)
                  // User breakdown section
                  SlideTransition(
                    position: _offsetAnimation,
                    child: UserBreakdownSection(client: client!),
                  ),
                  if (client!.connectedUsers != null && client!.connectedUsers!.isNotEmpty)
                    SlideTransition(
                      position: _offsetAnimation,
                      child: _buildConnectedUsersSection(),
                    ),
                  const SizedBox(height: 12),
                  // Recent transactions section
                  SlideTransition(
                    position: _offsetAnimation,
                    child: buildRecentTransactionsSection(context),
                  ),
                  const SizedBox(height: 42),
                  // Assets structure section (pie chart)
                  ...fundCharts,
<<<<<<< HEAD
=======
                  const SizedBox(height: 102),
>>>>>>> 7b97856 (Migrated components for dashboard)
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentItem: NavigationItem.dashboard,),
    );
  }


  Widget buildRecentTransactionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Text(
            'Recent Transactions',
<<<<<<< HEAD
<<<<<<< HEAD
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
=======
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Titillium Web',
>>>>>>> 7b97856 (Migrated components for dashboard)
=======
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
>>>>>>> 5502a8a (Completed Dashboard App Bar)
            ),
          ),
        ),
        const SizedBox(height: 12),
        ActivityTilesSection(activities: activities),
      ],
    );
  }
  
  Widget _buildConnectedUsersSection() => Column(
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
<<<<<<< HEAD
<<<<<<< HEAD
              Text(
                'Connected Users',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
=======
              const Text(
=======
              Text(
>>>>>>> 5502a8a (Completed Dashboard App Bar)
                'Connected Users',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
<<<<<<< HEAD
                  fontFamily: 'Titillium Web',
>>>>>>> 7b97856 (Migrated components for dashboard)
=======
>>>>>>> 5502a8a (Completed Dashboard App Bar)
                ),
              ),
              const Spacer(),
              Text(
                '(${client!.connectedUsers?.length})',
<<<<<<< HEAD
<<<<<<< HEAD
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
=======
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Titillium Web',
>>>>>>> 7b97856 (Migrated components for dashboard)
=======
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
>>>>>>> 5502a8a (Completed Dashboard App Bar)
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: client!.connectedUsers!
                .map(
                  (connectedUser) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserBreakdownSection(
                        client: connectedUser!,
                        isConnectedUser: true,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      );
}
