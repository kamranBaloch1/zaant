import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/profile/update/change_password.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const CustomAppBar(backgroundColor: appBarColor, title: "Privacy Settings"),
      body: Column(
        children: [
          _buildListTile(Icons.lock, 'Change Password', () {
             Get.to(()=> const ChangePasswordScreen());
          }),
        
        ],
      ),
    );
  }
}
