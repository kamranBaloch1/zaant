
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/server/home/instructor_methods.dart';

class InstructorProviders extends ChangeNotifier {
  final InstructorMethods _instructorMethods = InstructorMethods();

  Future<void> addInstructorProvider({
    required String phoneNumber,
    required String qualification,
    required List<String> subjects,
    required int feesPerHour,
    required Map<String, Map<String, Map<String, String>>> selectedTimingsForSubjects,
    required Map<String, List<String>> selectedDaysForSubjects,
    required String city, 
    required String address, 
  
  }) async {
    try {
      // Call the instructorMethods to add an instructor
      await _instructorMethods.addInstructor(
        phoneNumber: phoneNumber,
        qualification: qualification,
        // location: location,
        subjects: subjects,
        feesPerHour: feesPerHour,
        selectedTimingsForSubjects: selectedTimingsForSubjects,
        selectedDaysForSubjects: selectedDaysForSubjects,
        address: address,
        city: city
      );

      // Notify listeners to update UI
      notifyListeners();
    } catch (e) {
      // Display a user-friendly error message
      showCustomToast("an error occurred while adding the instructor.");
    }
  }
  
Stream<QuerySnapshot> getInstructorsStreamProvider({required String query})  {
  try {
    return  _instructorMethods.getInstructorsStream(query: query);
  } catch (e) {
     showCustomToast("an error occurred");
    return const Stream.empty();
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