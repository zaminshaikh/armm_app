import 'dart:ui';

<<<<<<< HEAD
<<<<<<< HEAD
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
=======
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/database/models/graph_model.dart';
import 'package:armm_app/database/models/graph_point_model.dart';
import 'package:armm_app/screens/analytics/utils/analytics_utilities.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/svg.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:google_fonts/google_fonts.dart';
=======
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
import 'package:google_fonts/google_fonts.dart';
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
import 'package:intl/intl.dart';

/// A widget that displays the line chart section in the Analytics page.
class LineChartSection extends StatefulWidget {
  final Client client;

  const LineChartSection({Key? key, required this.client}) : super(key: key);

  @override
  _LineChartSectionState createState() => _LineChartSectionState();
}

class _LineChartSectionState extends State<LineChartSection> {
  // Line chart data
  List<FlSpot> spots = [];
  double _minAmount = double.maxFinite;
  double _maxAmount = 0.0;
  String dropdownValue = 'last-2-years';

  // Account selection
  String? selectedAccount;
  Graph? selectedGraph;

  // Client selection
  late final List<Client> allClients;
  Client? selectedClient;

  // BRAND COLOR: replace with your actual brand color
<<<<<<< HEAD
<<<<<<< HEAD
  final Color ARMMBlue = const Color(0xFF2B41B8);
=======
  final Color brandBlue = const Color(0xFF2B41B8);
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
  final Color ARMMBlue = const Color(0xFF2B41B8);
>>>>>>> c69b9d5 (Enable notification button on AnalyticsPage and update brand color references in LineChartSection for consistency)

  @override
  void initState() {
    super.initState();
    allClients = [
      widget.client,
      ...(widget.client.connectedUsers?.whereType<Client>() ?? [])
    ];
    selectedClient = allClients.isNotEmpty ? allClients.first : null;

    // Default to the 'cumulative' graph if available
    if (selectedClient != null && (selectedClient!.graphs?.isNotEmpty ?? false)) {
      selectedGraph = selectedClient!.graphs!.firstWhere(
        (g) => g.account.toLowerCase() == 'cumulative',
        orElse: () => selectedClient!.graphs!.first,
      );
      selectedAccount = selectedGraph?.account;
    }
    _prepareGraphPoints();
  }

  /// Prepares data points for the line chart
  void _prepareGraphPoints() {
    spots.clear();

    double localMinAmount = double.maxFinite;
    double localMaxAmount = 0.0;

    if (selectedGraph != null && selectedGraph!.graphPoints.isNotEmpty) {
      for (var point in selectedGraph!.graphPoints) {
        final DateTime dateTime = point.time;
        final double amount = point.amount;

        final double xValue = calculateXValue(dateTime, dropdownValue);
        if (xValue >= 0) {
          spots.add(FlSpot(xValue, amount));
        }
      }

      // Sort by x-value
      spots.sort((a, b) => a.x.compareTo(b.x));

      // Insert starting spot if needed
      if (spots.isNotEmpty && spots.first.x > 0) {
        double firstXValue = spots.first.x;
        double startingY = 0;

        for (var point in selectedGraph!.graphPoints.reversed) {
          double xValue = calculateXValue(point.time, dropdownValue);
          if (xValue < firstXValue) {
            startingY = point.amount;
            break;
          }
        }
        spots.insert(0, FlSpot(0, startingY));
      }

      // Insert ending spot if needed
      double maxXValue = maxX(dropdownValue);
      if (spots.isNotEmpty && spots.last.x < maxXValue) {
        FlSpot lastSpot = spots.last;
        spots.add(FlSpot(maxXValue, lastSpot.y));
      } else if (spots.isEmpty) {
        // No data => add default spots
        GraphPoint mostRecentSpot = selectedGraph!.graphPoints.last;
        spots.add(FlSpot(0, mostRecentSpot.amount));
        spots.add(FlSpot(maxXValue, mostRecentSpot.amount));
        _maxAmount = mostRecentSpot.amount * 1.5;
      }
    } else {
      // No data
      localMinAmount = 0.0;
      localMaxAmount = 100000.0;
<<<<<<< HEAD
<<<<<<< HEAD
      spots.add(const FlSpot(0, 0));
=======
      spots.add(FlSpot(0, 0));
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
      spots.add(const FlSpot(0, 0));
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
      spots.add(FlSpot(maxX(dropdownValue), 0));
    }

    for (var spot in spots) {
      if (spot.y < localMinAmount) {
        localMinAmount = spot.y;
      }
      if (spot.y > localMaxAmount) {
        localMaxAmount = spot.y;
      }
    }

    setState(() {
      _minAmount = localMinAmount;
      _maxAmount = localMaxAmount;
    });
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Row of client buttons
            buildClientButtonsRow(
              context,
              allClients,
              selectedClient,
              (client) {
                setState(() {
                  selectedClient = client;
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> cb2c200 (Add null safety checks for client graphs in LineChartSection to prevent errors)
                  if (client.graphs != null && client.graphs!.isNotEmpty) {
                    selectedGraph = client.graphs!.first;
                    selectedAccount = selectedGraph?.account;
                  } else {
                    selectedGraph = null;
                    selectedAccount = null;
                  }
<<<<<<< HEAD
=======
                  selectedGraph = client.graphs?.first;
                  selectedAccount = selectedGraph?.account;
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
>>>>>>> cb2c200 (Add null safety checks for client graphs in LineChartSection to prevent errors)
                  _prepareGraphPoints();
                });
              },
              _getInitials,
            ),
            const SizedBox(height: 14),

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
            Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(15), 
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // Header with timeline label & time filter
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAssetTimelineRow(),
                          const SizedBox(height: 28),
                          _buildLatestAssets(),
                          const SizedBox(height: 15),
                        ],
                      ),
