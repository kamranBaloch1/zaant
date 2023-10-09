import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/custom_home_text_field.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/server/home/profile_methods.dart';
import 'package:zant/sharedprefences/userPref.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  String? email;
  bool _isLoading = false;
  late TextEditingController _emailC;
  late TextEditingController _password;
  late TextEditingController _newEmailC;

  @override
  void initState() {
    super.initState();
    _fetchUserInfoFromSharedPref();
  }

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks.
    _emailC.dispose();
    super.dispose();
  }

  void _fetchUserInfoFromSharedPref() async {
    // Fetch user info from SharedPreferences
    email = UserPreferences.getEmail();

    // Initialize the controllers after fetching data from SharedPreferences
    _emailC = TextEditingController(text: email);
    _password = TextEditingController();
    _newEmailC = TextEditingController();
  }

  void _sendEmailVerifyLink() async {
    try {
      String newEmail = _newEmailC.text.trim();
      String password = _password.text.trim();
      String currentEmail = _emailC.text.trim();

    
      if (newEmail.isEmpty) {
        showCustomToast("please write a new email");
        return;
      }
        if (password.isEmpty) {
        showCustomToast("please enter your current password");
        return;
      }
      if (newEmail == currentEmail) {
        showCustomToast("please choose an diffrent email");
        return;
      }
      setState(() {
        _isLoading = true;
      });
      await ProfileMethods()
          .sendChangeEmailVerificationLink(
              newEmail: newEmail, password: password)
          .then((value) {
        _newEmailC.clear();
        _password.clear();
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      showCustomToast("An error occurred. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
              backgroundColor: appBarColor, title: "Change Email Address"),
          body: Column(
            children: [
              SizedBox(
                height: 50.h,
              ),
              homeCustomTextField(
                enable: false,
                controller: _emailC,
                labelText: 'Current email',
                icon: Icons.email,
                keyBoardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 20.h,
              ),
              homeCustomTextField(
                controller: _newEmailC,
                labelText: 'New email',
                icon: Icons.email,
                keyBoardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 20.h,
              ),
              homeCustomTextField(
                controller: _password,
                labelText: 'Enter password to change email',
                icon: Icons.lock,
                keyBoardType: TextInputType.text,
              ),
              SizedBox(
                height: 40.h,
              ),
              CustomButton(
                  onTap: _sendEmailVerifyLink,
                  width: 200.w,
                  height: 40.h,
                  text: "Change",
                  bgColor: Colors.blue)
            ],
          ),
        ),
        // showing a loaing bar if loading is true
        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }
}
