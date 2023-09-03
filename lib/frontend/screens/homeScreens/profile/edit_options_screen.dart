// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/profile/edit_profile_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';


class ProfileEditOptionsScreen extends StatefulWidget {
 final String? accountType;
  const ProfileEditOptionsScreen({
    Key? key,
   required this.accountType,
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
          appBar:
              ReusableAppBar(backgroundColor: appBarColor, title: "Edit Profile"),
          body: ListView(
            children: [
              SizedBox(
                height: 20.h,
              ),
              _buildListTile(Icons.person, 'Edit Profile', () {
                Get.to(() => const EditProfileScreen());
             
              }),
           widget.accountType=="instructor"?   _buildListTile(Icons.numbers, 'Add Phone Number', () {
                // Get.to(()=> const PhoneNumberScreen());
              }):Container(),
             
            ],
          ),
        ),
       
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style:const TextStyle(color: Colors.black),
      ),
      onTap: onTap,
    );
  }
}
