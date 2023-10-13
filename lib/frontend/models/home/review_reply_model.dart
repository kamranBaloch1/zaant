// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewReplyModel {

   final String userId;
   final String instructorId;
   final String reviewId;
   final String replyText;
   final Timestamp date;
   final String replyId;
  ReviewReplyModel({
    required this.userId,
    required this.instructorId,
    required this.reviewId,
    required this.replyText,
    required this.date,
    required this.replyId,
  });
  






  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'instructorId': instructorId,
      'reviewId': reviewId,
      'replyText': replyText,
      'date': date,
      'replyId': replyId
    };
  }

  factory ReviewReplyModel.fromMap(Map<String, dynamic> map) {
    return ReviewReplyModel(
      userId: map['userId'] as String,
      instructorId: map['instructorId'] as String,
      reviewId: map['reviewId'] as String,
      replyText: map['replyText'] as String,
      date: map['date'] as Timestamp,
      replyId: map['replyId'] as String,
    
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewReplyModel.fromJson(String source) => ReviewReplyModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
