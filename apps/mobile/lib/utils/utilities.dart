// ignore_for_file: deprecated_member_use

import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Config {
  static late Map<String, dynamic> _config;

  static Future<void> loadConfig() async {
    String jsonString = await rootBundle.loadString('assets/config.json');
    _config = jsonDecode(jsonString);
  }

  static dynamic get(String key) => _config[key];
}

/// Formats the given amount as a currency string.
String currencyFormat(double amount) => NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
    locale: 'en_US',
  ).format(amount);

bool isSameDay(DateTime date1, DateTime date2) =>
    date1.year == date2.year &&
    date1.month == date2.month &&
    date1.day == date2.day;
    
String toTitleCase(String input) {
  if (input.isEmpty) return input;
  return input.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

/// Formats a name to a shortened version if either first or last name is too long
/// Returns full name if both names are short enough
/// Otherwise returns first name + last initial or first initial + last name
String formatName(String firstName, String lastName, {int maxLength = 15}) {
  // Handle empty cases
  if (firstName.isEmpty && lastName.isEmpty) return '';
  if (firstName.isEmpty) return lastName;
  if (lastName.isEmpty) return firstName;
  
  // If both names are short enough, return the full name
  if (firstName.length <= 6 && lastName.length <= 6) {
    return '$firstName $lastName';
  }
  
  // Regular format: First name + Last initial (e.g., "John D.")
  String formatted = '$firstName ${lastName[0]}.';
  
  // If the formatted name is still too long, use first initial + last name
  if (formatted.length > maxLength && lastName.length < firstName.length) {
    formatted = '${firstName[0]}. $lastName';
  }
  
  // If it's still too long, truncate
  if (formatted.length > maxLength) {
    formatted = formatted.substring(0, maxLength - 3) + '...';
  }
  
  return formatted;
}
