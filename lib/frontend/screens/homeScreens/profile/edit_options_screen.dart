// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:zant/frontend/screens/homeScreens/instructor/update/show_intstructor_details.dart';
import 'package:zant/frontend/screens/homeScreens/profile/add_phone_number.dart';
import 'package:zant/frontend/screens/homeScreens/profile/edit_profile_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';

class ProfileEditOptionsScreen extends StatefulWidget {
  final String? accountType;
  final bool? isPhoneNumberVerified;
  final String? phoneNumber;

  const ProfileEditOptionsScreen({
    Key? key,
    required this.accountType,
    required this.isPhoneNumberVerified,
   required this.phoneNumber,
  }) : super(key: key);

  @override
  State<ProfileEditOptionsScreen> createState() =>
      _ProfileEditOptionsScreenState();
}

class _ProfileEditOptionsScreenState extends State<ProfileEditOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            backgroundColor: appBarColor,
            title: "Edit Profile",
          ),
          body: ListView(
            children: [
              SizedBox(
                height: 20.h,
              ),
              // Edit Profile ListTile
              _buildListTile(Icons.person, 'Edit Profile', () {
                Get.to(() => const EditProfileScreen());
              }),

              if (widget.accountType == "instructor")
                _buildListTile(Icons.edit, 'Instrutor details', () {
                  // Implement navigation to the Phone Number Screen here.
                  Get.to(() => const ShowInstructorDetailsScreen());
                }),

              _buildListTile(
                  Icons.phone,
                  widget.isPhoneNumberVerified!
                      ? 'Change Phone Number'
                      : 'Add Phone Number', () {
                // Implement navigation to the Phone Number Screen here.
                Get.to(() =>  AddPhoneNumberScreen(phoneNumber:widget.phoneNumber ,));
              }),
            ],
          ),
        ),
      ],
    );
  }

  // Helper function to create a ListTile with an icon and title
  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      onTap: onTap,
    );
  }
}
