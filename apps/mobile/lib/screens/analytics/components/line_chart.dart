import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/database/models/graph_model.dart';
import 'package:armm_app/database/models/graph_point_model.dart';
import 'package:armm_app/screens/analytics/utils/analytics_utilities.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Example ARMM blue (adjust to match brand)
const Color ARMMBlue = Color(0xFF1C32A4);
/// A light grey color for the dropdown "pills"
const Color pillColor = Color(0xFFE9EDF8);

class LineChartSection extends StatefulWidget {
  final Client client;
  const LineChartSection({super.key, required this.client});

  @override
  LineChartSectionState createState() => LineChartSectionState();
}

class LineChartSectionState extends State<LineChartSection> {
  // Variables for the line chart data
  List<FlSpot> spots = [];
  double _minAmount = double.maxFinite;
  double _maxAmount = 0.0;
  String dropdownValue = 'last-week'; // default: 'last-week'

  // Variables for account selection
  String? selectedAccount;
  Graph? selectedGraph;

  // Variables for client selection
  late final List<Client> allClients;
  Client? selectedClient;

  @override
  void initState() {
    super.initState();
    allClients = [
      widget.client,
      ...(widget.client.connectedUsers?.whereType<Client>() ?? [])
    ];
    selectedClient = allClients.isNotEmpty ? allClients.first : null;
    if (selectedClient != null && (selectedClient!.graphs?.isNotEmpty ?? false)) {
      selectedGraph = selectedClient!.graphs!.firstWhere(
        (g) => g.account.toLowerCase() == 'cumulative',
        orElse: () => selectedClient!.graphs!.first,
      );
      selectedAccount = selectedGraph?.account;
    }
    _prepareGraphPoints();
  }

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

      // Sort by x
      spots.sort((a, b) => a.x.compareTo(b.x));

      // Insert a starting spot at x=0 if needed
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

