import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zaanth/global/firebase_collection_names.dart';
import 'package:zaanth/server/notifications/notification_format.dart';

class SendNotificationsMethod {
  final FirebaseCollectionNamesFields _collectionNamesFields = FirebaseCollectionNamesFields();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationFormat _notificationFormat = NotificationFormat();

  Future<void> sendNotificationsToInstructorForNewEnrollment({
    required String instructorUid,
    required String userName,
  }) async {
    String deviceToken = "";

    try {
      // Get instructor's document and check if it has a device token
      final instructorDoc =
          await _firestore.collection(_collectionNamesFields.userCollection).doc(instructorUid).get();

      if (instructorDoc.data() != null &&
          instructorDoc.data()!['deviceToken'] != null) {
        deviceToken = instructorDoc.data()!['deviceToken'];

        // Format and send the notification
        _notificationFormat.notificationFormat(
          deviceToken: deviceToken,
          userName: userName,
          notificationBodyText: "$userName enrolled you",
          notificationTitleText: "New Enrollment",
          userId: instructorUid
        );
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> sendNotificationsToInstructorForNewReview({
    required String instructorUid,
    required String userName,
 
  }) async {
    String deviceToken = "";

    try {
      // Get instructor's document and check if it has a device token
      final instructorDoc =
          await _firestore.collection(_collectionNamesFields.userCollection).doc(instructorUid).get();

      if (instructorDoc.data() != null &&
          instructorDoc.data()!['deviceToken'] != null) {
        deviceToken = instructorDoc.data()!['deviceToken'];

        // Format and send the notification
        _notificationFormat.notificationFormat(
          deviceToken: deviceToken,
          userName: userName,
          notificationBodyText: "$userName added a review",
          notificationTitleText: "New Review",
           userId: instructorUid
        );
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> sendNotificationsToUsersForReviewReplay({
    required String userName,
    required String userId,
  }) async {
    String deviceToken = "";

    try {
      // Get user's document and check if it has a device token
      final userDoc = await _firestore.collection(_collectionNamesFields.userCollection).doc(userId).get();

      if (userDoc.data() != null && userDoc.data()!['deviceToken'] != null) {
        deviceToken = userDoc.data()!['deviceToken'];

        // Format and send the notification
        _notificationFormat.notificationFormat(
          deviceToken: deviceToken,
          userName: userName,
          notificationBodyText: "$userName replied to your review",
          notificationTitleText: "New Replay",
          userId: userId
        );
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> sendNotificationsToUsersForNewMessage({
    required String userName,
    required String userId,
    required String messageTypeText,
  }) async {
    String deviceToken = "";

    try {
      // Get user's document and check if it has a device token
      final userDoc = await _firestore.collection(_collectionNamesFields.userCollection).doc(userId).get();

      if (userDoc.data() != null && userDoc.data()!['deviceToken'] != null) {
        deviceToken = userDoc.data()!['deviceToken'];

        // Format and send the notification
        _notificationFormat.notificationFormat(
          deviceToken: deviceToken,
          userName: userName,
          notificationBodyText: "$userName sent $messageTypeText",
          notificationTitleText: "New Message",
           userId: userId
        );
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }
}
