import 'package:flutter/material.dart';

import 'package:zaanth/server/home/instructor_methods.dart';

class InstructorProviders extends ChangeNotifier {
  final InstructorMethods _instructorMethods = InstructorMethods();

  // Add an instructor
  Future<void> addNewInstructorProvider({
    required String phoneNumber,
    required String qualification,
    required List<String> subjects,
    required int feesPerMonth,
    required Map<String, Map<String, Map<String, String>>>
        selectedTimingsForSubjects,
    required Map<String, List<String>> selectedDaysForSubjects,
    required List<String>? selectedGrades,
    required List<String>? selectedSyllabusTypes,
    required String address,
    required String teachingExperience,
    required String tuitionType,
    required String degreeCompletionStatus,
  }) async {
    try {
      await _instructorMethods.addNewInstructor(
          phoneNumber: phoneNumber,
          qualification: qualification,
          subjects: subjects,
          feesPerMonth: feesPerMonth,
          selectedTimingsForSubjects: selectedTimingsForSubjects,
          selectedDaysForSubjects: selectedDaysForSubjects,
          selectedGrades: selectedGrades,
          selectedSyllabusTypes: selectedSyllabusTypes,
          address: address,
          teachingExperience: teachingExperience,
          tuitionType: tuitionType,
          degreeCompletionStatus: degreeCompletionStatus
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
      {required int feesPerMonth}) async {
    try {
      await _instructorMethods.updateInstructorFeesCharges(
          feesPerMonth: feesPerMonth);
      notifyListeners();
    } catch (e) {
      print("An error occurred while updating fees charges.");
    }
  }
  // Update instructor teaching Experience
  Future<void> updateTeachingExperienceProvider(
      {required String teachingExperience}) async {
    try {
      await _instructorMethods.updateTeachingExperience(
          teachingExperience: teachingExperience);
      notifyListeners();
    } catch (e) {
      print("An error occurred while updating teaching experience.");
    }
  }

  // Update instructor qualification
  Future<void> updateInstructorQualificationProvider(
      {required String qualification, required String degreeCompletionStatus})async {
    try {
      await _instructorMethods.updateInstructorQualification(
          qualification: qualification,degreeCompletionStatus: degreeCompletionStatus);
      notifyListeners();
    } catch (e) {
      print("An error occurred while updating qualification.");
    }
  }
  // Update instructor tuition type
  Future<void> updateInstructorTuitionTypeProvider(
      {required String tuitionType})async {
    try {
      await _instructorMethods.updateInstructorTuitionType(
         tuitionType: tuitionType);
      notifyListeners();
    } catch (e) {
      print("An error occurred while updating tuition type.");
    }
  }
  
  // Update instructor address
  Future<void> updateInstructorAddressProvider(
      {required String address})async {
    try {
      await _instructorMethods.updateInstructorAddress(
         address: address);
      notifyListeners();
    } catch (e) {
      print("An error occurred while updating address");
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
      print("An error occurred while fetching reviews with user details: $e");
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
          instructorUid: instructorUid,
          reviewId: reviewId,
          replyText: replyText);
      ChangeNotifier();
    } catch (e) {
      print("error accoured while adding reply text");
    }
  }

// Fetch reviews replies
  Future<List<Map<String, dynamic>>> fetchReviewsRepliesProvider(
      {required String instructorUid, required String reviewId}) async {
    try {
      final replyData = await _instructorMethods.fetchRepliesForReview(
          instructorUid: instructorUid, reviewId: reviewId);
      return replyData;
    } catch (e) {
      // Handle errors gracefully and show a custom toast
      print("An error occurred while fetching reviews: $e");
      return [];
    }
  }

//  provider to delete reviews reply
  Future<void> deleteReviewReplyProvider({
    required String instructorUid,
    required String reviewId,
    required String replyId,
  }) async {
    try {
      await _instructorMethods.deleteReviewReply(
          instructorUid: instructorUid, reviewId: reviewId, replyId: replyId);
      ChangeNotifier();
    } catch (e) {
      print("error accoured while deleting reply text");
    }
  }

// provider to verfiy the phone number method

  Future<void> verifyPhoneNumberProvider({
    required String? phoneNumber,
    required String? selectedQualification,
    required String? teachingExperience,
    required String? tuitionType,
    required int? feesPerMonth,
    required String? degreeCompletionStatus,
  }) async {
    try {
      await _instructorMethods.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          selectedQualification: selectedQualification,
          feesPerMonth: feesPerMonth,
          teachingExperience: teachingExperience,
          tuitionType: tuitionType,
          degreeCompletionStatus: degreeCompletionStatus
          );

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

// provider for removing instructor selected grades
  Future<void> removeSelectedGradesProvider(
      {required List<String> selectedGrades}) async {
    try {
      await _instructorMethods.removeSelectedGrades(
          selectedGrades: selectedGrades);
      ChangeNotifier();
    } catch (e) {
      print("Error removing grades");
    }
  } 
  
  // provider for updating instructor selected grades

  Future<void> updateSelectedGradesProvider(
      {required List<String> selectedNewGrades}) async {
    try {
      await _instructorMethods.updateSelectedGrades(
          selectedNewGrades: selectedNewGrades);
      ChangeNotifier();
    } catch (e) {
      print("Error adding grades");
    }
  }
// provider for removing instructor selected syllabus types
  Future<void> removeSelectedSyllabusTypesProvider(
      {required List<String> selectedSyllabusTypes}) async {
    try {
      await _instructorMethods.removeSelectedSyllabusTypes(
          selectedSyllabusTypes: selectedSyllabusTypes);
      ChangeNotifier();
    } catch (e) {
      print("Error removing syllabus types");
    }
  } 
  
  // provider for updating instructor selected grades
  
  Future<void> updateSelectedSyllabusTypesProvider(
      {required List<String> selectedSyllabusTypes}) async {
    try {
      await _instructorMethods.updateSelectedSyllabusTypes(
          selectedNewSyllabusTypes: selectedSyllabusTypes);
      ChangeNotifier();
    } catch (e) {
      print("Error adding syllabus types");
    }
  }





}
