// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:zant/frontend/screens/authSceens/authWidgets/custom_auth_field.dart';
import 'package:zant/frontend/screens/authSceens/login/login_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_dropdown.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/global/constant_values.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  String? selectedGender;
  DateTime? selectedDate;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose

    _name.dispose();
    _email.dispose();
    _confirmPassword.dispose();
    _password.dispose();
    _dobController.dispose();
    super.dispose();
  }

  XFile? _selectedImage;

  void _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImg = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImg;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.black, // Color of selected date
            dialogBackgroundColor: Colors.black, // Background color
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dobController.text =
            "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
          backgroundColor: appBarColor, title: "Register an account"),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.h,),
              GestureDetector(
                onTap: _pickImageFromGallery,
                child: Center(
                  child: _selectedImage != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(File(_selectedImage!.path)),
                          radius: 60.r,
                        )
                      : CircleAvatar(
                          backgroundImage: AssetImage(assetDefaultImg),
                          radius: 60.r,
                        ),
                ),
              ),
              SizedBox(height: 20.h),
              CustomAuthTextField(
                hintText: "Name",
                icon: const Icon(Icons.person),
                obSecure: false,
                keyBoardType: TextInputType.text,
                controller: _name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomAuthTextField(
                hintText: "Email",
                icon: const Icon(Icons.email),
                obSecure: false,
                keyBoardType: TextInputType.emailAddress,
                controller: _email,
                validator: (value) {
                  return RegExp(
                              // Regular expression to validate email
                              "[a-z0-9!#%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                          .hasMatch(value!)
                      ? null
                      : "Please enter a valid email address";
                },
              ),
              SizedBox(height: 20.h),
              CustomAuthTextField(
                hintText: "Password",
                icon: IconButton(
                  icon: Icon(
                    _isObscure1 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure1 = !_isObscure1;
                    });
                  },
                ),
                obSecure: _isObscure1,
                keyBoardType: TextInputType.text,
                controller: _password,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length<8) {
                    return 'password must be atleast 8 chars';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
             
              CustomAuthTextField(
                hintText: "Confirm password",
                icon: IconButton(
                  icon: Icon(
                    _isObscure2 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure2 = !_isObscure2;
                    });
                  },
                ),
                obSecure: _isObscure2,
                keyBoardType: TextInputType.text,
                controller: _confirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty || value != _password.text.trim()) {
                    return "confirm password did'nt matched with password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomDropdown(
                items: const ["male", "female"],
                value: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value; // Store the selected value
                  });
                },
                labelText: "Select the gender",
                icon: Icons.person,
              ),
              SizedBox(height: 20.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  controller: _dobController,
                  style: TextStyle(fontSize: 16.sp, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "DOB",
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  ),
                ),
              ),
               GestureDetector(
                      onTap: () {
                        Get.to(() => const LoginScreen());
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 15.w, top: 15.h),
                        alignment: Alignment.bottomRight,
                        child: const Text(
                          "Login?",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:5.h),
                    
             CustomButton(navigateToNextScreen: (){
              if(_formKey.currentState!.validate()){

              }
             },  width: 200.w, height: 40.h, text: "Register", bgColor: Colors.blue)
        , SizedBox(height:20.h),
        
            ],
          ),
        ),
      ),
    );
  }
}
