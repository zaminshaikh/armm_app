
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

    return ListTile(
      title: Text(
        asset.displayTitle,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontFamily: 'Titillium Web',
        ),
      ),
      trailing: Text(
        currencyFormat(asset.amount),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          fontFamily: 'Titillium Web',
        ),
      ),
    );
  }
}