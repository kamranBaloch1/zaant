import 'package:zaanth/global/apis_keys.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class NotificationFormat{



  void notificationFormat(
      {required String deviceToken,
      required String userName,
      required String notificationBodyText,
      required String notificationTitleText,
      required String userId
      }) {
    Map<String, String> notificationHeader = {
      'Content-Type': 'application/json',
      'Authorization': 'key=${ApisKeys().fcmServerKey}',
    };
    Map notificationBody = {
      'body': notificationBodyText,
      'title': notificationTitleText,
     
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      'userId': userId,
      'bodyText':notificationBodyText
      
    };

    Map officialNotificationFormat = {
      'notification': notificationBody,
      'data': dataMap,
      'priority': 'high',
      'to': deviceToken,
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