<<<<<<< HEAD
                    ),
                    const SizedBox(height: 20),
              
                    // Line chart container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: LineChart(
                            LineChartData(
                              gridData: _buildGridData(),
                              titlesData: titlesData,
                              borderData: FlBorderData(show: false),
                              // Axis limits
                              minX: 0,
                              maxX: maxX(dropdownValue),
                              minY: calculateDynamicMin(_minAmount),
                              maxY: calculateDynamicMax(_maxAmount),
                              // The line(s)
                              lineBarsData: [_buildLineChartBarData()],
                              // Touch behavior
                              lineTouchData: _buildLineTouchData(),
                            ),
=======
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Header with timeline label & time filter
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAssetTimelineRow(),
                        const SizedBox(height: 28),
                        _buildAccountModalButton(),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Line chart container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(right: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: LineChart(
                          LineChartData(
                            gridData: _buildGridData(),
                            titlesData: titlesData,
                            borderData: FlBorderData(show: false),
                            // Axis limits
                            minX: 0,
                            maxX: maxX(dropdownValue),
                            minY: calculateDynamicMin(_minAmount),
                            maxY: calculateDynamicMax(_maxAmount),
                            // The line(s)
                            lineBarsData: [_buildLineChartBarData()],
                            // Touch behavior
                            lineTouchData: _buildLineTouchData(),
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
                    ),
                    const SizedBox(height: 20),
              
                    // Line chart container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: LineChart(
                            LineChartData(
                              gridData: _buildGridData(),
                              titlesData: titlesData,
                              borderData: FlBorderData(show: false),
                              // Axis limits
                              minX: 0,
                              maxX: maxX(dropdownValue),
                              minY: calculateDynamicMin(_minAmount),
                              maxY: calculateDynamicMax(_maxAmount),
                              // The line(s)
                              lineBarsData: [_buildLineChartBarData()],
                              // Touch behavior
                              lineTouchData: _buildLineTouchData(),
                            ),
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
                          ),
                        ),
                      ),
                    ),
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
                    const SizedBox(height: 20),
                    // Date range text & possible "No data" message
                    keyAndLogoRow(),
                  ],
                ),
<<<<<<< HEAD
=======
                  ),
                  const SizedBox(height: 20),
                  // Date range text & possible "No data" message
                  keyAndLogoRow(),
                ],
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
              ),
            ),
          ],
        ),
      );

  /// Single row for date range text (bottom)
  Widget keyAndLogoRow() => Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 10),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDateRangeText(),
            ],
          ),
        ),
      );

<<<<<<< HEAD
<<<<<<< HEAD
  /// Account selection pill button
