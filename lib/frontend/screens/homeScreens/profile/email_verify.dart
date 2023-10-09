// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/profile/profile_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/server/home/profile_methods.dart';

class ProfileEmailVerificationScreen extends StatefulWidget {
  final String? email;
  const ProfileEmailVerificationScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _ProfileEmailVerificationScreenState createState() =>
      _ProfileEmailVerificationScreenState();
}

class _ProfileEmailVerificationScreenState
    extends State<ProfileEmailVerificationScreen> {
  @override
  void initState() {
    super.initState();
    _checkEmailVerificationStatus();
  }

  bool _isLoading = false;

  // Check if the email has been verified
  Future<void> _checkEmailVerificationStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    // Reload the user to get the latest data
    await user?.reload();

    if (user?.emailVerified ?? false) {
      setState(() {
        _isLoading = true;
      });

      // final registerProvider = Provider.of<RegisterProviders>(context, listen: false);

      try {
        // Call the provider method asynchronously
        await ProfileMethods().chnageUserEmail(newEmail: widget.email!);
      } catch (e) {
        showCustomToast("Error accoured");
      } finally {
        setState(() {
          _isLoading = false;
        });
        showCustomToast("Email changed sucessfully");
        Get.offAll(() => const ProfileScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Please verify your email',
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: 20.h,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Refresh the email verification status
                    await FirebaseAuth.instance.currentUser?.reload();
                    await _checkEmailVerificationStatus();
                  },
                  child: const Text('Refresh'),
                ),
              ],
            ),
          ),
        ),
        // showing a loading overlay if loading is true
        if (_isLoading) const CustomLoadingOverlay(),
      ],
    );
  }
}
