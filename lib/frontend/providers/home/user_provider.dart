

import 'package:flutter/material.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/server/home/user_methods.dart';

class UserProviders extends ChangeNotifier {


    final UserMethods _userMethods =  UserMethods();


     Future<void> enrollUserToInstructorProvider({required String instructorId})async{
       try {

         await _userMethods.enrollUserToInstructor(instructorId: instructorId);
          notifyListeners();
         
       } catch (e) {
           showCustomToast("something went wrong");
       }
     }

// Add a method to check enrollment status
  Future<bool> checkEnrollmentStatusProvider({required String instructorId}) async {
    try {
      bool userEnrolled = await _userMethods.checkEnrollmentStatus(instructorId: instructorId);
      return userEnrolled;
    } catch (e) {
      showCustomToast("Something went wrong");
      return false; // Return false in case of an error
    }
  }




}