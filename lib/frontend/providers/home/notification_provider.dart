
import 'package:flutter/material.dart';

import 'package:zaanth/server/notifications/notification_method.dart';

// Create a class called NotificationProviders that extends ChangeNotifier
class NotificationProviders extends ChangeNotifier {
  // Instantiate the NotificationMethod class for handling notifications
  final NotificationMethod _notificationMethod = NotificationMethod();
 
  // Create a Stream to provide a stream of notification data
  Stream<List<Map<String, dynamic>>> getNotificationStreamProvider() {
    return _notificationMethod.getNotificationStream();
  }

  // Asynchronously fetch the count of unread notifications
  Future<int> fetchUnreadNotificationCountProvider() async {
    return _notificationMethod.fetchUnreadNotificationCount();
  }

  // Mark a notification as read and notify listeners of the change
  Future<void> markNotificationAsReadProvider({required String notificationId}) async {
    try {
      // Call the method to mark a notification as read
      await _notificationMethod.markNotificationAsRead(notificationId: notificationId);
      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      // Handle errors, e.g., by showing a snackbar with an error message
      print("Error in markNotificationAsRead: $e");
    }
  }
}
