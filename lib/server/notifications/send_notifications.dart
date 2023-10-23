import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zant/global/firebase_collection_names.dart';
import 'package:zant/global/keys.dart';
import 'package:http/http.dart' as http;

class SendNotificationsMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> sendNotificationsToInstructor(
      {required String instructorUid,
      required String userName,
      required String userId}) async {
    String instructorDeviceToken = "";

    try {
      final instructorDoc =
          await _firestore.collection(userCollection).doc(instructorUid).get();
      if (instructorDoc.data() != null &&
          instructorDoc.data()!['deviceToken'] != null) {
        instructorDeviceToken = instructorDoc.data()!['deviceToken'];
        print("device token is $instructorDeviceToken");
        notificationFormat(
            instructorDeviceToken: instructorDeviceToken,
            userName: userName,
            userId: userId);
      }
    } catch (e) {
      print("error occurred: $e");
    }
  }

  void notificationFormat(
      {required String instructorDeviceToken,
      required String userName,
      required String userId}) {
    Map<String, String> notificationHeader = {
      'Content-Type': 'application/json',
      'Authorization': fcmServerKey,
    };
    Map notificationBody = {
      'body': "$userName enrolled you",
      'title': "new enrollment"
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "userId": userId,
    };

    Map officialNotificationFormat = {
      'notification': notificationBody,
      'data': dataMap,
      'priority': 'high',
      'to': instructorDeviceToken,
    };
    http
        .post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: notificationHeader,
      body: jsonEncode(officialNotificationFormat),
    )
        .then((response) {
      if (response.statusCode == 200) {
        print("Notification sent successfully.");
      } else {
        print(
            "Failed to send notification. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    }).catchError((error) {
      print("Error sending notification: $error");
    });
  }
}
