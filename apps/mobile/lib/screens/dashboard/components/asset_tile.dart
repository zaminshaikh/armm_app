
import 'dart:developer';

import 'package:armm_app/database/models/assets_model.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


// ignore: must_be_immutable
class AssetTile extends StatelessWidget {

  final Asset asset;
  final String? companyName;

  AssetTile({super.key, required this.asset, this.companyName,});

  @override
  Widget build(BuildContext context) {

    // String sectionName = getSectionName(fieldName, companyName: companyName);
    // title = sectionName;
<<<<<<< HEAD

    return ListTile(
=======
    Widget fundIcon = getFundIcon();

    return ListTile(
      leading: fundIcon,
>>>>>>> 7b97856 (Migrated components for dashboard)
      title: Text(
        asset.displayTitle,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
<<<<<<< HEAD
          color: Colors.black,
=======
          color: Colors.white,
>>>>>>> 7b97856 (Migrated components for dashboard)
          fontFamily: 'Titillium Web',
        ),
      ),
      trailing: Text(
        currencyFormat(asset.amount),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
<<<<<<< HEAD
          color: Colors.black,
=======
          color: Colors.white,
>>>>>>> 7b97856 (Migrated components for dashboard)
          fontFamily: 'Titillium Web',
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  Widget getFundIcon() {
    return const Icon(Icons.account_balance, color: Colors.white);
  }

>>>>>>> 7b97856 (Migrated components for dashboard)
}