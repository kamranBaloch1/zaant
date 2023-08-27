import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:zant/frontend/providers/auth/register_providers.dart';
import 'package:zant/frontend/screens/homeScreens/home.dart';

import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';


class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
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

    final registerProvider = Provider.of<RegisterProviders>(context, listen: false);

    try {
      // Call the provider method asynchronously
      await registerProvider.updateTheuserAccountStatusProvider();
    } catch (e) {
      showCustomToast("Error accoured");
    } finally {
      setState(() {
        _isLoading = false;
      });
      showCustomToast("Email is verified");
        Get.offAll(() => const HomeScreen());
      
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
