// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatContactModel {
  String name;
  String profilePicUrl;
  String contactId;
  DateTime timeSent;
  String lastMessage;
  ChatContactModel({
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
       'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      name: map['name'] as String,
      profilePicUrl: map['profilePicUrl'] as String,
      contactId: map['contactId'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      lastMessage: map['lastMessage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatContactModel.fromJson(String source) =>
      ChatContactModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
