
import 'package:flutter/material.dart';

import 'package:zaanth/server/home/instructor_methods.dart';

class InstructorProviders extends ChangeNotifier {
  final InstructorMethods _instructorMethods = InstructorMethods();

  // Add an instructor
  Future<void> addNewInstructorProvider({
    required String phoneNumber,
    required String qualification,
    required List<String> subjects,
    required int feesPerHour,
    required Map<String, Map<String, Map<String, String>>>
        selectedTimingsForSubjects,
    required Map<String, List<String>> selectedDaysForSubjects,
  }) async {
    try {
      await _instructorMethods.addNewInstructor(
        phoneNumber: phoneNumber,
        qualification: qualification,
        subjects: subjects,
        feesPerHour: feesPerHour,
        selectedTimingsForSubjects: selectedTimingsForSubjects,
        selectedDaysForSubjects: selectedDaysForSubjects,
      );
      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      // Handle errors gracefully and show a custom toast
      print("An error occurred while adding the instructor.");
    }
  }

  

  // Update instructor subjects' days
  Future<void> updateInstructorSubjectsDaysProvider({
    required Map<String, List<String>> selectedDaysForSubjects,
  }) async {
    try {
      await _instructorMethods.updateInstructorSubjectsDays(
          selectedDaysForSubjects: selectedDaysForSubjects);
      notifyListeners();
    } catch (e) {
      print("An error occurred while updating subjects' days.");
    }
  }

  // Update instructor subject timing
  Future<void> updateInstructorSubjectTimingProvider({
    required String subject,
    required Map<String, dynamic> newTimings,
  }) async {
    try {
      await _instructorMethods.updateInstructorSubjectTiming(
          subject: subject, newTimings: newTimings);
      notifyListeners();
    } catch (e) {
      print("An error occurred while updating subject timing.");
    }
  }

  // Update instructor fees charges
  Future<void> updateInstructorFeesChargesProvider(
      {required int feesPerHour}) async {
    try {
      await _instructorMethods.updateInstructorFeesCharges(
          feesPerHour: feesPerHour);
      notifyListeners();
    } catch (e) {
      print("An error occurred while updating fees charges.");
    }
  }

  // Update instructor qualification
  Future<void> updateInstructorQualificationProvider(
      {required String qualification}) async {
    try {
      await _instructorMethods.updateInstructorQualification(
          qualification: qualification);
      notifyListeners();
    } catch (e) {
      print("An error occurred while updating qualification.");
    }
  }

  // Add new subjects
  Future<void> addNewSubjectsProvider({
    required List<String> newSubjects,
    required Map<String, Map<String, Map<String, String>>>
        selectedTimingsForSubjects,
    required Map<String, List<String>> selectedDaysForSubjects,
  }) async {
    try {
      await _instructorMethods.addNewSubjects(
          newSubjects: newSubjects,
          selectedTimingsForSubjects: selectedTimingsForSubjects,
          selectedDaysForSubjects: selectedDaysForSubjects);
      notifyListeners();
    } catch (e) {
      print("An error occurred while adding new subjects.");
    }
  }

  // Remove subjects
  Future<void> removeSubjectsProvider({
    required List<String> subjectsToRemove,
  }) async {
    try {
      await _instructorMethods.removeSubjects(
          subjectsToRemove: subjectsToRemove);
      notifyListeners();
    } catch (e) {
      print("An error occurred while removing subjects.");
    }
  }

  // Add instructor review
  Future<void> addInstructorReviewProvider({
    required String instructorUid,
    required double ratings,
    required String content,
  }) async {
    try {
      await _instructorMethods.addInstructorReview(
          instructorUid: instructorUid, ratings: ratings, content: content);
      notifyListeners();
    } catch (e) {
      print("An error occurred while adding the review.");
    }
  }

  // Fetch reviews of an instructor
  Future<List<Map<String, dynamic>>> fetchReviewsOfInstructorProvider(
      {required String instructorUid}) async {
    try {
      final reviewsData = await _instructorMethods.fetchReviewsOfInstructor(
        instructorUid: instructorUid,
      );

      return reviewsData;
    } catch (e) {
      // Handle errors gracefully and show a custom toast
      print(
          "An error occurred while fetching reviews with user details: $e");
      return [];
    }
  }

// provider to add reviews reply

  Future<void> addInstructorReviewReplyProvider({
    required String instructorUid,
    required String reviewId,
    required String replyText,
  }) async {
   try {
      await _instructorMethods.addInstructorReviewReply(
        instructorUid: instructorUid, reviewId: reviewId, replyText: replyText);
        ChangeNotifier();
   } catch (e) {
       print("error accoured while adding reply text");
   }
  }


// Fetch reviews replies
  Future<List<Map<String, dynamic>>> fetchReviewsRepliesProvider(
    { required String instructorUid,
    required String reviewId}) async {
    try {
      final replyData = await _instructorMethods.fetchRepliesForReview(instructorUid: instructorUid, reviewId: reviewId);
      return replyData;
    } catch (e) {
      // Handle errors gracefully and show a custom toast
      print(
          "An error occurred while fetching reviews: $e");
      return [];
    }
  }



//  provider to delete reviews reply
Future<void> deleteReviewReplyProvider({
  required String instructorUid,
  required String reviewId,
  required String replyId,
})async{
 try {
      await _instructorMethods.deleteReviewReply(instructorUid: instructorUid, reviewId: reviewId, replyId: replyId);
        ChangeNotifier();
   } catch (e) {
     print("error accoured while deleting reply text");
   }
}





// provider to verfiy the phone number method

  Future<void> verifyPhoneNumberProvider({
    required String? phoneNumber,
    required String? selectedQualification,
    required int? feesPerHour,
  }) async {
    try {
      await _instructorMethods.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          selectedQualification: selectedQualification,
          feesPerHour: feesPerHour);

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      // Handle errors gracefully and show a custom toast
      print("An error occurred during phone number verification.");
    }
  }

  // provider to verfiy the phone number otp code method

  Future<bool> verifyOTPProvider({
    required String? phoneNumberVerificationId,
    required String? otp,
    required String? phoneNumber,
  }) async {
    try {
      bool isVerified = await _instructorMethods.verifyOTP(
        phoneNumberVerificationId: phoneNumberVerificationId,
        otp: otp,
        phoneNumber: phoneNumber,
      );

      // Notify listeners to update the UI
      notifyListeners();

      return isVerified;
    } catch (e) {
      // Handle errors gracefully and show a custom toast
      print("An error occurred during OTP verification.");
      return false;
    }
  }
}
