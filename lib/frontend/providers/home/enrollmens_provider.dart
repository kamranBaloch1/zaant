import 'package:flutter/material.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/server/home/enrollments_methods.dart';

class EnrollmentsProvider extends ChangeNotifier {
  final EnrollmentsMethods _enrollmentsMethods = EnrollmentsMethods();

  // Enroll a user to an instructor.
  Future<void> enrollUserToInstructorProvider({required String instructorId}) async {
    try {
      await _enrollmentsMethods.enrollUserToInstructor(instructorId: instructorId);
      notifyListeners();
    } catch (e) {
      showCustomToast("Something went wrong");
    }
  }

  // Check enrollment status for a user and an instructor.
  Future<bool> checkEnrollmentStatusProvider({required String instructorId}) async {
    try {
      bool userEnrolled = await _enrollmentsMethods.checkEnrollmentStatus(instructorId: instructorId);
      return userEnrolled;
    } catch (e) {
      showCustomToast("Something went wrong");
      return false; // Return false in case of an error
    }
  }

  // Unenroll a user from an instructor.
  Future<void> unenrollInstructorForUserProvider({required String instructorId}) async {
    try {
      await _enrollmentsMethods.unenrollInstructorForUser(instructorId: instructorId);
      notifyListeners();
    } catch (e) {
      showCustomToast("Error unenrolling user. Please try again later.");
    }
  }

  // Unenroll a user from an instructor (instructor's perspective).
  Future<void> unenrollUserForInstructorProvider({required String userId}) async {
    try {
      await _enrollmentsMethods.unenrollUserForInstrcutor(userId: userId);
      notifyListeners();
    } catch (e) {
      showCustomToast("Error unenrolling user. Please try again later.");
    }
  }
}
