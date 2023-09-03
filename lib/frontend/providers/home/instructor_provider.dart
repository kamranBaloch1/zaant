
import 'package:flutter/material.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/server/home/instructor_methods.dart';

class InstructorProviders extends ChangeNotifier {
  final InstructorMethods _instructorMethods = InstructorMethods();

  Future<void> sendVerificationCodeProvider({
    required int phoneNumber,
    required String qualification,
    // required String location,
    required List<String> subjects,
    required int feesPerHour,
    required Map<String, Map<String, String>> subjectTimings,
  }) async{
    try {
    await  _instructorMethods.sendVerificationCode(
          phoneNumber: phoneNumber,
          qualification: qualification,
          subjects: subjects,
          feesPerHour: feesPerHour,
          subjectTimings: subjectTimings,
         
         );

      notifyListeners();
    } catch (e) {
      showCustomToast("error accoured");
    }
  }

  Future<void> addInstructorProvider({
    required int phoneNumber,
    required String qualification,
    // required String location,
    required List<String> subjects,
    required int feesPerHour,
    required Map<String, Map<String, String>> availableTimings,
    required String verificationCode,
    required String verificationId,
  }) async {
    try {
      await _instructorMethods.addInstructor(
          phoneNumber: phoneNumber,
          qualification: qualification,
          // location: location,
          subjects: subjects,
          feesPerHour: feesPerHour,
          availableTimings: availableTimings,
          verificationCode: verificationCode,
          verificationId: verificationId);

      notifyListeners();
    } catch (e) {
      showCustomToast("error accoured");
    }
  }
}
