import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  bool selected;
  String address;
  String appEmail;
  List<String> beneficiaries;
  String city;
  String companyName;
  List<String> connectedUsers;
  String country;
  Timestamp? dob;
  Timestamp? firstDepositDate;
  String firstName;
  String initEmail;
  String lastLoggedIn;
  String lastName;
  String notes;
  String phoneNumber;
  String province;
  String state;
  String street;
  String uid;
  String zip;

  Client({
    this.selected = false,
    this.address = "",
    this.appEmail = "",
    this.beneficiaries = const [],
    this.city = "",
    this.companyName = "",
    this.connectedUsers = const [],
    this.country = "US",
    this.dob,
    this.firstDepositDate,
    this.firstName = "",
    this.initEmail = "",
    this.lastLoggedIn = "N/A",
    this.lastName = "",
    this.notes = "",
    this.phoneNumber = "",
    this.province = "",
    this.state = "",
    this.street = "",
    this.uid = "",
    this.zip = "",
  });

  /// Factory method to create a Client instance from Firestore data
  factory Client.fromMap(Map<String, dynamic> data, String documentId) {
    return Client(
      selected: data['_selected'] ?? false,
      address: data['address'] ?? "",
      appEmail: data['appEmail'] ?? "",
      beneficiaries: List<String>.from(data['beneficiaries'] ?? []),
      city: data['city'] ?? "",
      companyName: data['companyName'] ?? "",
      connectedUsers: List<String>.from(data['connectedUsers'] ?? []),
      country: data['country'] ?? "US",
      dob: data['dob'],
      firstDepositDate: data['firstDepositDate'],
      firstName: data['firstName'] ?? "",
      initEmail: data['initEmail'] ?? "",
      lastLoggedIn: data['lastLoggedIn'] ?? "N/A",
      lastName: data['lastName'] ?? "",
      notes: data['notes'] ?? "",
      phoneNumber: data['phoneNumber'] ?? "",
      province: data['province'] ?? "",
      state: data['state'] ?? "",
      street: data['street'] ?? "",
      uid: data['uid'] ?? documentId, // Use document ID if not provided
      zip: data['zip'] ?? "",
    );
  }

  /// Converts the Client instance into a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      '_selected': selected,
      'address': address,
      'appEmail': appEmail,
      'beneficiaries': beneficiaries,
      'city': city,
      'companyName': companyName,
      'connectedUsers': connectedUsers,
      'country': country,
      'dob': dob,
      'firstDepositDate': firstDepositDate,
      'firstName': firstName,
      'initEmail': initEmail,
      'lastLoggedIn': lastLoggedIn,
      'lastName': lastName,
      'notes': notes,
      'phoneNumber': phoneNumber,
      'province': province,
      'state': state,
      'street': street,
      'uid': uid,
      'zip': zip,
    };
  }
}

