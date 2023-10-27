import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zant/server/home/profile_methods.dart';

class ProfileProviders extends ChangeNotifier {
  final ProfileMethods _profileMethods = ProfileMethods();

  // Update user information provider method
  Future<void> updateUserInformationProvider(
      {required String name,
      required File? imageUrl,
      required String selectedCity,
      required String address}) async {
    try {
      // Call the corresponding method from the profile methods class
      await _profileMethods.updateUserInformation(
          name: name,
          imageUrl: imageUrl,
          selectedCity: selectedCity,
          address: address);

      // Notify any listeners (typically, UI widgets) that the data has changed
      notifyListeners();
    } catch (e) {
      // Show a custom toast message in case of an error
      print("An error occurred while updating the information");
    }
  }

  // provider for changing the password

  Future<void> changePasswordProvider(
      {required String currentPassword, required String newPassword}) async {
    try {
      await _profileMethods.changePassword(
          currentPassword: currentPassword, newPassword: newPassword);
      notifyListeners();
    } catch (e) {
      print("An error occurred while changing the password");
    }
  }
}
