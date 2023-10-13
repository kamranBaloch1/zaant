import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String userId;
  final String reviewId;
  final String content;
  final double ratings;
  final Timestamp date;

  ReviewModel({
    required this.userId,
    required this.reviewId,
    required this.content,
    required this.ratings,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'reviewId': reviewId,
      'content': content,
      'ratings': ratings,
      'date': date
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      userId: map['userId'] as String,
      reviewId: map['reviewId'] as String,
      content: map['content'] as String,
      ratings: map['ratings'] as double,
      date: map['date'] as Timestamp,
    );
  }
}
