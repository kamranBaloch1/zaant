import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zaanth/frontend/providers/home/profile_providers.dart';
import 'package:zaanth/frontend/screens/authSceens/authWidgets/custom_auth_field.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isLoading = false;
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  bool _isObscure3 = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmNewPassword = TextEditingController();

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks.
    super.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmNewPassword.dispose();
  }

  void _changePassword() async {
    try {
      setState(() {
        _isLoading = true;
      });

      String currentPassword = _currentPassword.text.trim();
      String newPassword = _newPassword.text.trim();

      final profileProvider =
          Provider.of<ProfileProviders>(context, listen: false);

      await profileProvider
          .changePasswordProvider(
              currentPassword: currentPassword, newPassword: newPassword)
          .then((value) {
        // Clear password fields on success
        _currentPassword.clear();
        _newPassword.clear();
        _confirmNewPassword.clear();
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
          appBar: const CustomAppBar(
            backgroundColor: appBarColor,
            title: "Change password",
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                CustomAuthTextField(
                  hintText: "Current password",
                  icon: IconButton(
                    icon: Icon(
                        _isObscure1 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure1 = !_isObscure1;
                      });
                    },
                  ),
                  obSecure: _isObscure1,
                  keyBoardType: TextInputType.text,
                  controller: _currentPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 8) {
                      return 'Password must be more than 8 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomAuthTextField(
                  hintText: "New password",
                  icon: IconButton(
                    icon: Icon(
                        _isObscure2 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure2 = !_isObscure2;
                      });
                    },
                  ),
                  obSecure: _isObscure2,
                  keyBoardType: TextInputType.text,
                  controller: _newPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 8) {
                      return 'Password must be more than 8 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomAuthTextField(
                  hintText: "Retype new password",
                  icon: IconButton(
                    icon: Icon(
                        _isObscure3 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure3 = !_isObscure3;
                      });
                    },
                  ),
                  obSecure: _isObscure3,
                  keyBoardType: TextInputType.text,
                  controller: _confirmNewPassword,
                  validator: (value) {
                    if (value != _newPassword.text.trim()) {
                      return "Password doesn't match the new password";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 40.h,
                ),
                CustomButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _changePassword();
                    }
                  },
                  width: 200.w,
                  height: 40.h,
                  text: "Change",
                  bgColor: Colors.blue,
                ),
              ],
            ),
          ),
        ),
        // Show a loading overlay if isLoading is true.
        if (_isLoading) const CustomLoadingOverlay(),
      ],
    );
  }
}
