import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zant/global/firebase_collection_names.dart';
import 'package:zant/global/keys.dart';
import 'package:http/http.dart' as http;

class SendNotificationsMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void sendNotificationsToInstructor(
      {required String instructorUid,
      required String userName,
      required String userId}) {
    String instructorDeviceToken="";

   try {
      _firestore
        .collection(userCollection)
        .doc(instructorUid)
        .get()
        .then((value) {
      if (value.data()!['deviceToken'] != null) {
        instructorDeviceToken = value.data()!['deviceToken'];
        print("device tken is $instructorDeviceToken");
      }
    });
   } catch (e) {
      print("error accounrd $e");
   }
    notificationFormat(
        instructorDeviceToken: instructorDeviceToken,
        userName: userName,
        userId: userId);
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
  http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: notificationHeader,
      body: jsonEncode(officialNotificationFormat),
    );
  }
}
