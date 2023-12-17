// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zaanth/enum/account_type.dart';

class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? profilePicUrl;
  final DateTime? dob;
  final String? gender;
  final String? phoneNumber;
  final bool? isEmailVerified;
  final bool? isPhoneNumberVerified;
  final Timestamp? createdOn;
  final bool? accountStatus;
 AccountTypeEnum? accountType;
  final String? city;
 List<Map<String, String>> enrollments;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePicUrl,
    required this.dob,
    required this.gender,
    required this.phoneNumber,
    required this.isEmailVerified,
    required this.isPhoneNumberVerified,
    required this.createdOn,
    required this.accountStatus,
    required this.accountType,
    required this.city,
    required this.enrollments,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'profilePicUrl': profilePicUrl,
      'dob': dob,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified,
      'isPhoneNumberVerified': isPhoneNumberVerified,
      'createdOn': createdOn,
      'accountStatus': accountStatus,
      'accountType': accountType?.toString().split('.').last, // Store the enum value as a string
      'city': city,           
      'enrollments': enrollments,             
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profilePicUrl: map['profilePicUrl'] as String,
      dob: map['dob'] == null ? null : (map['dob'] as Timestamp).toDate(),
      gender: map['gender'] as String,
     
      phoneNumber: map['phoneNumber'] as String,
      isEmailVerified: map['isEmailVerified'] as bool,
      isPhoneNumberVerified: map['isPhoneNumberVerified'] as bool,
      createdOn: map['createdOn'] as Timestamp,
      accountStatus: map['accountStatus'] as bool,
   accountType: map['accountType'] != null
  ? AccountTypeEnum.values.firstWhere(
      (e) => e.toString() == map['accountType'],
      orElse: () => AccountTypeEnum.unknown, // Use 'unknown' as the default
    )
  : AccountTypeEnum.unknown, // Use 'unknown' as the default
  city: map['city'] as String,
  enrollments: (map['enrollments'] as List<dynamic>).map((enrollmentData) {
        final Map<String, dynamic> enrollmentMap =
            enrollmentData as Map<String, dynamic>;
        return {
          for (final entry in enrollmentMap.entries)
            entry.key: entry.value.toString(),
        };
      }).toList(),

    );
  }



}
