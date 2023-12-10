// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:zaanth/enum/account_type.dart';

class InstructorModel {
  String uid;
  String phoneNumber;
  bool isPhoneNumberVerified;
  String qualification;
  int feesPerMonth;
  double ratings;
  List<String> subjects;
  Map<String, Map<String, Map<String, String>>> selectedTimingsForSubjects;
  AccountTypeEnum? accountType; // Make the accountType field nullable
  Timestamp createdOn;
  Map<String, List<String>> selectedDaysForSubjects;
  List<Map<String, String>> enrollments;
  String address;
  String name;
  String profilePicUrl;
  String city;
  String gender;
  DateTime? dob;
  List<String> selectedGradesLevel;


  InstructorModel({
    required this.uid,
    required this.phoneNumber,
    required this.isPhoneNumberVerified,
    required this.qualification,
    required this.feesPerMonth,
    required this.ratings,
    required this.subjects,
    required this.selectedTimingsForSubjects,
    this.accountType,
    required this.createdOn,
    required this.selectedDaysForSubjects,
    required this.enrollments,
    required this.address,
    required this.city,
    required this.name,
    required this.profilePicUrl,
    required this.gender,
    required this.dob,
    required this.selectedGradesLevel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'phoneNumber': phoneNumber,
      'isPhoneNumberVerified': isPhoneNumberVerified,
      'qualification': qualification,

      'feesPerMonth': feesPerMonth,

      'ratings': ratings,
      'subjects': subjects,
      'selectedTimingsForSubjects': selectedTimingsForSubjects,
      'accountType': accountType
          ?.toString()
          .split('.')
          .last, // Store the enum value as a string
      'createdOn': createdOn,
      'selectedDaysForSubjects': selectedDaysForSubjects,
      'enrollments': enrollments,
      'address': address,
      'name': name,
      'city': city,
      'profilePicUrl': profilePicUrl,
      'gender': gender,
      'dob': dob!.toIso8601String(),
      'selectedGradesLevel': selectedGradesLevel,
    };
  }

  factory InstructorModel.fromMap(Map<String, dynamic> map) {
    return InstructorModel(
      uid: map['uid'] as String,
      phoneNumber: map['phoneNumber'] as String,
      isPhoneNumberVerified: map['isPhoneNumberVerified'] as bool,
      qualification: map['qualification'] as String,
      feesPerMonth: map['feesPerMonth'] as int,

      ratings: map['ratings'] as double,
      subjects: List<String>.from(map['subjects'] as List<dynamic>),

      selectedTimingsForSubjects:
          (map['selectedTimingsForSubjects'] as Map<String, dynamic>?)?.map(
                (subject, subjectData) {
                  return MapEntry(
                    subject,
                    (subjectData is Map<String,
                            dynamic>) // Check the type before casting
                        ? subjectData.map(
                            (day, dayData) {
                              return MapEntry(
                                day,
                                (dayData is Map<String,
                                        dynamic>) // Check the type before casting
                                    ? Map<String, String>.from(dayData)
                                    : <String,
                                        String>{}, // Handle the case where it's not a map
                              );
                            },
                          )
                        : <String,
                            Map<String,
                                String>>{}, // Handle the case where it's not a map
                  );
                },
              ) ??
              {},
      accountType: map['accountType'] != null
          ? AccountTypeEnum.values.firstWhere(
              (e) => e.toString() == map['accountType'],
              orElse: () =>
                  AccountTypeEnum.unknown, // Use 'unknown' as the default
            )
          : AccountTypeEnum.unknown, // Use 'unknown' as the default
      createdOn: map['createdOn'] as Timestamp,
      selectedDaysForSubjects:
          (map['selectedDaysForSubjects'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as List<dynamic>).cast<String>()),
      ),

      enrollments: (map['enrollments'] as List<dynamic>).map((enrollmentData) {
        final Map<String, dynamic> enrollmentMap =
            enrollmentData as Map<String, dynamic>;
        return {
          for (final entry in enrollmentMap.entries)
            entry.key: entry.value.toString(),
        };
      }).toList(),
      address: map['address'] as String,
      name: map['name'] as String,
      city: map['city'] as String,
      profilePicUrl: map['profilePicUrl'] as String,
      gender: map['gender'] as String,
      dob:  DateTime.parse(map['dob'] as String),
      selectedGradesLevel: List<String>.from(map['selectedGradesLevel'] as List<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory InstructorModel.fromJson(String source) =>
      InstructorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
