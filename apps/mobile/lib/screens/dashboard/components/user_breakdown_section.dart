import 'package:armm_app/database/models/assets_model.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/dashboard/components/asset_tile.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

// Enum for font size types
enum FontSizeType { ytd, total }

class UserBreakdownSection extends StatelessWidget {
  final Client client;
  final bool isConnectedUser;

  static const Color armmBlue = Color(0xFF2B41B8);

  const UserBreakdownSection({
    Key? key,
    required this.client,
    this.isConnectedUser = false,
  }) : super(key: key);

  // Helper function to determine font size based on value
  double _getFontSize(double value, FontSizeType type) {
    // Base sizes for different elements
    double baseYtdSize = 12.0;
    double baseTotalSize = 16.0;
    
    // Scale factor based on value magnitude (logarithmic scale)
    double scaleFactor = 0;
    if (value >= 1000000) { // > 1M
      scaleFactor = 1.5;
    } else if (value >= 100000) { // > 100k
      scaleFactor = 1.2;
    } else if (value >= 10000) { // > 10k
      scaleFactor = 1.0;
    } else if (value >= 1000) { // > 1k
      scaleFactor = 0.8;
    }
    
    // Apply scale factor based on type
    switch (type) {
      case FontSizeType.ytd:
        return baseYtdSize + (scaleFactor * 0.1); // Smaller scaling for YTD
      case FontSizeType.total:
        return baseTotalSize + (scaleFactor * 0.2); // Larger scaling for total
      default:
        return type == FontSizeType.ytd ? baseYtdSize : baseTotalSize; // Default case
    }
  }

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
      padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(0, 0, 0, 0).withOpacity(0.1),
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
                    formatName(client.firstName, client.lastName),
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
                          fontSize: _getFontSize(client.assets?.ytd?.abs() ?? 0, FontSizeType.ytd),
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
                  fontSize: _getFontSize(client.assets?.totalAssets ?? 0, FontSizeType.total),
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

