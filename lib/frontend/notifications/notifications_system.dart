import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:zant/frontend/screens/widgets/custom_snakbar.dart';
import 'package:zant/global/firebase_collection_names.dart';

class PushNotificationsSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //notifications arrived/received
  Future whenNotificationReceived({required BuildContext context}) async {
    //1. Terminated
    //When the app is completely closed and opened directly from the push notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //open app and show notification data
        // showNotificationWhenOpenApp(uid: remoteMessage.data["userId"], context: context);
      }
    });

    //2. Foreground
    //When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //directly show notification data
        //  showNotificationWhenOpenApp(uid: remoteMessage.data["userId"], context: context);
      }
    });

    //3. Background
    //When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //open the app - show notification data
        
      //  showNotificationWhenOpenApp(uid: remoteMessage.data["userId"], context: context);
      }
    });
  }

  //device recognition token
  Future generateDeviceRecognitionToken() async {
    String? registrationDeviceToken = await messaging.getToken();

    FirebaseFirestore.instance
        .collection(userCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "deviceToken": registrationDeviceToken,
      
    });

    messaging.subscribeToTopic("zaanthUsers");
  }

  showNotificationWhenOpenApp({required String uid, required context}) async {
    await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(uid)
        .get()
        .then((snapshot) {
      showCustomSnackbar(context, "${snapshot.data()!['name']} enrolled you");
    });
  }
}
