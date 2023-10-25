// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notificationText;
  final String notificationId;
  final String receiverUserId;
  final String senderUserId;
  final Timestamp notificationDate;
  final bool isSeen;
  NotificationModel({
    required this.notificationText,
    required this.notificationId,
    required this.receiverUserId,
    required this.senderUserId,
    required this.notificationDate,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notificationText': notificationText,
      'notificationId': notificationId,
      'receiverUserId': receiverUserId,
      'senderUserId': senderUserId,
      'notificationDate': notificationDate,
      'isSeen': isSeen,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
        notificationText: map['notificationText'] as String,
        notificationId: map['notificationId'] as String,
        receiverUserId: map['receiverUserId'] as String,
        senderUserId: map['senderUserId'] as String,
        notificationDate: map['notificationDate'] as Timestamp,
        isSeen: map['isSeen'] as bool);
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
