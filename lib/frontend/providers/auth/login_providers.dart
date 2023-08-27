import 'package:flutter/foundation.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/server/auth/login_methods.dart';

class LoginProviders extends ChangeNotifier {
  final LoginMethods _loginMethods = LoginMethods();

  // Method to handle user login with email and password
  Future<void> loginWithEmailAndPasswordProvider(
      String email, String password) async {
    try {
      await _loginMethods.loginWithEmailAndPassword(email, password);
      notifyListeners();
    } catch (e) {
      showCustomToast("An error occurred. Please try again.");
    }
  }

  // Method to reset user password
  Future<void> resetUserPasswordProvider(String email) async {
    try {
      await _loginMethods.resetUserPassword(email);
      notifyListeners();
    } catch (e) {
      showCustomToast("An error occurred. Please try again.");
    }
  }
}
