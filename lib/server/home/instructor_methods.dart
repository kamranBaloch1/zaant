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
    required String address,
  }) async {
    try {
      // Get the current user's UID
      String uid = FirebaseAuth.instance.currentUser!.uid;
     

      // Reference to the user document
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection(userCollection).doc(uid);

      // Check if the user document with the UID exists
      DocumentSnapshot userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        throw Exception("User document not found.");
      }

      // Create an InstructorModel instance
      InstructorModel instructorModel = InstructorModel(
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
          enrollments: []);

      // Add the instructor model to Firestore
      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(uid)
          .collection(instructorsCollections)
          .doc(uid)
          .set(instructorModel.toMap());

      // creating an instructor collection
      await FirebaseFirestore.instance
          .collection(instructorsCollections)
          .doc(uid)
          .set(instructorModel.toMap());

      // Update user document with instructor information
      await userDocRef.update({
        "accountType": AccountTypeEnum.instructor.value,
        "phoneNumber": phoneNumber,
        "isPhoneNumberVerified": false,
        "location": address,
      });

      // Update SharedPreferences
      await UserPreferences.setAccountType(
          AccountTypeEnum.instructor.toString().split('.').last);
      await UserPreferences.setPhoneNumber(phoneNumber);
      await UserPreferences.setIsPhoneNumberVerified(true);
      await UserPreferences.setLocation(address);

      // Display a success message
      showCustomToast("You have successfully become an instructor");

      // Navigate to the HomeScreen
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      // Handle errors gracefully
      showCustomToast(
          "An error occurred while becoming an instructor. Please try again later.");
    }
  }

  // getting the instructor collection to fecth the info in search screen

  Stream<QuerySnapshot> getInstructorsStream({required String query}) {
    try {
      // Create a Firestore query based on the location and city queries
      final queryText = query.toLowerCase();
      final queryRef = FirebaseFirestore.instance
          .collection(instructorsCollections)
          .where('location', isGreaterThanOrEqualTo: queryText)
          .where('location', isLessThan: '${queryText}z');

      return queryRef.snapshots();
    } catch (e) {
      // Handle the error (e.g., print it to the console)
      print('Error in getInstructorsStream: $e');
      showCustomToast(e.toString());
      // Return an empty stream or handle the error as needed
      return const Stream.empty();
    }
  }

  /// code for fecting the user data in  instructor details screen

  Future<Map<String, dynamic>> fetchUserDataForInstrcutorDetailScreen(
      {required String uid}) async {
    final userCollectionDoc =
        FirebaseFirestore.instance.collection(userCollection);
    final userDoc = await userCollectionDoc.doc(uid).get();

    if (userDoc.exists) {
      // Document exists, return its data as a Map.
      return userDoc.data() as Map<String, dynamic>;
    } else {
      // Document does not exist.
      return {}; // You can handle this case as needed.
    }
  }
}

 
 


 
 
 
 
 
 
 
 
 // Future<void> sendVerificationCode({
  //   required String phoneNumber,
  //   required String qualification,
  //   // required String location,
  //   required List<String> subjects,
  //   required int feesPerHour,
  //   required Map<String, Map<String, Map<String, String>>> selectedTimingsForSubjects,
  //   required  Map<String, List<String>> selectedDaysForSubjects
    
  
  // }) async {
  //   try {
  //     // Send a verification code to the new phone number
  //     String number = "+92$phoneNumber";
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: number,
  //       verificationCompleted: (PhoneAuthCredential credential) {
  //         // Verification completed automatically (optional).
  //         // You can proceed with updating the user's phone number.
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         // Handle verification failure, e.g., invalid phone number format.
  //         showCustomToast("unable to send the verification code number $number $e ");
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         // Save the verification ID and redirect the user to the verification screen.
  //         Get.offAll(() => PhoneOTPVerificationScreen(
  //             verificationId: verificationId,
  //             selectedSubjects: subjects,
  //             selectedQualification: qualification,
  //             feesPerHour: feesPerHour,
  //             phoneNumber: phoneNumber,
  //             selectedTimingsForSubjects: selectedTimingsForSubjects,
  //             selectedDaysForSubjects: selectedDaysForSubjects,
  //             ));
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         // Auto-retrieval timeout, if needed.
  //         showCustomToast("verification code is been expired");
  //       },
  //     );
  //   } catch (e) {
  //     // Handle errors, e.g., unable to send the verification code.
  //     showCustomToast("Error verifying phone number: $e");
  //   }
  // }
