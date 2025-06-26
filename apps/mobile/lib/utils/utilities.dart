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
  // Trim whitespace
  firstName = firstName.trim();
  lastName = lastName.trim();

  // Case: Both names empty
  if (firstName.isEmpty && lastName.isEmpty) return '';

  // Case: Full name is in firstName and lastName is empty
  if (lastName.isEmpty && firstName.contains(' ')) {
    final parts = firstName.split(RegExp(r'\s+'));
    firstName = parts.first;
    lastName = parts.length > 1 ? parts.last : '';
  }

  // Case: lastName is still empty
  if (lastName.isEmpty) return firstName.length > maxLength
      ? '${firstName.substring(0, maxLength - 3)}...'
      : firstName;

  // Case: firstName is empty
  if (firstName.isEmpty) return lastName.length > maxLength
      ? '${lastName.substring(0, maxLength - 3)}...'
      : lastName;

  // Format: First + Last
  String full = '$firstName $lastName';
  if (full.length <= maxLength) return full;

  // Try: First + Last initial
  String short1 = '$firstName ${lastName[0]}.';
  if (short1.length <= maxLength) return short1;

  // Try: First initial + Last
  String short2 = '${firstName[0]}. $lastName';
  if (short2.length <= maxLength) return short2;

  // Truncate fallback
  return '${firstName.substring(0, maxLength - 3)}...';
}
