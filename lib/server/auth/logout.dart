import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/authSceens/login/onBoarding_screen.dart';

import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/sharedprefences/userPref.dart';

class LogoutMethod {
  Future<void> logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      UserPreferences.clearUserData();
      Get.offAll(() => const StartScreen());
      showCustomToast("You have been logged out");
    } catch (e) {
      showCustomToast("An error occurred while logging out");
    }
  }
}
