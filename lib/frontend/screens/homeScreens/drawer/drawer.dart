import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/chat/chat_inbox_screen.dart';
import 'package:zant/frontend/screens/homeScreens/enrollments/enrolled_instructor_for_user.dart';
import 'package:zant/frontend/screens/homeScreens/enrollments/enrolled_users_for_insructor.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/show_full_image_dilog.dart';
import 'package:zant/frontend/screens/homeScreens/profile/profile_screen.dart';
import 'package:zant/frontend/screens/homeScreens/home/home_screen.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/add/add_details_screen.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/sharedprefences/userPref.dart';


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

    // Fetch user info from SharedPreferences
    name = UserPreferences.getName();
    profileUrl = UserPreferences.getProfileUrl();
    accountType = UserPreferences.getAccountType();
    print("this is account type $accountType");
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
                  onTap: (){
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
                  name![0].toUpperCase() + name!.substring(1),
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
            leading: const Icon(Icons.home),
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
            
              Get.offAll(() => const HomeScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Get.to(() => const ProfileScreen());
            },
          ),
            ListTile(
            leading: const Icon(Icons.chat),
            title: const Text(
              'Inbox',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
               Get.to(()=>  ChatInboxScreen());
            },
          ),
           accountType=="user"?  ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text(
              'Enrolled Instructors',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
               Get.to(()=>const  ShowEnrolledInstructorForUserScreen());
            },
          ):Container(),
        accountType=="user"?  ListTile(
            leading: const Icon(Icons.school),
            title: const Text(
              'Become an instructor',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Get.to(() => const AddDetailsScreen());
            },
          ):  accountType=="instructor"? ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text(
              'Enrolled users',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
               Get.to(()=>const  ShowEnrolledUsersForInstructor());
            },
          ):Container(),
         
        
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
            
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text(
              'Help',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