      // Insert an ending spot if needed
      double maxXValue = maxX(dropdownValue);
      if (spots.isNotEmpty && spots.last.x < maxXValue) {
        FlSpot lastSpot = spots.last;
        spots.add(FlSpot(maxXValue, lastSpot.y));
      } else if (spots.isEmpty) {
        // No data points at all
        GraphPoint mostRecentSpot = selectedGraph!.graphPoints.last;
        spots.add(FlSpot(0, mostRecentSpot.amount));
        spots.add(FlSpot(maxXValue, mostRecentSpot.amount));
        _maxAmount = (mostRecentSpot.amount) * 1.5;
      }
    } else {
      // No data
      localMinAmount = 0.0;
      localMaxAmount = 100000.0;
      spots.add(const FlSpot(0, 0));
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
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy \'at\' hh:mm a');
    String dateString = '';
    double amount = 0.0;

    if (selectedGraph != null && selectedGraph!.graphPoints.isNotEmpty) {
      final lastPoint = selectedGraph!.graphPoints.last;
      dateString = dateFormat.format(lastPoint.time);
      amount = lastPoint.amount;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: Container(
        // The white card container
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Title: "Asset Timeline" at the top center
            Text(
              'Asset Timeline',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
    
            // The row of dropdowns (e.g., "Personal", "Last Week")
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Account selection or "Personal" button
                Expanded(
                  child: _buildPersonalDropdown(context),
                ),
                const SizedBox(width: 8),
                // Time filter e.g. "Last Week"
                Expanded(
                  child: _buildTimeFilterPill(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
    
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left side: 'Assets' label and date/time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assets',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        dateString.isEmpty ? '--' : dateString, // e.g. "01.01.2024 at 3:15 PM"
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  // Right side: amount
                  Text(
                    amount == 0.0
                        ? '\$0.00'
                        : NumberFormat.currency(symbol: '\$').format(amount),
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ARMMBlue,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
    
            // The chart
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
                  padding: const EdgeInsets.only(top: 8.0),
                  child: LineChart(
                    LineChartData(
                      gridData: _buildGridData(),
                      titlesData: titlesData,
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: maxX(dropdownValue),
                      minY: calculateDynamicMin(_minAmount),
                      maxY: calculateDynamicMax(_maxAmount),
                      lineBarsData: [_buildLineChartBarData()],
                      lineTouchData: _buildLineTouchData(),
                    ),
                  ),
                ),
              ),
            ),
    
    
            const SizedBox(height: 12),
            _buildDateRangeText(), 
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalDropdown(BuildContext context) {
    // If no clients, show "Personal" by default
    if (allClients.isEmpty) {
      return _pillContainer(child: Text('Personal', style: _pillTextStyle()));
    }

    // Currently selected client
    final name =
        '${selectedClient?.firstName ?? ''} ${selectedClient?.lastName ?? ''}'
            .trim();
    final displayName = name.isEmpty ? 'Personal' : name;

    return GestureDetector(
      onTap: () => _showClientsBottomSheet(context),
      child: _pillContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(
          displayName,
          style: _pillTextStyle(),
        ),
        const SizedBox(width: 10), // space between text and icon
          const RotatedBox(
            quarterTurns: 3,
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Color.fromARGB(255, 102, 102, 102),
              size: 22,
            ),
          )
        ],
      ),
      ),
    );
  }

  /// A helper to build the pill background & spacing
  Widget _pillContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: pillColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(255, 151, 151, 151)),
      ),
      child: child,
    );
  }

  TextStyle _pillTextStyle() => GoogleFonts.inter(
        fontSize: 17,
        color: const Color.fromARGB(160, 0, 0, 0),
        fontWeight: FontWeight.w600,
      );

  /// Shows a bottom sheet with the list of available clients
  void _showClientsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      context: context,
      builder: (ctx) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: allClients.length,
            itemBuilder: (context, index) {
              final client = allClients[index];
              final fullName = '${client.firstName} ${client.lastName}'.trim();
              final isSelected = (client == selectedClient);
              return ListTile(
                title: Text(
                  fullName.isEmpty ? 'Personal' : fullName,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedClient = client;
                    // Invalidate graphs, etc.
                    if (selectedClient != null &&
                        (selectedClient!.graphs?.isNotEmpty ?? false)) {
                      selectedGraph = selectedClient!.graphs!.first;
                      selectedAccount = selectedGraph?.account;
                      _prepareGraphPoints();
                    }
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTimeFilterPill(BuildContext context) {
    final selectedText = _getTimeLabel(dropdownValue);

    return InkWell(
      onTap: () => _showTimeOptionsBottomSheet(context),
      child: _pillContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(selectedText, style: _pillTextStyle()),
        const SizedBox(width: 10),
        const RotatedBox(
          quarterTurns: 3,
          child: Icon(
          Icons.arrow_back_ios_rounded,
          color: Color.fromARGB(255, 102, 102, 102),
          size: 22,
          ),
        )
        ],
      ),
      ),
    );
  }

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
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      context: context,
      builder: (ctx) => Container(
        height: 320,
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: timeOptions.length,
          itemBuilder: (context, index) {
            final option = timeOptions[index];
            final textLabel = _getTimeLabel(option);
            final isSelected = (dropdownValue == option);
            return ListTile(
              title: Text(
                textLabel,
                style: GoogleFonts.inter(
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
    );
  }

  FlGridData _buildGridData() => FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.shade300,
          strokeWidth: 0.6,
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              if (value == meta.min || value == meta.max) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  abbreviateNumber(value),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              );
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: getBottomTitleInterval(dropdownValue),
            getTitlesWidget: bottomTitlesWidget,
          ),
        ),
      );

  LineChartBarData _buildLineChartBarData() => LineChartBarData(
        spots: spots,
        isCurved: false,
        isStepLineChart: true,
        lineChartStepData: const LineChartStepData(stepDirection: 0),
        barWidth: 3,
        color: ARMMBlue,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
          getDotPainter: (spot, percent, barData, index) {
            // Hide dots for the first and last “padding” points
            if (spot.x == 0 || spot.x == maxX(dropdownValue)) {
              return FlDotCirclePainter(
                radius: 0,
                color: Colors.transparent,
                strokeWidth: 0,
              );
            }
            // Show dots for real data
            if (selectedGraph != null && selectedGraph!.graphPoints.isNotEmpty) {
              return FlDotCirclePainter(
                radius: 4,
                color: ARMMBlue,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            } else {
              return FlDotCirclePainter(
                radius: 0,
                color: Colors.transparent,
                strokeWidth: 0,
              );
            }
          },
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ARMMBlue.withOpacity(0.2),
              ARMMBlue.withOpacity(0.05),
            ],
          ),
        ),
      );

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
            FlLine(color: ARMMBlue, strokeWidth: 2),
            const FlDotData(show: false),
          );
        }).toList(),
        handleBuiltInTouches: true,
      );

  // The x-axis label widget
  Widget bottomTitlesWidget(double value, TitleMeta meta) {
    DateTime dateTime = calculateDateTimeFromXValue(value, dropdownValue);
    String text = '';
    if (dropdownValue == 'last-year') {
      if (value == 0) {
        text = DateFormat('MMM yyyy').format(dateTime);
      } else if (value == maxX(dropdownValue) / 2) {
        text = DateFormat('MMM yyyy').format(
          calculateDateTimeFromXValue(maxX(dropdownValue) / 2, dropdownValue),
        );
      } else if (value == maxX(dropdownValue)) {
        text = DateFormat('MMM yyyy')
            .format(calculateDateTimeFromXValue(maxX(dropdownValue), dropdownValue));
      }
    } else if (dropdownValue == 'year-to-date') {
      if (value == 0) {
        text = DateFormat('MMM dd').format(dateTime);
      } else if (value == maxX(dropdownValue)) {
        text = DateFormat('MMM dd').format(
          calculateDateTimeFromXValue(maxX(dropdownValue), dropdownValue),
        );
      }
    } else if (dropdownValue == 'last-2-years') {
      if (value == 0) {
        text = DateFormat('MMM yyyy').format(dateTime);
      } else if (value == maxX(dropdownValue) / 2) {
        text = DateFormat('MMM yyyy').format(
          calculateDateTimeFromXValue(maxX(dropdownValue) / 2, dropdownValue),
        );
      } else if (value == maxX(dropdownValue)) {
        text = DateFormat('MMM yyyy').format(
          calculateDateTimeFromXValue(maxX(dropdownValue), dropdownValue),
        );
      }
    } else {
      // last-week, last-month, default
      text = DateFormat('MMM dd').format(dateTime);
    }

    if (text.isEmpty) return const SizedBox();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 3,
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Returns a friendlier label for the time filter
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

  Widget _buildDateRangeText() {
    final displayText = _calculateRangeLabel(dropdownValue);
    if (spots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'No data available for this time period',
          style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
        ),
      );
    }
    return Text(
      displayText,
      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: const Color.fromARGB(147, 0, 0, 0)),
    );
  }

  String _calculateRangeLabel(String option) {
    final now = DateTime.now();
    final dateFormat = DateFormat('MMM dd, yyyy');
    switch (option) {
      case 'last-week':
        final startOfWeek = now.subtract(Duration(days: now.weekday));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return '${dateFormat.format(startOfWeek)} - ${dateFormat.format(endOfWeek)}';
      case 'last-month':
        final startOfLast30Days = now.subtract(const Duration(days: 29));
        return '${dateFormat.format(startOfLast30Days)} - ${dateFormat.format(now)}';
      case 'last-year':
        final startOfLastYear = DateTime(now.year - 1, now.month, now.day);
        return '${dateFormat.format(startOfLastYear)} - ${dateFormat.format(now)}';
      case 'year-to-date':
        final startOfThisYear = DateTime(now.year, 1, 1);
        return '${dateFormat.format(startOfThisYear)} - ${dateFormat.format(now)}';
      case 'last-2-years':
        final startOfTwoYearsAgo = DateTime(now.year - 2, now.month, now.day);
        return '${dateFormat.format(startOfTwoYearsAgo)} - ${dateFormat.format(now)}';
      default:
        return 'Unknown range';
    }
  }
}