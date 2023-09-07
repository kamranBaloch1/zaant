import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/server/home/profile_methods.dart';

class ProfileProviders extends ChangeNotifier {
  final ProfileMethods _profileMethods = ProfileMethods();

  // Update user information provider method
  Future<void> updateUserInformationProvider(String name, File? imageUrl) async {
    try {
      // Call the corresponding method from the profile methods class
      await _profileMethods.updateUserInformation(name, imageUrl);

      // Notify any listeners (typically, UI widgets) that the data has changed
      notifyListeners();
    } catch (e) {
      // Show a custom toast message in case of an error
      showCustomToast("An error occurred while updating the information");
    }
  }
}
