import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/home/home_screen.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/add_an_instructor_screen.dart';
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
                CircleAvatar(
                  radius: 40.r,
                  backgroundImage: NetworkImage(profileUrl!),
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
             
            },
          ),
        accountType=="user"?  ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text(
              'Become an instructor',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Get.offAll(() => const AddInstructorScreen());
            },
          ):  accountType=="instructor"? ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text(
              'Enrollments',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              // Get.offAll(() => const ViewAllTransportScreen());
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
