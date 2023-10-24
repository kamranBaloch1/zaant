import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zant/global/firebase_collection_names.dart';
import 'package:zant/server/notifications/notification_format.dart';

class SendNotificationsMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final NotificationFormat _notificationFormat = NotificationFormat();

  Future<void> sendNotificationsToInstructorForNewEnrollment({
    required String instructorUid,
    required String userName,
  }) async {
    String deviceToken = "";

    try {
      final instructorDoc =
          await _firestore.collection(userCollection).doc(instructorUid).get();
      if (instructorDoc.data() != null &&
          instructorDoc.data()!['deviceToken'] != null) {
        deviceToken = instructorDoc.data()!['deviceToken'];

        _notificationFormat.notificationFormat(
          deviceToken: deviceToken,
          userName: userName,
          notificationBodyText: "$userName enrolled you",
          notificationTitleText: "New Enrollment",
        );
      }
    } catch (e) {
      print("error occurred: $e");
    }
  }

  Future<void> sendNotificationsToInstructorForNewReview({
    required String instructorUid,
    required String userName,
  }) async {
    String deviceToken = "";

    try {
      final instructorDoc =
          await _firestore.collection(userCollection).doc(instructorUid).get();
      if (instructorDoc.data() != null &&
          instructorDoc.data()!['deviceToken'] != null) {
        deviceToken = instructorDoc.data()!['deviceToken'];

        _notificationFormat.notificationFormat(
          deviceToken: deviceToken,
          userName: userName,
          notificationBodyText: "$userName added a reviwed",
          notificationTitleText: "New Review",
        );
      }
    } catch (e) {
      print("error occurred: $e");
    }
  }

  Future<void> sendNotificationsToUsersForReviewReplay(
      {required String userName, required String userId}) async {
    String deviceToken = "";

    try {
      final instructorDoc =
          await _firestore.collection(userCollection).doc(userId).get();
      if (instructorDoc.data() != null &&
          instructorDoc.data()!['deviceToken'] != null) {
        deviceToken = instructorDoc.data()!['deviceToken'];

        _notificationFormat.notificationFormat(
          deviceToken: deviceToken,
          userName: userName,
          notificationBodyText: "$userName replied you",
          notificationTitleText: "New Replay",
        );
      }
    } catch (e) {
      print("error occurred: $e");
    }
  }

  Future<void> sendNotificationsToUsersForNewMessage(
      {required String userName, required String userId}) async {
    String deviceToken = "";

    try {
      final instructorDoc =
          await _firestore.collection(userCollection).doc(userId).get();
      if (instructorDoc.data() != null &&
          instructorDoc.data()!['deviceToken'] != null) {
        deviceToken = instructorDoc.data()!['deviceToken'];

        _notificationFormat.notificationFormat(
          deviceToken: deviceToken,
          userName: userName,
          notificationBodyText: "$userName sent message",
          notificationTitleText: "New Message",
        );
      }
    } catch (e) {
      print("error occurred: $e");
    }
  }
}
