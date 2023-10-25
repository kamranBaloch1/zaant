import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:zant/frontend/models/home/notification_model.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/firebase_collection_names.dart';

class NotificationMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to save a notification to Firestore
  Future<void> saveNotificationToFireStore({
    required String notificationText,
    required String receiverUserId,
    required String senderUserId,
  }) async {
    try {
      final String notificationId = const Uuid().v4();
      final NotificationModel notificationModel = NotificationModel(
        notificationText: notificationText,
        notificationId: notificationId,
        receiverUserId: receiverUserId,
        senderUserId: senderUserId,
        notificationDate: Timestamp.fromDate(DateTime.now()),
        isSeen: false,
      );

      await _firestore
          .collection(userCollection)
          .doc(receiverUserId)
          .collection(notificationCollection)
          .doc(notificationId)
          .set(notificationModel.toMap());
       
      print("Notification saved");
    } catch (e) {
      print("Error occurred while saving the notification to Firestore: $e");
    }
  }

  
 // Function to get a stream of notification data

Stream<List<Map<String, dynamic>>> getNotificationStream() {
  try {
    return _firestore
        .collection(userCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(notificationCollection)
        .orderBy("notificationDate", descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final notifications = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return NotificationModel.fromMap(data);
      }).toList();

      final notificationsWithUserData = <Map<String, dynamic>>[];

      for (final notification in notifications) {
        final senderUserId = notification.senderUserId;
        final userRef = _firestore.collection(userCollection).doc(senderUserId);
        final userData = (await userRef.get()).data() as Map<String, dynamic>;

        final notificationDataWithUserData = {
          ...notification.toMap(),
          'userName': userData['name'],
          'userProfilePicUrl': userData['profilePicUrl'],
        };

        notificationsWithUserData.add(notificationDataWithUserData);
      }

      return notificationsWithUserData;
    });
  } catch (error) {
    // Handle the error, e.g., show a snackbar with an error message
    print("Error in getNotificationStream: $error");
    throw error; // Rethrow the error to let the calling code handle it
  }
}






  Future<int> fetchUnreadNotificationCount() async {
    final user = FirebaseAuth.instance.currentUser;
    int unreadNotificationCount = 0;

    if (user != null) {
      final userCollectionRef = _firestore.collection(userCollection);
      final currentUserDoc = userCollectionRef.doc(user.uid);
      final notificationCollectionRef = currentUserDoc.collection(notificationCollection);

      final QuerySnapshot querySnapshot = await notificationCollectionRef.where('isSeen', isEqualTo: false).get();
      unreadNotificationCount = querySnapshot.size;
    } else {
      // User is not logged in
      unreadNotificationCount = 0;
    }

    return unreadNotificationCount;
  }



  // Function to mark the notification as read in Firestore
  Future<void> markNotificationAsRead({
    required String notificationId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userCollectionRef = FirebaseFirestore.instance.collection(userCollection);
      final currentUserDoc = userCollectionRef.doc(user.uid);
      final notificationCollectionRef = currentUserDoc.collection(notificationCollection);

      try {
        // Update the 'isSeen' field to mark the notification as read
        await notificationCollectionRef.doc(notificationId).update({
          'isSeen': true,
        });
        showCustomToast("Notification marked as read");
      } catch (error) {
        // Handle the error, e.g., show a snackbar with an error message
        print("Error marking notification as read: $error");
        showCustomToast("Error marking notification as read");
      }
    }
  }




}
