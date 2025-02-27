import 'package:armm_app/utils/app_bar.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:armm_app/utils/bottom_nav.dart';
=======
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
import 'package:armm_app/utils/bottom_nav.dart';
>>>>>>> 133d30b (Add BottomNavBar to AnalyticsPage for improved navigation)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:armm_app/components/assets_structure_section.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/analytics/components/line_chart.dart';


class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  AnalyticsPageState createState() => AnalyticsPageState();
}

class AnalyticsPageState extends State<AnalyticsPage> {
  Client? client;
  late List<Client> allClients;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    client = Provider.of<Client?>(context);
    // Build a combined list of the main client plus any connected clients.
    allClients = [];
    if (client != null) {
      allClients.add(client!);
      if (client!.connectedUsers != null) {
        for (final c in client!.connectedUsers!) {
          if (c != null) {
            allClients.add(c);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (client == null) {
      return const CircularProgressIndicator();
    }
  
    final List<Widget> fundCharts = [];
    final funds = client?.assets?.funds ?? {};
  
    funds.forEach((fundName, fund) {
      final totalAssets =
          fund.assets.values.fold(0.0, (sum, asset) => sum + asset.amount);
      if (totalAssets > 0) {
        fundCharts.add(
          Column(
            children: [
              AssetsStructureSection(
                client: client!,
                fundName: fundName,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }
    });
  
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      appBar: CustomAppBar(
        title: 'Analytics',
        implyLeading: false,
        showNotificationButton: true,
=======
      appBar: CustomAppBar(
        title: 'Analytics',
        implyLeading: false,
<<<<<<< HEAD
        showNotificationButton: false,
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
        showNotificationButton: true,
>>>>>>> c69b9d5 (Enable notification button on AnalyticsPage and update brand color references in LineChartSection for consistency)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Line chart section
              LineChartSection(client: client!),
              // Display the fund-based pie charts
              ...fundCharts,
<<<<<<< HEAD
<<<<<<< HEAD
=======
              const SizedBox(height: 120),
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
>>>>>>> c69b9d5 (Enable notification button on AnalyticsPage and update brand color references in LineChartSection for consistency)
            ],
          ),
        ),
      ),
<<<<<<< HEAD
<<<<<<< HEAD
      bottomNavigationBar: const BottomNavBar(currentItem: NavigationItem.analytics),
=======
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
      bottomNavigationBar: const BottomNavBar(currentItem: NavigationItem.analytics),
>>>>>>> 133d30b (Add BottomNavBar to AnalyticsPage for improved navigation)
    );
  }



}