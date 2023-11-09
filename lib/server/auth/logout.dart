import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:zaanth/frontend/screens/authSceens/splash/splash_screen.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/sharedprefences/userPref.dart';

class LogoutMethod {
  Future<void> logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      UserPreferences.clearUserData();
      Get.offAll(() => const SplashScreen());
      showCustomToast("You have been logged out");
    } catch (e) {
      showCustomToast("An error occurred while logging out");
    }
  }
}
