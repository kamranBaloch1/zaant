import 'package:flutter/material.dart';

import 'package:zaanth/server/home/enrollments_methods.dart';

class EnrollmentsProvider extends ChangeNotifier {
  final EnrollmentsMethods _enrollmentsMethods = EnrollmentsMethods();

  // Enroll a user to an instructor.
  Future<void> enrollUserToInstructorProvider({required String instructorId}) async {
    try {
      await _enrollmentsMethods.enrollUserToInstructor(instructorId: instructorId);
      notifyListeners();
    } catch (e) {
      print("Something went wrong $e");
    }
  }

  // Check enrollment status for a user and an instructor.
  Future<bool> checkEnrollmentStatusProvider({required String instructorId}) async {
    try {
      bool userEnrolled = await _enrollmentsMethods.checkEnrollmentStatus(instructorId: instructorId);
      return userEnrolled;
    } catch (e) {
      print("Something went wrong $e");
      return false; // Return false in case of an error
    }
  }

  // Unenroll a user from an instructor.
  Future<void> unenrollInstructorForUserProvider({required String instructorId}) async {
    try {
      await _enrollmentsMethods.unenrollInstructorForUser(instructorId: instructorId);
      notifyListeners();
    } catch (e) {
      print("Error unenrolling user. $e");
    }
  }

  // Unenroll a user from an instructor (instructor's perspective).
  Future<void> unenrollUserForInstructorProvider({required String userId}) async {
    try {
      await _enrollmentsMethods.unenrollUserForInstrcutor(userId: userId);
      notifyListeners();
    } catch (e) {
      print("Error unenrolling user. Please try again later. $e");
    }
  }
}
