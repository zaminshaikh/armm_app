// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
/// Uses ellipses if the name is still too long after formatting
String formatName(String firstName, String lastName, {int maxLength = 15}) {
  // Handle empty cases
  if (firstName.isEmpty && lastName.isEmpty){
    return '';
  } else if (firstName.isEmpty) {
    return lastName.length <= maxLength ? lastName : '${lastName.substring(0, maxLength - 3)}...';
  } else if (lastName.isEmpty) {
    return firstName.length <= maxLength ? firstName : '${firstName.substring(0, maxLength - 3)}...';
  }
  
  // If both names are short enough, return the full name
  String fullName = '$firstName $lastName';
  if (fullName.length <= maxLength) {
    return fullName;
  }

  String format1 = '$firstName ${lastName[0]}.';
  String format2 = '${firstName[0]}. $lastName';
  
  // Choose the shorter format
  String formatted = format1.length <= format2.length ? format1 : format2;
  
  // If it's still too long, truncate with ellipses
  if (formatted.length > maxLength) {
    formatted = '${formatted.substring(0, maxLength - 3)}...';
  }
  
  return formatted;
}
