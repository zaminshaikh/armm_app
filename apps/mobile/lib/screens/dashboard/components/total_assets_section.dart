import 'package:armm_app/database/models/client_model.dart';
<<<<<<< HEAD
import 'package:armm_app/screens/dashboard/components/ytd.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TotalAssetsSection extends StatelessWidget {
=======
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TotalAssetsSection extends StatelessWidget {

>>>>>>> 7b97856 (Migrated components for dashboard)
  final Client client;

  const TotalAssetsSection({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalAssets = client.assets?.totalAssets ?? 0;

<<<<<<< HEAD
=======
    // Check if connectedUsers is not null before iterating
>>>>>>> 7b97856 (Migrated components for dashboard)
    if (client.connectedUsers != null) {
      for (var user in client.connectedUsers!) {
        totalAssets += user?.assets?.totalAssets ?? 0;
      }
    }
<<<<<<< HEAD

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
                    'Latest Return (YTD)',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 94, 94, 94),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ProfitIndicator(amount: client.assets?.totalYTD ?? 0),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
=======
    return Stack(
        children: [
          Container(
            width: double.infinity,
            height: 160,
            padding: const EdgeInsets.only(left: 12, top: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3199DD),
                  Color.fromARGB(255, 13, 94, 175),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Total Assets',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Titillium Web',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currencyFormat(totalAssets),
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Titillium Web',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          currencyFormat(client.assets?.totalYTD ?? 0),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Titillium Web',
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: const Icon(Icons.info_outline_rounded,
                  color: Color.fromARGB(71, 255, 255, 255)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 30, 75, 137),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: <Widget>[
                                Text('What is',
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                const SizedBox(width: 5),
                                Text('?',
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                              ],
                            ),
                          ),
                          const Text(
                              'YTD stands for Year-To-Date. It is a financial term that describes the amount of income accumulated over the period of time from the beginning of the current year to the present date.'),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: <Widget>[
                                Text('What are my total assets?',
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                              ],
                            ),
                          ),
                          const Text(
                              'Total assets are the sum of all assets in your account, including the assets of your connected users. This includes all IRAs, Nuview Cash, and assets in both AGQ and AK1.'),
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
                            color: const Color.fromARGB(255, 30, 75, 137),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Continue',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
>>>>>>> 7b97856 (Migrated components for dashboard)
}