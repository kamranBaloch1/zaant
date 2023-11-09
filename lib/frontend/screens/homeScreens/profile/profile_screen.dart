import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zaanth/frontend/screens/homeScreens/drawer/drawer.dart';

import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/show_full_image_dilog.dart';
import 'package:zaanth/frontend/screens/homeScreens/profile/edit_options_screen.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/global/colors.dart';
import 'package:zaanth/sharedprefences/userPref.dart';

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
  bool? isPhoneNumberVerified;
  String? uid;
  String? error;
  DateTime? dob;
  String? formattedDate;
  bool _isLoading = true;

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

  Future<void> _loadingTheState() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getUserInfoFromSharedPref() async {
    name = UserPreferences.getName();
    email = UserPreferences.getEmail();
    profileUrl = UserPreferences.getProfileUrl();
    phoneNumber = UserPreferences.getPhoneNumber();
    isPhoneNumberVerified = UserPreferences.getIsPhoneNumberVerified();
    dob = UserPreferences.getDob();
    formattedDate = DateFormat('yyyy-MM-dd').format(dob!);
    accountType = UserPreferences.getAccountType();
    uid = UserPreferences.getUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: appBarColor,
        title: name![0].toUpperCase() + name!.substring(1),
      ),
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          Container(
           
            decoration:   BoxDecoration(
                borderRadius: BorderRadius.only(
      topLeft: Radius.circular(5.r),  
      topRight: Radius.circular(5..r), 
     
    ),
              gradient:  LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
               colors: [Colors.grey[200]!, Colors.black26],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return FullImageDialog(imageUrl: profileUrl!);
                        },
                      );
                    },
                    child: Container(
                      width: 140.r,
                      height: 140.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4.r,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 68.r,
                        backgroundImage: NetworkImage(profileUrl!),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildUserInfoRow("Name", name!),
                        _buildUserInfoRow("Email", email!),
                        _buildUserInfoRow("Date of Birth", formattedDate!),
                        _buildUserInfoRow(
                          "Phone Number",
                          phoneNumber != "" ? phoneNumber! : "Empty",
                        ),
                         SizedBox(height: 24.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          onPressed: () {
                            Get.to(() => ProfileEditOptionsScreen(
                                  accountType: accountType,
                                  isPhoneNumberVerified: isPhoneNumberVerified,
                                  phoneNumber: phoneNumber,
                                  uid: uid,
                                ));
                          },
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) const CustomLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildUserInfoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.all(16.r),
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
