import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zaanth/frontend/providers/auth/register_providers.dart';
import 'package:zaanth/frontend/screens/authSceens/authWidgets/custom_auth_field.dart';
import 'package:zaanth/frontend/screens/authSceens/login/login_screen.dart';
import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/custom_cities_dropdown.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_dropdown.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';

class RegisterScreen extends StatefulWidget {
  final XFile? profilePicImg;

  const RegisterScreen({
    Key? key,
    required this.profilePicImg,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  bool _isLoading = false;
  String? selectedGender;
  DateTime? selectedDate;
  String? selectedCity;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    super.dispose();
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

  Future<void> _registerUser() async {
    
    final registerProvider =
        Provider.of<RegisterProviders>(context, listen: false);

    String email = _emailController.text.trim();
    String name = _nameController.text.trim();
    // Capitalize the first letter of the name
    name = name.substring(0, 1).toUpperCase() + name.substring(1);
    String password = _passwordController.text.trim();

    if (selectedDate != null && selectedGender != null) {
      final DateTime now = DateTime.now();
      final DateTime minDate = DateTime(now.year - 4, now.month, now.day);

      if (selectedDate!.isBefore(minDate)) {
        if (selectedCity == null) {
          showCustomToast("please select your city");
          return;
        }

        setState(() {
      _isLoading = true;
    });

        await registerProvider.registerWithEmailAndPasswordProvider(
          email: email,
          password: password,
          photoUrl: widget.profilePicImg,
          name: name,
          gender: selectedGender,
          dob: selectedDate,
          city: selectedCity!,
        );

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        showCustomToast("You must be older than 4 years to register.");
      }
    } else {
      showCustomToast("Please select your gender and date of birth");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(
              backgroundColor: appBarColor, title: "Register an account"),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 80.h,
                  ),
                  CustomAuthTextField(
                    hintText: "Name",
                    icon: const Icon(Icons.person),
                    obSecure: false,
                    keyBoardType: TextInputType.text,
                    controller: _nameController,
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
                    controller: _emailController,
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
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 8) {
                        return 'Password must be at least 8 characters';
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
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != _passwordController.text.trim()) {
                        return "Confirm password doesn't match with password";
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
                          offset: const Offset(0, 2),
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
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomCitiesDropdown(
                        selectedCity: selectedCity,
                        labelText: "Select your city",
                        onChanged: (value) {
                          setState(() {
                            selectedCity = value;
                          });
                        }),
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
                  SizedBox(height: 20.h),
                  CustomButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _registerUser();
                      }
                    },
                    width: 200.w,
                    height: 40.h,
                    text: "Register",
                    bgColor: Colors.blue,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),

        // showing a loading overlay if loading is true
        if (_isLoading) const CustomLoadingOverlay(),
      ],
    );
  }
}
