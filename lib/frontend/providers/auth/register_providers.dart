import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/server/auth/register_method.dart';

class RegisterProviders extends ChangeNotifier {
  final RegisterMethod _registerMethod = RegisterMethod();

  // Method to register a new user with email and password
  Future<void> registerWithEmailAndPasswordProvider(
      String email,
      String password,
      String name,
      String gender,
      DateTime? dob,
      XFile photoUrl) async {
    try {
      await _registerMethod.registerWithEmailAndPassword(
          email, password, photoUrl, name, gender, dob);

      notifyListeners();
    } catch (e) {
      showCustomToast("An error occurred while creating an account.");
    }
  }

  // Method to update the user's account status
  Future<void> updateTheuserAccountStatusProvider() async {
    try {
      await _registerMethod.updateUserAccountStatus();

      notifyListeners();
    } catch (e) {
      showCustomToast("An error occurred.");
    }
  }
}
