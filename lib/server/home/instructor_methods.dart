import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/models/home/instructor_model.dart';
import 'package:zant/enum/account_type.dart';
import 'package:zant/frontend/screens/homeScreens/home/home_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/firebase_collection_names.dart';
import 'package:zant/sharedprefences/userPref.dart';

class InstructorMethods {
  // Function to add an instructor
  Future<void> addInstructor({
    required String phoneNumber,
    required String qualification,
    required List<String> subjects,
    required int feesPerHour,
    required Map<String, Map<String, Map<String, String>>>
        selectedTimingsForSubjects,
    required Map<String, List<String>> selectedDaysForSubjects,
  }) async {
    try {
      // Get the current user's information
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not authenticated.");
      }

      final uid = user.uid;
      final name = UserPreferences.getName() ?? "";
      final city = UserPreferences.getCity() ?? "";
      final profilePicUrl = UserPreferences.getProfileUrl() ?? "";
      final gender = UserPreferences.getGender() ?? "";
      final address = UserPreferences.getAddress() ?? "";

      // Reference to the user document
      final userDocRef = FirebaseFirestore.instance.collection(userCollection).doc(uid);

      // Check if the user document with the UID exists
      final userDoc = await userDocRef.get();
      if (!userDoc.exists) {
        throw Exception("User document not found.");
      }

      // Create an InstructorModel instance
      final instructorModel = InstructorModel(
        uid: uid,
        phoneNumber: phoneNumber,
        isPhoneNumberVerified: false,
        qualification: qualification,
        feesPerHour: feesPerHour,
        reviews: [],
        ratings: 0,
        subjects: subjects,
        selectedTimingsForSubjects: selectedTimingsForSubjects,
        accountType: AccountTypeEnum.instructor,
        createdOn: Timestamp.fromDate(DateTime.now()),
        selectedDaysForSubjects: selectedDaysForSubjects,
        enrollments: [],
        address: address,
        city: city,
        name: name,
        profilePicUrl: profilePicUrl,
        gender: gender,
      );

      // Add the instructor model to Firestore
      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(uid)
          .collection(instructorsCollections)
          .doc(uid)
          .set(instructorModel.toMap());

      // Create an instructor collection
      await FirebaseFirestore.instance
          .collection(instructorsCollections)
          .doc(uid)
          .set(instructorModel.toMap());

      // Update user document with instructor information
      await userDocRef.update({
        "accountType": AccountTypeEnum.instructor.value,
        "phoneNumber": phoneNumber,
        "isPhoneNumberVerified": false,
      });

      // Update SharedPreferences
      await UserPreferences.setAccountType(AccountTypeEnum.instructor.toString().split('.').last);
      await UserPreferences.setPhoneNumber(phoneNumber);
      await UserPreferences.setIsPhoneNumberVerified(true);

      // Display a success message
      showCustomToast("You have successfully become an instructor");

      // Navigate to the HomeScreen
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      // Handle errors gracefully
      showCustomToast("An error occurred while becoming an instructor. Please try again later.");
    }
  }

  // Getting the instructor collection to fetch the info in the search screen
  Stream<QuerySnapshot> getInstructorsStream({required String query}) {
    try {
      // Create a Firestore query based on the location query
      final queryText = query.toLowerCase();
      final queryRef = FirebaseFirestore.instance
          .collection(instructorsCollections)
          .where('address', isGreaterThanOrEqualTo: queryText)
          .where('address', isLessThan: '${queryText}z');

      return queryRef.snapshots();
    } catch (e) {
      // Handle the error and return an empty stream or handle the error as needed
      print('Error in getInstructorsStream: $e');
      showCustomToast(e.toString());
      return const Stream.empty();
    }
  }
}
