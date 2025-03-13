import 'package:armm_app/database/models/assets_model.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/dashboard/components/asset_tile.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class UserBreakdownSection extends StatelessWidget {
  final Client client;
  final bool isConnectedUser;

  static const Color armmBlue = Color(0xFF2B41B8);

  const UserBreakdownSection({
    Key? key,
    required this.client,
    this.isConnectedUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate asset list
    List<AssetTile> assetTilesARMM = [];
    for (var fundEntry in client.assets!.funds.entries) {
      Fund fund = fundEntry.value;
      for (var entry in fund.assets.entries) {
        final asset = entry.value;
        assetTilesARMM.add(
          AssetTile(
            asset: asset,
            companyName: client.companyName,
          ),
        );
      }
    }

    // Sort assets by index
    assetTilesARMM.sort((a, b) => a.asset.index.compareTo(b.asset.index));

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, 
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: 10),
          initiallyExpanded: true, // Keeps it open like in the image
          title: Row(
            children: [
              // Profile icon
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color.fromARGB(255, 205, 212, 247),
                child: SvgPicture.asset(
                  'assets/icons/profile_hollow.svg',
                  color: armmBlue,
                  height: 18,
                ),
              ),
              const SizedBox(width: 10),
        
              // Name and total YTD earnings
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${client.firstName} ${client.lastName}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
        
                  // Profit Indicator
                  Row(
                    children: [
                      const Icon(
                        Icons.trending_up,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        currencyFormat(client.assets?.ytd ?? 0),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
        
              // Total Assets in Blue
              Text(
                currencyFormat(client.assets?.totalAssets ?? 0),
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: armmBlue,
                ),
              ),
            ],
          ),
        
          // Expanded asset breakdown list
          children: [
        
            // Asset Breakdown List
            Column(
              children: assetTilesARMM,
            ),
          ],
        ),
      ),
    );
  }
}