import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zant/frontend/providers/home/notification_provider.dart';
import 'package:zant/frontend/screens/homeScreens/drawer/drawer.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/custom_alert_dilog.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';
import 'package:provider/provider.dart';


class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar:
          CustomAppBar(backgroundColor: appBarColor, title: "Notifications"),
      body: NotificationList(),
      drawer: MyDrawer(),
    );
  }
}

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Provider.of<NotificationProviders>(context, listen: false)
          .getNotificationStreamProvider(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            "No Notifications", // Your custom message here
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.black,
            ),
          ));
        }

        final notificationData = snapshot.data!;
        return ListView.builder(
          itemCount: notificationData.length,
          itemBuilder: (context, index) {
            final notification = notificationData[index];
            final notificationText = notification['notificationText'] as String;
            final notificationSenderName = notification['userName'] as String;
            final notificationSenderProfilePicUrl =
                notification['userProfilePicUrl'] as String;
            final notificationIsSeen = notification['isSeen'] as bool;
            final notificationId = notification['notificationId'] as String;
            final notificationDate =
                notification['notificationDate'] as Timestamp;
          final formattedDateTime = DateFormat('yMMMEd hh:mm a').format(notificationDate.toDate());

            // Define a color for the Card based on whether the notification is seen or not
            final cardColor = notificationIsSeen
                ? Colors.white
                : const Color.fromARGB(31, 189, 186, 186);

            return Card(
              color: cardColor,
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.sp),
                leading: CircleAvatar(
                  radius: 30.sp,
                  backgroundImage:
                      NetworkImage(notificationSenderProfilePicUrl),
                ),
                title: Text(
                  "$notificationSenderName $notificationText",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                subtitle: Text(
                  'sent on: $formattedDateTime',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black54,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Show a dialog to mark the notification as read
                    CustomAlertDilog.show(
                      context: context,
                      title: "Mark Notification as Read?",
                      content: "Do you want to mark this notification as read?",
                      onConfirm: () async {
                        await Provider.of<NotificationProviders>(context,
                                listen: false)
                            .markNotificationAsReadProvider(
                                notificationId: notificationId);
                                
                      
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