=======
  /// Account modal button
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
  /// Account selection pill button
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
  Widget _buildAccountModalButton() {
    if (selectedClient == null ||
        selectedClient!.graphs == null ||
        selectedClient!.graphs!.isEmpty) {
      return const Text(
        'No accounts',
<<<<<<< HEAD
<<<<<<< HEAD
        style: TextStyle(color: Colors.black),
=======
        style: TextStyle(color: Colors.white),
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
        style: TextStyle(color: Colors.black),
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
      );
    }

    final graphs = selectedClient!.graphs!;
    if (graphs.length == 2) {
      final nonCumulative = graphs.firstWhere(
        (graph) => graph.account.toLowerCase() != 'cumulative',
        orElse: () => graphs.first,
      );
      selectedAccount = nonCumulative.account;
      selectedGraph = nonCumulative;
    }
    if (selectedAccount == null) {
      selectedAccount = graphs.first.account;
      selectedGraph = graphs.first;
    }

    final currentAccountLabel = selectedAccount!.length > 20
        ? _getInitials(selectedAccount!)
        : selectedAccount!;

    return GestureDetector(
      onTap: graphs.length == 2
          ? null
          : () => _showAccountModalSheet(context, graphs),
      child: Container(
<<<<<<< HEAD
<<<<<<< HEAD
        // Light background & rounded corners
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 221, 221, 221),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color.fromARGB(255, 125, 125, 125),
            width: 1.5,
          )
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
=======
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
=======
        // Light background & rounded corners
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 221, 221, 221),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color.fromARGB(255, 125, 125, 125),
            width: 1.5,
          )
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
<<<<<<< HEAD
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
          mainAxisAlignment: MainAxisAlignment.center,
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
          children: [
            Text(
              currentAccountLabel,
              style: const TextStyle(
<<<<<<< HEAD
<<<<<<< HEAD
                color: Color.fromARGB(255, 126, 126, 126),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            // Show dropdown icon only if there's more than 2 graphs
            if (graphs.length > 2)
              const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF0D1E3E),
                size: 22,
              )
            else
              const SizedBox(width: 8),
=======
                color: Colors.white,
                fontFamily: 'Titillium Web',
                fontSize: 18,
                fontWeight: FontWeight.bold,
=======
                color: Color.fromARGB(255, 126, 126, 126),
                fontSize: 16,
                fontWeight: FontWeight.w600,
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
              ),
            ),
            const SizedBox(width: 6),
            // Show dropdown icon only if there's more than 2 graphs
            if (graphs.length > 2)
              const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF0D1E3E),
                size: 22,
              )
            else
