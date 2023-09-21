import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/drawer/drawer.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/show_full_image_dilog.dart';

import 'package:zant/frontend/screens/homeScreens/profile/edit_options_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/sharedprefences/userPref.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? email;
  String? profileUrl;
  String? accountType;
  String? phoneNumber;
  bool _isLoading = true;
  String? error;
  DateTime? dob;
  String? formattedDate;

  @override
  void initState() {
    super.initState();
    _loadingTheState();
    _getUserInfoFromSharedPref().then((_) {}).catchError((err) {
      setState(() {
        error = "An error occurred while fetching user info.";
        _isLoading = false;
      });
    });
  }

  // Simulate loading state with a delay
  Future<void> _loadingTheState() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  // Fetch user info from shared preferences
  Future<void> _getUserInfoFromSharedPref() async {
    name = UserPreferences.getName();
    email = UserPreferences.getEmail();
    profileUrl = UserPreferences.getProfileUrl();
    phoneNumber = UserPreferences.getPhoneNumber();
    dob = UserPreferences.getDob();
    accountType = UserPreferences.getAccountType();
    formattedDate = DateFormat('yyyy-MM-dd').format(dob!);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            backgroundColor: appBarColor,
            title: "Your Profile",
          ),
          drawer: const MyDrawer(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
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
                    radius: 70.r,
                    backgroundImage: NetworkImage(profileUrl!),
                  ),
                ),
                SizedBox(height: 20.h),
                _buildUserInfoRow(
                  "Name",
                  name![0].toUpperCase() + name!.substring(1),
                ),
                _buildUserInfoRow("Email", email!),
                _buildUserInfoRow("Date of Birth", formattedDate!),
                accountType == "instructor"
                    ? _buildUserInfoRow(
                        "Phone Number",
                        phoneNumber != "" ? phoneNumber! : "Empty",
                      )
                    : Container(),
                SizedBox(height: 50.h),
                Container(
                  width: 120.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => ProfileEditOptionsScreen(
                            accountType: accountType,
                          ));
                    },
                    child: Text(
                      "Edit",
                      style: TextStyle(color: Colors.black, fontSize: 18.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Show a loading overlay if `_isLoading` is true
        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }

  Widget _buildUserInfoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.black, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
