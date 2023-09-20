// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:zant/enum/account_type.dart';

class InstructorModel {
  String uid;
  String phoneNumber;
  bool isPhoneNumberVerified;
  String qualification;
  int feesPerHour;
  List<String> reviews;
  int ratings;
  List<String> subjects;
  Map<String, Map<String, Map<String, String>>> selectedTimingsForSubjects;
  AccountTypeEnum? accountType; // Make the accountType field nullable
  Timestamp createdOn;
  Map<String, List<String>> selectedDaysForSubjects;
  List<Map<String, String>> enrollments;
  String location;
  String name;
  String profilePicUrl;
  String city;
  String gender;

  InstructorModel(
      {required this.uid,
      required this.phoneNumber,
      required this.isPhoneNumberVerified,
      required this.qualification,
      required this.feesPerHour,
      required this.reviews,
      required this.ratings,
      required this.subjects,
      required this.selectedTimingsForSubjects,
      this.accountType,
      required this.createdOn,
      required this.selectedDaysForSubjects,
      required this.enrollments,
      required this.location,
      required this.city,
      required this.name,
      required this.profilePicUrl,
      required this.gender,
      });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'phoneNumber': phoneNumber,
      'isPhoneNumberVerified': isPhoneNumberVerified,
      'qualification': qualification,

      'feesPerHour': feesPerHour,
      'reviews': reviews,
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
      'location': location,
      'name': name,
      'city': city,
      'profilePicUrl': profilePicUrl,
      'gender': gender,
    };
  }

  factory InstructorModel.fromMap(Map<String, dynamic> map) {
    return InstructorModel(
      uid: map['uid'] as String,
      phoneNumber: map['phoneNumber'] as String,
      isPhoneNumberVerified: map['isPhoneNumberVerified'] as bool,
      qualification: map['qualification'] as String,
      feesPerHour: map['feesPerHour'] as int,
      reviews: List<String>.from(map['reviews'] as List<dynamic>),
      ratings: map['ratings'] as int,
      subjects: List<String>.from(map['subjects'] as List<dynamic>),
      selectedTimingsForSubjects: (map['selectedTimingsForSubjects']
                  as Map<String, dynamic>?)
              ?.map(
            (subject, subjectData) {
              return MapEntry(
                subject,
                (subjectData as Map<String, dynamic>).map(
                  (day, dayData) {
                    return MapEntry(
                      day,
                      Map<String, String>.from(dayData as Map<String, dynamic>),
                    );
                  },
                ),
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
      location: map['location'] as String,
      name: map['name'] as String,
      city: map['city'] as String,
      profilePicUrl: map['profilePicUrl'] as String,
      gender: map['gender'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InstructorModel.fromJson(String source) =>
      InstructorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
