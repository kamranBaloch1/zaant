import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zant/enum/account_type.dart';

class InstructorModel {
  String uid;
  int phoneNumber;
  bool isPhoneNumberVerified;
  String qualification;
  String location;
  int feesPerHour;
  List<String> reviews;
  int ratings;
  List<String> subjects;
  Map<String, Map<String, String>> availableTimings; // Change the type to a Map
  AccountTypeEnum? accountType; // Make the accountType field nullable
  Timestamp createdOn;

  InstructorModel({
    required this.uid,
    required this.phoneNumber,
    required this.isPhoneNumberVerified,
    required this.qualification,
    required this.location,
    required this.feesPerHour,
    required this.reviews,
    required this.ratings,
    required this.subjects,
    required this.availableTimings, // Update the field type
    this.accountType, // Allow the accountType parameter to be nullable
    required this.createdOn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'phoneNumber': phoneNumber,
      'isPhoneNumberVerified': isPhoneNumberVerified,
      'qualification': qualification,
      'location': location,
      'feesPerHour': feesPerHour,
      'reviews': reviews,
      'ratings': ratings,
      'subjects': subjects,
      'availableTimings': availableTimings, // Store the updated field
      'accountType': accountType?.toString().split('.').last, // Store the enum value as a string
      'createdOn': createdOn,
    };
  }

  factory InstructorModel.fromMap(Map<String, dynamic> map) {
    return InstructorModel(
      uid: map['uid'] as String,
      phoneNumber: map['phoneNumber'] as int,
      isPhoneNumberVerified: map['isPhoneNumberVerified'] as bool,
      qualification: map['qualification'] as String,
      location: map['location'] as String,
      feesPerHour: map['feesPerHour'] as int,
      reviews: List<String>.from(map['reviews'] as List<dynamic>),
      ratings: map['ratings'] as int,
      subjects: List<String>.from(map['subjects'] as List<dynamic>),
      availableTimings: Map<String, Map<String, String>>.from(
        map['availableTimings'] as Map<String, dynamic>,
      ), // Parse the updated field
      accountType: map['accountType'] != null
          ? AccountTypeEnum.values.firstWhere(
              (e) => e.toString() == map['accountType'],
              orElse: () => AccountTypeEnum.unknown, // Use 'unknown' as the default
            )
          : AccountTypeEnum.unknown, // Use 'unknown' as the default
      createdOn: map['createdOn'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory InstructorModel.fromJson(String source) =>
      InstructorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
