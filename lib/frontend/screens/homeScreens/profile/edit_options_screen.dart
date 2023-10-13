// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/details/widgets/show_instructor_reviews.dart';
import 'package:zant/frontend/screens/homeScreens/profile/add_phone_number.dart';
import 'package:zant/frontend/screens/homeScreens/profile/edit_profile_screen.dart';
import 'package:zant/frontend/screens/homeScreens/profile/privacy_settings_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/server/auth/logout.dart';

class ProfileEditOptionsScreen extends StatefulWidget {
  final String? accountType;
  final bool? isPhoneNumberVerified;
  final String? phoneNumber;
  final String? uid;

  const ProfileEditOptionsScreen({
    Key? key,
    required this.accountType,
    required this.isPhoneNumberVerified,
    required this.phoneNumber,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileEditOptionsScreen> createState() =>
      _ProfileEditOptionsScreenState();
}

class _ProfileEditOptionsScreenState extends State<ProfileEditOptionsScreen> {
  bool _isLoading = false;
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout',
              style: TextStyle(color: Colors.black)),
          content: const Text('Are you sure you want to logout?',
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                setState(() {
                  _isLoading = true;
                });

                // Delay the execution of the logout method by 2 seconds
                await Future.delayed(const Duration(seconds: 2));

                // Call the logout method
                await LogoutMethod().logoutUser();

                setState(() {
                  _isLoading = false;
                });
              },
              child:
                  const Text('Logout', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

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

             
              _buildListTile(Icons.lock, 'Privacy Settings', () {
                Get.to(() => const PrivacySettingsScreen());
              }),
              _buildListTile(
                  Icons.phone,
                  widget.isPhoneNumberVerified!
                      ? 'Change Phone Number'
                      : 'Add Phone Number', () {
                // Implement navigation to the Phone Number Screen here.
                Get.to(() => AddPhoneNumberScreen(
                      phoneNumber: widget.phoneNumber,
                    ));
              }),
              if (widget.accountType == "instructor")
                _buildListTile(Icons.reviews, 'Reviews', () {
                  // Implement navigation to the Phone Number Screen here.
                  Get.to(() =>
                      ShowInstructorReviewsScreen(instructorId: widget.uid!));
                }),
              _buildListTile(Icons.exit_to_app, 'Logout', () {
                _showLogoutConfirmationDialog();
              }),
            ],
          ),
        ),

        // show an loading bar if loading is true
        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }

  // Helper function to create a ListTile with an icon and title
  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      onTap: onTap,
    );
  }
}
