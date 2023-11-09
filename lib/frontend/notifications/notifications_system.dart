import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:zaanth/frontend/screens/widgets/custom_snakbar.dart';
import 'package:zaanth/global/firebase_collection_names.dart';

class PushNotificationsSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FirebaseCollectionNamesFields _collectionNamesFields =
      FirebaseCollectionNamesFields();

  //notifications arrived/received
  Future whenNotificationReceived({required BuildContext context}) async {
    //1. Terminated
    //When the app is completely closed and opened directly from the push notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //open app and show notification data

        showNotificationWhenOpenApp(
          uid: remoteMessage.data["userId"],
          context: context,
          messageData: remoteMessage.data,
        );
      }
    });

    //2. Foreground
    //When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        // Show notification when the app is open
        showNotificationWhenOpenApp(
          uid: remoteMessage.data["userId"],
          context: context,
          messageData: remoteMessage.data,
        );
      }
    });

    //3. Background
    //When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        // Show notification when the app is open
        showNotificationWhenOpenApp(
          uid: remoteMessage.data["userId"],
          context: context,
          messageData: remoteMessage.data,
        );
      }
    });
  }

  //device recognition token
  Future generateDeviceRecognitionToken() async {
    String? registrationDeviceToken = await messaging.getToken();

    FirebaseFirestore.instance
        .collection(_collectionNamesFields.userCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "deviceToken": registrationDeviceToken,
    });

    messaging.subscribeToTopic("zaanthUsers");
  }

  showNotificationWhenOpenApp({
    required String uid,
    required context,
    required Map<String, dynamic> messageData,
  }) async {
    // Use the message data to display the notification

    String notificationBodyText = messageData['bodyText'];

    showCustomSnackbar(context, notificationBodyText);
  }
}
