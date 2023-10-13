import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/update/show_intstructor_details.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/frontend/screens/homeScreens/drawer/drawer.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/search_field.dart';
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backgroundColor: appBarColor, title:  accountType == "instructor"? "Instructor Details": "Home Screen"),
      drawer: const MyDrawer(),
      body: accountType == "instructor"
          ? ShowInstructorDetailsScreen()
          : Column(
              children: [
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: const SearchField(),
                ),
              ],
            ),
    );
  }
}
