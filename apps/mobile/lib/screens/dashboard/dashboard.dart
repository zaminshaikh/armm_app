// lib/screens/dashboard/dashboard.dart
import 'dart:developer';
import 'package:armm_app/components/assets_structure_section.dart';
import 'package:armm_app/database/models/activity_model.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/dashboard/components/dashboard_app_bar.dart';
import 'package:armm_app/screens/dashboard/components/three_recent_activities.dart';
import 'package:armm_app/screens/dashboard/components/total_assets_section.dart';
import 'package:armm_app/screens/dashboard/components/user_breakdown_section.dart';
import 'package:armm_app/screens/notifications/notifications.dart';
import 'package:armm_app/utils/app_bar.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:armm_app/utils/bottom_nav.dart';
import 'package:armm_app/utils/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:armm_app/components/custom_progress_indicator.dart';

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
  late final PageController _connectedUsersPageController;
  int _currentConnectedUserPage = 0;
  Future<String?>? _profilePicUrlFuture;

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

    // Initialize controller for connected users carousel
    _connectedUsersPageController = PageController();
    _connectedUsersPageController.addListener(() {
      final page = _connectedUsersPageController.page?.round() ?? 0;
      if (page != _currentConnectedUserPage) {
        setState(() => _currentConnectedUserPage = page);
      }
    });
  }

  @override
  void dispose() {
    _connectedUsersPageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    client = Provider.of<Client?>(context);
    _retrieveActivities();

    // Initialize profile‑pic once
    if (client != null && _profilePicUrlFuture == null) {
      _profilePicUrlFuture = FirebaseStorage
        .instance
        .ref('profilePics/${client!.cid}.jpg')
        .getDownloadURL()
        .catchError((_) => '');
    }
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
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 251, 251, 251),
        appBar: DashboardAppBar(
          client: null,
          showNotificationButton: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Skeleton for User breakdown section
                _buildSkeletonCard(height: 150),
                const SizedBox(height: 20),
                
                // Skeleton for Recent transactions
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSkeletonCard(height: 80),
                    const SizedBox(height: 8),
                    _buildSkeletonCard(height: 80),
                    const SizedBox(height: 8),
                    _buildSkeletonCard(height: 80),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Skeleton for Asset structure
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSkeletonCard(height: 250),
                  ],
                ),
                const SizedBox(height: 42),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(currentItem: NavigationItem.dashboard),
      );
    }
  
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 251, 251),
      appBar: client != null
        ? DashboardAppBar(
            client: client!,
            profilePicFuture: _profilePicUrlFuture,    // ← pass it here
            showNotificationButton: true,
            onNotificationTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationPage(),
          ),
        );
            },
          )
        : null, // Show nothing if client is null

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                  // Assets structure section (pie chart)
                  ...fundCharts,
                  const SizedBox(height: 42),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentItem: NavigationItem.dashboard,),
    );
  }

  // Helper method to build skeleton cards
  Widget _buildSkeletonCard({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget buildRecentTransactionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ActivityTilesSection(activities: activities),
      ],
    );
  }
  
  Widget _buildConnectedUsersSection() => Column(
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              Text(
                'Connected Users',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                '(${client!.connectedUsers?.length})',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Expandable carousel so tiles can grow dynamically
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: ExpandablePageView.builder(
              controller: _connectedUsersPageController,
              onPageChanged: (index) => setState(() => _currentConnectedUserPage = index),
              scrollDirection: Axis.horizontal,
              itemCount: client!.connectedUsers!.length,
              itemBuilder: (context, index) {
                final connectedUser = client!.connectedUsers![index]!;
                return UserBreakdownSection(
                  client: connectedUser,
                  isConnectedUser: true,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // sliding indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              client!.connectedUsers!.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentConnectedUserPage == index
                      ? AppColors.primary
                      : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      );
}
