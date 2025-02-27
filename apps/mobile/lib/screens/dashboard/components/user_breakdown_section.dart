import 'package:armm_app/database/models/assets_model.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/dashboard/components/asset_tile.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class UserBreakdownSection extends StatelessWidget {
  final Client client;
  bool isConnectedUser;
  
  UserBreakdownSection({Key? key, required this.client, this.isConnectedUser = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a single list for the ARMM assets
    List<AssetTile> assetTilesARMM = [];
    
    for (var fundEntry in client.assets!.funds.entries) {
      // For this project, we assume all funds are "ARMM"
      Fund fund = fundEntry.value;
      for (var entry in fund.assets.entries) {
        final key = entry.key;
        final asset = entry.value;
        // NOTE: Uncomment the following line if you want to filter out assets with amount 0
        // if (asset.amount != 0) {
          assetTilesARMM.add(
            AssetTile(
              asset: asset,
              companyName: client.companyName,
            ),
          );
        // }
      }
    }
    
    // Sort tiles in order specified by asset index
    assetTilesARMM.sort((a, b) => a.asset.index.compareTo(b.asset.index));

    // Helper function to get the display name
    String getDisplayName(String firstName, String lastName) {
      final fullName = '$firstName $lastName';
      if (fullName.length > 20) {
        if (firstName.length <= lastName.length) {
          return '$firstName ${lastName.substring(0, 1)}.';
        } else {
          return '${firstName.substring(0, 1)}. $lastName';
        }
      } else {
        return fullName;
      }
    }
    
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent, // removes splash effect
      ),
      child: Container(
        color: const Color.fromARGB(255, 17, 24, 39),
        child: ExpansionTile(
          title: Row(
            children: [
              Text(
                getDisplayName(client.firstName, client.lastName),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Titillium Web',
                ),
              ),
              const SizedBox(width: 10),
              const SizedBox(width: 5),
              Text(
                currencyFormat(client.assets?.ytd ?? 0),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Titillium Web',
                ),
              ),
            ],
          ),
          subtitle: Text(
            currencyFormat(client.assets?.totalAssets ?? 0),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontFamily: 'Titillium Web',
            ),
          ),
          maintainState: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: isConnectedUser
                ? const BorderSide(color: Colors.white)
                : BorderSide.none,
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: isConnectedUser
                ? const BorderSide(color: Colors.white)
                : BorderSide.none,
          ),
          collapsedBackgroundColor: isConnectedUser ? Colors.transparent : const Color.fromARGB(255, 30, 41, 59),
          backgroundColor: isConnectedUser ? Colors.transparent : const Color.fromARGB(255, 30, 41, 59),
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25.0, bottom: 10.0, top: 10.0),
              child: Divider(color: Colors.grey[300]),
            ),
            Column(
              children: assetTilesARMM,
            ),
          ],
        ),
      ),
    );
  }
}