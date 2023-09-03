import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/server/home/profile_methods.dart';

class ProfileProviders extends ChangeNotifier {
  final ProfileMethods _profileMethods = ProfileMethods();

  Future<void> updateUserInformationProvider(String name, File? imageUrl) async {
    try {
      await _profileMethods.updateUserInformation(name, imageUrl);

      notifyListeners();
    } catch (e) {
      showCustomToast("error occurred while updating the information");
    }
  }
}
