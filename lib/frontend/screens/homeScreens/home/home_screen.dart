import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zant/frontend/notifications/notifications_system.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/update/show_intstructor_details.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/frontend/screens/homeScreens/drawer/drawer.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/search_field_design.dart';
import 'package:zant/global/constant_values.dart';
import 'package:zant/sharedprefences/userPref.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? accountType;

  @override
  void initState() {
    // TODO: implement initState
    accountType = UserPreferences.getAccountType();

    PushNotificationsSystem pushNotificationsSystem =
        PushNotificationsSystem();

    pushNotificationsSystem.generateDeviceRecognitionToken();
    pushNotificationsSystem.whenNotificationReceived(context: context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: CustomAppBar(
          backgroundColor: appBarColor,
          title: accountType == "instructor" ? "Instructor Details" : "Zaanth"),
      drawer: const MyDrawer(),
      body: accountType == "instructor"
          ? ShowInstructorDetailsScreen()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 70.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: const SearchField(),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Image.asset(
                  homeBannerImg,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: 400.h,
                ),
              ],
            ),
    );
  }
}
