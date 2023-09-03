// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zant/enum/account_type.dart';

class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? profileUrl;
  final DateTime? dob;
  final String? gender;
  final String? location;
  final int? phoneNumber;
  final bool? isEmailVerified;
  final bool? isPhoneNumberVerified;
  final Timestamp? createdOn;
  final bool? accountStatus;
 AccountTypeEnum? accountType;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileUrl,
    required this.dob,
    required this.gender,
    required this.location,
    required this.phoneNumber,
    required this.isEmailVerified,
    required this.isPhoneNumberVerified,
    required this.createdOn,
    required this.accountStatus,
    required this.accountType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'profileUrl': profileUrl,
      'dob': dob,
      'gender': gender,
      'location': location,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified,
      'isPhoneNumberVerified': isPhoneNumberVerified,
      'createdOn': createdOn,
      'accountStatus': accountStatus,
      'accountType': accountType?.toString().split('.').last, // Store the enum value as a string
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profileUrl: map['profileUrl'] as String,
      dob: map['dob'] == null ? null : (map['dob'] as Timestamp).toDate(),
      gender: map['gender'] as String,
      location: map['location'] as String,
      phoneNumber: map['phoneNumber'] as int,
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


    );
  }
}
