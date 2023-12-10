import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zaanth/frontend/providers/home/chat_providers.dart';
import 'package:zaanth/frontend/providers/home/notification_provider.dart';
import 'package:zaanth/frontend/screens/homeScreens/chat/chat_inbox_screen.dart';
import 'package:zaanth/frontend/screens/homeScreens/enrollments/enrolled_instructor_for_user.dart';
import 'package:zaanth/frontend/screens/homeScreens/enrollments/enrolled_users_for_insructor.dart';
import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/show_full_image_dilog.dart';
import 'package:zaanth/frontend/screens/homeScreens/notifications/notification_screen.dart';
import 'package:zaanth/frontend/screens/homeScreens/profile/profile_screen.dart';
import 'package:zaanth/frontend/screens/homeScreens/home/home_screen.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/add/add_details_screen.dart';
import 'package:zaanth/global/colors.dart';

import 'package:zaanth/sharedprefences/userPref.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? name;
  String? profileUrl;
  String? accountType;

  @override
  void initState() {
    super.initState();
    // Fetch the unread notification count
    fetchUnreadNotificationCount();
    fetchUnreadMessagesCount();
    // Fetch user info from SharedPreferences
    name = UserPreferences.getName();
    profileUrl = UserPreferences.getProfileUrl();
    accountType = UserPreferences.getAccountType();
  }

  int unreadNotificationCount = 0;
  int unreadMessageCount = 0;
  Future<void> fetchUnreadNotificationCount() async {
    final notificationProvider =
        Provider.of<NotificationProviders>(context, listen: false);
    final count =
        await notificationProvider.fetchUnreadNotificationCountProvider();

    if (mounted) {
      setState(() {
        unreadNotificationCount = count;
      });
    }
  }

  Future<void> fetchUnreadMessagesCount() async {
    final chatsProvider = Provider.of<ChatProviders>(context, listen: false);
    final count = await chatsProvider.fetchUnreadMessagesCountProvider();

    if (mounted) {
      setState(() {
        unreadMessageCount = count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: drawerBgColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: drawerBgColor,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FullImageDialog(imageUrl: profileUrl!);
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 40.r,
                    backgroundImage: NetworkImage(profileUrl!),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  name!,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.3.sp,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Get.offAll(() => const HomeScreen());
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Colors.black,
            ),
            title: const Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Get.to(() => const ProfileScreen());
            },
          ),
          ListTile(
            leading: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.chat, color: Colors.black),
                if (unreadMessageCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
            title: const Text(
              'Inbox',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onTap: () {
              Get.to(() => const ChatInboxScreen());
            },
          ),
          accountType == "user"
              ? ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: Colors.black,
                  ),
                  title: const Text(
                    'Enrolled Instructors',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Get.to(() => const ShowEnrolledInstructorForUserScreen());
                  },
                )
              : Container(),
          accountType == "user"
              ? ListTile(
                  leading: const Icon(
                    Icons.school,
                    color: Colors.black,
                  ),
                  title: const Text(
                    'Become an instructor',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Get.to(() => const AddDetailsScreen());
                   
                  },
                )
              : accountType == "instructor"
                  ? ListTile(
                      leading: const Icon(
                        Icons.person_outline,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'Enrolled users',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Get.to(() => const ShowEnrolledUsersForInstructor());
                      },
                    )
                  : Container(),
          ListTile(
            leading: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications, color: Colors.black),
                if (unreadNotificationCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Text(
                        '$unreadNotificationCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            title: const Text(
              'Notifications',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onTap: () {
              Get.to(() => const NotificationsScreen());
            },
          ),
        ],
      ),
    );
  }
}
