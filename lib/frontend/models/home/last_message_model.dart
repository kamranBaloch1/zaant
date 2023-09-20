// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessageModel {

   String name;
   String profilePicUrl;
   String contactId;
   Timestamp timeSent;
   String lastMessage;
  LastMessageModel({
    required this.name,
    required this.profilePicUrl,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
  });

 





  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePicUrl': profilePicUrl,
      'contactId': contactId,
      'timeSent': timeSent,
      'lastMessage': lastMessage,
    };
  }

  factory LastMessageModel.fromMap(Map<String, dynamic> map) {
    return LastMessageModel(
      name: map['name'] as String,
      profilePicUrl: map['profilePicUrl'] as String,
      contactId: map['contactId'] as String,
      timeSent: map["timeSent"] as Timestamp,
      lastMessage: map['lastMessage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LastMessageModel.fromJson(String source) => LastMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
