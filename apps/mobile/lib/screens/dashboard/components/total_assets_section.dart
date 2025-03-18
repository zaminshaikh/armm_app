import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/analytics/components/line_chart.dart';
import 'package:armm_app/screens/dashboard/components/ytd.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TotalAssetsSection extends StatelessWidget {
  final Client client;

  const TotalAssetsSection({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalAssets = client.assets?.totalAssets ?? 0;

    if (client.connectedUsers != null) {
      for (var user in client.connectedUsers!) {
        totalAssets += user?.assets?.totalAssets ?? 0;
      }
    }

    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              // Left Column for Total Assets
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Total Assets',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 94, 94, 94),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat(totalAssets),
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Right Column for YTD (Latest Return)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Latest Return',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 94, 94, 94),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: const Icon(Icons.info_outline_rounded,
                            color: Color.fromARGB(255, 0, 0, 0)
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              backgroundColor: Colors.white,
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'What is YTD?',
                                            style: GoogleFonts.inter(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                        'YTD stands for Year-To-Date. It is a financial term that describes the amount of income accumulated over the period of time from the beginning of the current year to the present date.',
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                        ),
                                      ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'What are my total assets?',
                                            style: GoogleFonts.inter(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                        'Total assets are the sum of all assets in your account, including the assets of your connected users. This includes all IRAs, Nuview Cash, and assets in ARMM.',
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: ARMMBlue,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Continue',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      ProfitIndicator(amount: client.assets?.totalYTD ?? 0),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}