import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zaanth/frontend/screens/authSceens/register/register_screen.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/constant_values.dart';

class SelectProfilePicScreen extends StatefulWidget {
  const SelectProfilePicScreen({super.key});

  @override
  State<SelectProfilePicScreen> createState() => _SelectProfilePicScreenState();
}

class _SelectProfilePicScreenState extends State<SelectProfilePicScreen> {
  XFile? _selectedImage;

  Future<void> _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImg = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

         IconButton(onPressed: (){
          Navigator.pop(context);
         }, icon: const Icon(Icons.arrow_back)),

          SizedBox(
            height: 50.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 40.w),
            child: Text(
              "Select your profile picture",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 150.h,
          ),
          GestureDetector(
            onTap: _pickImageFromGallery,
            child: Center(
              child: _selectedImage != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(File(_selectedImage!.path)),
                      radius: 80.r,
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(defaultProfileImage),
                      radius: 80.r,
                    ),
            ),
          ),
          SizedBox(
            height: 250.h,
          ),
          Center(
            child: CustomButton(
                onTap: () {
                  if (_selectedImage == null) {
                    showCustomToast("Please select an profile picture");
                    return;
                  }

                  Get.to(() => RegisterScreen(profilePicImg: _selectedImage));
                },
                width: 200,
                height: 40,
                text: "Next",
                bgColor: Colors.blue),
          )
        ],
      )),
    );
  }
}