<<<<<<< HEAD
              const SizedBox(width: 10),
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
              const SizedBox(width: 8),
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
  Widget _buildLatestAssets() {
      if (selectedClient == null ||
          selectedClient!.graphs == null ||
          selectedClient!.graphs!.isEmpty) {
        return const Text(
          'No accounts',
          style: TextStyle(color: Colors.black),
        );
      }
  
    final DateFormat timeFormat = DateFormat('h:mm a');
    final DateFormat dateFormat = DateFormat('MMM d, yyyy');
    String time = timeFormat.format(selectedGraph!.graphPoints.last.time);
    String date = dateFormat.format(selectedGraph!.graphPoints.last.time);


    // Return the container with proper decoration
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: const Color.fromARGB(255, 147, 147, 147),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assets',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14, // Reduced font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4), // Reduced spacing
              Text(
                '$date at $time',
                style: const TextStyle(
                  color: Color.fromARGB(255, 137, 137, 137),
                  fontSize: 12, // Smaller font size
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            NumberFormat.currency(symbol: '\$')
                .format(selectedGraph!.graphPoints.last.amount),
            style: GoogleFonts.inter(
              color: ARMMBlue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )
    );
  }
  
  
<<<<<<< HEAD
=======
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
  /// Bottom sheet for selecting an account
  void _showAccountModalSheet(BuildContext context, List<Graph> graphs) {
    List<Graph> availableGraphs = List.from(graphs);

    if (availableGraphs.length == 2) {
      availableGraphs = availableGraphs
          .where((g) => g.account.toLowerCase() != 'cumulative')
          .toList();
    }

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: Colors.white, // Light background
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            height: MediaQuery.of(ctx).size.height * 0.5,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: Colors.black, // Dark background to match theme
            ),
            child: ListView.builder(
              itemCount: availableGraphs.length,
              itemBuilder: (context, index) {
                final g = availableGraphs[index];
                final accountLabel =
                    g.account.length > 20 ? _getInitials(g.account) : g.account;
                final isSelected = (selectedAccount == g.account);

                return ListTile(
                  title: Text(
                    accountLabel,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontFamily: 'Titillium Web',
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedAccount = g.account;
                      selectedGraph = g;
                      _prepareGraphPoints();
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Horizontal list of client buttons
  Widget buildClientButtonsRow(
    BuildContext context,
    List<Client> allClients,
    Client? selectedClient,
    Function(Client) onClientSelected,
    String Function(String) getInitials,
  ) {
    if (allClients.isEmpty) {
      return const Text(
        'No clients available',
        style: TextStyle(color: Colors.white),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: allClients.map((clientItem) {
          final displayName = '${clientItem.firstName} ${clientItem.lastName}'.trim();
          final isSelected = (selectedClient == clientItem);

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => onClientSelected(clientItem),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  // **Changed** brand color fill if selected
<<<<<<< HEAD
<<<<<<< HEAD
                  color: isSelected ? ARMMBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? ARMMBlue : const Color.fromARGB(255, 165, 165, 165),
=======
                  color: isSelected ? brandBlue : Colors.black,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? brandBlue : Colors.black,
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
                  color: isSelected ? ARMMBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? ARMMBlue : const Color.fromARGB(255, 165, 165, 165),
>>>>>>> c69b9d5 (Enable notification button on AnalyticsPage and update brand color references in LineChartSection for consistency)
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/profile.svg',
                      width: 16,
                      height: 16,
<<<<<<< HEAD
<<<<<<< HEAD
                      color: isSelected ? Colors.white : const Color.fromARGB(255, 165, 165, 165),
=======
                      color: Colors.white,
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
                      color: isSelected ? Colors.white : const Color.fromARGB(255, 165, 165, 165),
>>>>>>> c69b9d5 (Enable notification button on AnalyticsPage and update brand color references in LineChartSection for consistency)
                    ),
                    const SizedBox(width: 12),
                    Text(
                      displayName.length > 20 ? getInitials(displayName) : displayName,
                      style: TextStyle(
<<<<<<< HEAD
<<<<<<< HEAD
                        color: isSelected ? Colors.white : const Color.fromARGB(255, 165, 165, 165),
=======
                        color: Colors.white,
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
                        color: isSelected ? Colors.white : const Color.fromARGB(255, 165, 165, 165),
>>>>>>> c69b9d5 (Enable notification button on AnalyticsPage and update brand color references in LineChartSection for consistency)
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
  /// Row with "Asset Timeline" label and two pill buttons (account & time filter)
  Widget _buildAssetTimelineRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // "Asset Timeline" title
        Text(
          'Asset Timeline',
            style: GoogleFonts.inter(
              fontSize: 18,
<<<<<<< HEAD
              fontWeight: FontWeight.bold,
            ),
        ),
        const SizedBox(height: 20),

        // Row of two pill-shaped buttons side by side
        Row(
          children: [
            // Account Button
            Expanded(
              child: _buildAccountModalButton(),
            ),
            const SizedBox(width: 12),

            // Time Filter Button
            Expanded(
              child: _buildTimeFilter(context),
            ),
          ],
        ),
      ],
    );
  }







  /// Time filter pill button
=======
  /// Row with "Asset Timeline" label + time filter on the right
  Widget _buildAssetTimelineRow() => Row(
        children: [
          const Text(
            'Asset Timeline',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
=======
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
              fontWeight: FontWeight.bold,
            ),
        ),
        const SizedBox(height: 20),

<<<<<<< HEAD
  /// Time filter widget
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
        // Row of two pill-shaped buttons side by side
        Row(
          children: [
            // Account Button
            Expanded(
              child: _buildAccountModalButton(),
            ),
            const SizedBox(width: 12),

            // Time Filter Button
            Expanded(
              child: _buildTimeFilter(context),
            ),
          ],
        ),
      ],
    );
  }







  /// Time filter pill button
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
  Widget _buildTimeFilter(BuildContext context) {
    final selectedText = _getTimeLabel(dropdownValue);

    return GestureDetector(
      onTap: () => _showTimeOptionsBottomSheet(context),
      child: Container(
<<<<<<< HEAD
<<<<<<< HEAD
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 221, 221, 221),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color.fromARGB(255, 125, 125, 125),
            width: 1.5,
          )
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
=======
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
=======
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 221, 221, 221),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color.fromARGB(255, 125, 125, 125),
            width: 1.5,
          )
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
<<<<<<< HEAD
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
          mainAxisAlignment: MainAxisAlignment.center,
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
          children: [
            Text(
              selectedText,
              style: const TextStyle(
<<<<<<< HEAD
<<<<<<< HEAD
                color: Color.fromARGB(255, 126, 126, 126),
                fontSize: 16,
                fontWeight: FontWeight.w600,
=======
                fontFamily: 'Titillium Web',
                color: Colors.white, // **Changed** text to white
                fontWeight: FontWeight.bold,
                fontSize: 16,
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
                color: Color.fromARGB(255, 126, 126, 126),
                fontSize: 16,
                fontWeight: FontWeight.w600,
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
              ),
            ),
            const SizedBox(width: 10),
            const RotatedBox(
              quarterTurns: 3,
              child: Icon(
                Icons.arrow_back_ios_rounded,
<<<<<<< HEAD
<<<<<<< HEAD
                color: Color.fromARGB(255, 126, 126, 126),
                size: 18,
              ),
            )
=======
                color: Colors.white, // **Changed** arrow to white
                size: 16,
              ),
            ),
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
                color: Color.fromARGB(255, 126, 126, 126),
                size: 18,
              ),
            )
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD


=======
>>>>>>> 545307b (All Analytics Widgets migrated)
=======


>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
  /// Bottom sheet with time options
  void _showTimeOptionsBottomSheet(BuildContext context) {
    var timeOptions = [
      'last-week',
      'last-month',
      'last-year',
      'year-to-date',
      'last-2-years'
    ];

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: Colors.black,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) => SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: timeOptions.length,
            itemBuilder: (context, index) {
              final option = timeOptions[index];
              final textLabel = _getTimeLabel(option);
              final isSelected = (dropdownValue == option);

              return ListTile(
                title: Text(
                  textLabel,
                  style: TextStyle(
                    fontFamily: 'Titillium Web',
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    dropdownValue = option;
                    _prepareGraphPoints();
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  /// Return a readable label for each time filter
  String _getTimeLabel(String option) {
    switch (option) {
      case 'last-week':
        return 'Last Week';
      case 'last-month':
        return 'Last Month';
      case 'last-year':
        return 'Last Year';
      case 'year-to-date':
        return 'Year-to-Date';
      case 'last-2-years':
        return 'Last 2 Years';
      default:
        return 'Unknown';
    }
  }

  /// Return initials for a name
  String _getInitials(String name) {
    List<String> names = name.split(' ');
    if (names.length == 1) {
      return names[0];
    }
    String firstName = names.first;
    String lastInitial = names.length > 1 ? '${names.last[0].toUpperCase()}.' : '';
    return '$firstName $lastInitial';
  }

  /// Subtle horizontal grid lines
  FlGridData _buildGridData() => FlGridData(
        show: true,
        drawVerticalLine: false,
<<<<<<< HEAD
<<<<<<< HEAD
        getDrawingHorizontalLine: (value) => const FlLine(
=======
        getDrawingHorizontalLine: (value) => FlLine(
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
        getDrawingHorizontalLine: (value) => const FlLine(
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
          color: Colors.white38, // **Changed** to semi-transparent white
          strokeWidth: 0.5,
        ),
      );

  /// Axis titles: white text
  FlTitlesData get titlesData => FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 55,
            getTitlesWidget: (value, meta) {
              // Hide min & max labels
              if (value == meta.min || value == meta.max) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(
                  abbreviateNumber(value),
                  textAlign: TextAlign.center,
<<<<<<< HEAD
<<<<<<< HEAD
                  style: const TextStyle(color: Color.fromARGB(255, 126, 126, 126)), // White axis label
=======
                  style: const TextStyle(color: Colors.white), // White axis label
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
                  style: const TextStyle(color: Color.fromARGB(255, 126, 126, 126)), // White axis label
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
                ),
              );
            },
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: getBottomTitleInterval(dropdownValue),
            getTitlesWidget: bottomTitlesWidget,
          ),
        ),
      );

  /// Single line bar data with brand color
  LineChartBarData _buildLineChartBarData() => LineChartBarData(
        spots: spots,
        // For a smoother line, set isCurved: true and remove isStepLineChart
        isCurved: false,
        isStepLineChart: true,
        lineChartStepData: const LineChartStepData(stepDirection: 0),
        barWidth: 3,
<<<<<<< HEAD
<<<<<<< HEAD
        color: ARMMBlue, // **Changed** line color to brand color
=======
        color: brandBlue, // **Changed** line color to brand color
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
        color: ARMMBlue, // **Changed** line color to brand color
>>>>>>> c69b9d5 (Enable notification button on AnalyticsPage and update brand color references in LineChartSection for consistency)
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
          getDotPainter: (spot, percent, barData, index) {
            // Hide dots at start/end
            if (spot.x == 0 || spot.x == maxX(dropdownValue)) {
              return FlDotCirclePainter(
                radius: 0,
                color: Colors.transparent,
                strokeWidth: 0,
                strokeColor: Colors.transparent,
              );
            }
            // Show small dots for data points
            if (selectedGraph != null && selectedGraph!.graphPoints.isNotEmpty) {
              return FlDotCirclePainter(
                radius: 4,
<<<<<<< HEAD
<<<<<<< HEAD
                color: ARMMBlue,
=======
                color: brandBlue,
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
                color: ARMMBlue,
>>>>>>> c69b9d5 (Enable notification button on AnalyticsPage and update brand color references in LineChartSection for consistency)
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            } else {
              return FlDotCirclePainter(
                radius: 0,
                color: Colors.transparent,
                strokeWidth: 0,
                strokeColor: Colors.transparent,
              );
            }
          },
        ),
        belowBarData: BarAreaData(
          show: true,
          // **Changed** gradient to brand color -> transparent
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
<<<<<<< HEAD
<<<<<<< HEAD
              ARMMBlue.withOpacity(0.4),
=======
              brandBlue.withOpacity(0.4),
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
              ARMMBlue.withOpacity(0.4),
>>>>>>> c69b9d5 (Enable notification button on AnalyticsPage and update brand color references in LineChartSection for consistency)
              Colors.transparent,
            ],
          ),
        ),
      );

  /// Touch behavior + tooltip
  LineTouchData _buildLineTouchData() => LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 12.0,
          getTooltipItems: (List<LineBarSpot> touchedSpots) =>
              touchedSpots.map((barSpot) {
            if (barSpot.x == 0 || barSpot.x == maxX(dropdownValue)) {
              return null; // Exclude first & last
            }
            final yValue = barSpot.y;
            final xValue = barSpot.x;
            final formattedYValue =
                NumberFormat.currency(symbol: '\$').format(yValue);
            DateTime dateTime = calculateDateTimeFromXValue(xValue, dropdownValue);
            final formattedDate = DateFormat('MMM dd').format(dateTime);

            return LineTooltipItem(
              '$formattedYValue\n$formattedDate',
              const TextStyle(
                color: Colors.white, // White text on dark tooltip
                fontWeight: FontWeight.bold,
                fontFamily: 'Titillium Web',
                fontSize: 16,
              ),
            );
          }).toList(),
        ),
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) =>
                spotIndexes.map((index) {
          final FlSpot spot = barData.spots[index];
          if (spot.x == 0 || spot.x == maxX(dropdownValue)) {
            return null;
          }
          return TouchedSpotIndicatorData(
            // **Changed** indicator color to brand color
<<<<<<< HEAD
<<<<<<< HEAD
            FlLine(color: ARMMBlue, strokeWidth: 2),
=======
            FlLine(color: brandBlue, strokeWidth: 2),
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
            FlLine(color: ARMMBlue, strokeWidth: 2),
>>>>>>> c69b9d5 (Enable notification button on AnalyticsPage and update brand color references in LineChartSection for consistency)
            const FlDotData(show: false),
          );
        }).toList(),
        handleBuiltInTouches: true,
      );

  /// Widget for the bottom axis titles
  Widget bottomTitlesWidget(double value, TitleMeta meta) {
    DateTime dateTime = calculateDateTimeFromXValue(value, dropdownValue);
    String text = '';

    if (dropdownValue == 'last-year') {
      if (value == 0) {
        text = DateFormat('MMM yyyy').format(dateTime);
      } else if (value == maxX(dropdownValue) / 2) {
        text = DateFormat('MMM yyyy').format(
            calculateDateTimeFromXValue(maxX(dropdownValue) / 2, dropdownValue));
      } else if (value == maxX(dropdownValue)) {
        text = DateFormat('MMM yyyy')
            .format(calculateDateTimeFromXValue(maxX(dropdownValue), dropdownValue));
      }
    } else if (dropdownValue == 'year-to-date') {
      if (value == 0) {
        text = DateFormat('MMM dd').format(dateTime);
      } else if (value == maxX(dropdownValue)) {
        text = DateFormat('MMM dd').format(
            calculateDateTimeFromXValue(maxX(dropdownValue), dropdownValue));
      }
    } else if (dropdownValue == 'last-2-years') {
      if (value == 0) {
        text = DateFormat('MMM yyyy').format(dateTime);
      } else if (value == maxX(dropdownValue) / 2) {
        text = DateFormat('MMM yyyy').format(
            calculateDateTimeFromXValue(maxX(dropdownValue) / 2, dropdownValue));
      } else if (value == maxX(dropdownValue)) {
        text = DateFormat('MMM yyyy').format(
            calculateDateTimeFromXValue(maxX(dropdownValue), dropdownValue));
      }
    } else {
      // Default
      text = DateFormat('MMM dd').format(dateTime);
    }

    if (text.isEmpty) return const SizedBox();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 3,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
<<<<<<< HEAD
<<<<<<< HEAD
          color: Color.fromARGB(255, 126, 126, 126)
=======
          color: Colors.white, // White axis label
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
          color: Color.fromARGB(255, 126, 126, 126)
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
        ),
      ),
    );
  }

  /// The date range text below the chart
  Widget _buildDateRangeText() {
    String displayText = '';
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat('MMM. dd, yy');

    switch (dropdownValue) {
      case 'last-week':
        {
          DateTime startOfWeek = now.subtract(Duration(days: now.weekday));
          DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
          displayText =
              '${dateFormat.format(startOfWeek)} - ${dateFormat.format(endOfWeek)}';
        }
        break;
      case 'last-month':
        {
          DateTime startOfLast30Days = now.subtract(const Duration(days: 29));
          DateTime endOfLast30Days = now;
          displayText =
              '${dateFormat.format(startOfLast30Days)} - ${dateFormat.format(endOfLast30Days)}';
        }
        break;
      case 'last-year':
        {
          DateTime startOfLastYear =
              DateTime(now.year - 1, now.month, now.day);
          displayText =
              '${dateFormat.format(startOfLastYear)} - ${dateFormat.format(now)}';
        }
        break;
      case 'year-to-date':
        {
          DateTime startOfThisYear = DateTime(now.year, 1, 1);
          displayText =
              '${dateFormat.format(startOfThisYear)} - ${dateFormat.format(now)}';
        }
        break;
      case 'last-2-years':
        {
          DateTime startOfTwoYearsAgo =
              DateTime(now.year - 2, now.month, now.day);
          displayText =
              '${dateFormat.format(startOfTwoYearsAgo)} - ${dateFormat.format(now)}';
        }
        break;
      default:
        displayText = 'Unknown';
        break;
    }

    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          children: [
            Text(
              displayText,
              style: const TextStyle(
                fontSize: 18,
<<<<<<< HEAD
<<<<<<< HEAD
                color: Color.fromARGB(255, 126, 126, 126),
                fontWeight: FontWeight.bold,
=======
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Titillium Web',
>>>>>>> 545307b (All Analytics Widgets migrated)
=======
                color: Color.fromARGB(255, 126, 126, 126),
                fontWeight: FontWeight.bold,
>>>>>>> 64c0909 (Update background color on AnalyticsPage and adjust gradient colors in CustomAppBar for improved aesthetics)
              ),
            ),
            if (spots.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 25),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(
                      Icons.circle,
                      size: 20,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'No data available for this time period',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Titillium Web',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}