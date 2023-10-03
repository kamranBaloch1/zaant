import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/server/home/instructor_methods.dart';

class InstructorProviders extends ChangeNotifier {
  final InstructorMethods _instructorMethods = InstructorMethods();

  // Add an instructor
  Future<void> addInstructorProvider({
    required String phoneNumber,
    required String qualification,
    required List<String> subjects,
    required int feesPerHour,
    required Map<String, Map<String, Map<String, String>>>
        selectedTimingsForSubjects,
    required Map<String, List<String>> selectedDaysForSubjects,
  }) async {
    try {
      await _instructorMethods.addInstructor(
        phoneNumber: phoneNumber,
        qualification: qualification,
        subjects: subjects,
        feesPerHour: feesPerHour,
        selectedTimingsForSubjects: selectedTimingsForSubjects,
        selectedDaysForSubjects: selectedDaysForSubjects,
      );
      // Notify listeners to update UI
      notifyListeners();
    } catch (e) {
      // Handle error gracefully and show a custom toast
      showCustomToast("An error occurred while adding the instructor.");
    }
  }

  // Get a stream of instructors based on a query
  Stream<QuerySnapshot> getInstructorsStreamProvider({required String query}) {
    try {
      return _instructorMethods.getInstructorsStream(query: query);
    } catch (e) {
      // Handle error gracefully and show a custom toast
      showCustomToast("An error occurred.");
      return const Stream.empty();
    }
  }

  // Update instructor subjects days
  Future<void> updateInstrcutorSubjectsDaysProvider({
    required Map<String, List<String>> selectedDaysForSubjects,
  }) async {
    try {
      await _instructorMethods.updateInstrcutorSubjectsDays(
          selectedDaysForSubjects: selectedDaysForSubjects);
      notifyListeners();
    } catch (e) {
      showCustomToast("An error occurred while updating subjects' days.");
    }
  }

  // Update instructor subject timing
  Future<void> updateInstrcutorSubjectTimingProvider({
    required String subject,
    required Map<String, dynamic> newTimings,
  }) async {
    try {
      await _instructorMethods.updateInstrcutorSubjectTiming(
          subject: subject, newTimings: newTimings);
      notifyListeners();
    } catch (e) {
      showCustomToast("An error occurred while updating subject timing.");
    }
  }

  // Update instructor fees charges
  Future<void> updateInstrcutorFeesChargesProvider({required int feesPerHour}) async {
    try {
      await _instructorMethods.updateInstrcutorFeesCharges(
          feesPerHour: feesPerHour);
      notifyListeners();
    } catch (e) {
      showCustomToast("An error occurred while updating fees charges.");
    }
  }

  // Update instructor qualification
  Future<void> updateInstrcutorQualificationProvider(
      {required String qualification}) async {
    try {
      await _instructorMethods.updateInstrcutorQualification(
          qualification: qualification);
      notifyListeners();
    } catch (e) {
      showCustomToast("An error occurred while updating qualification.");
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
      showCustomToast("An error occurred while adding new subjects.");
    }
  }

  // Remove subjects
  Future<void> removeSubjectsProvider({
    required List<String> subjectsToRemove,
  }) async {
    try {
      await _instructorMethods.removeSubjects(subjectsToRemove: subjectsToRemove);
      notifyListeners();
    } catch (e) {
      showCustomToast("An error occurred while removing subjects.");
    }
  }
}





 // Future<void> sendVerificationCodeProvider({
  //   required  phoneNumber,
  //   required String qualification,
  //   // required String location,
  //   required List<String> subjects,
  //   required int feesPerHour,
  //   required Map<String, Map<String, Map<String, String>>> selectedTimingsForSubjects,
  //   required  Map<String, List<String>> selectedDaysForSubjects

  // }) async{
  //   try {
  //   await  _instructorMethods.sendVerificationCode(
  //         phoneNumber: phoneNumber,
  //         qualification: qualification,
  //         subjects: subjects,
  //         feesPerHour: feesPerHour,
  //         selectedTimingsForSubjects: selectedTimingsForSubjects,
  //        selectedDaysForSubjects:selectedDaysForSubjects 
  //        );

  //     notifyListeners();
  //   } catch (e) {
  //     showCustomToast("error accoured");
  //   }
  // }