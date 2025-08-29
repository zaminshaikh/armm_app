/// Application Configuration Service
/// 
/// Manages loading and accessing configuration settings for the app.

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/services.dart';

class Config {
  static late Map<String, dynamic> _config;

  static Future<void> loadConfig() async {
    String jsonString = await rootBundle.loadString('assets/config.json');
    _config = jsonDecode(jsonString);
  }

  static dynamic get(String key) => _config[key];
}
