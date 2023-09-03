import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/models/home/instructor_model.dart';
import 'package:zant/enum/account_type.dart';
import 'package:zant/frontend/screens/homeScreens/home/home_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/firebase_collection_names.dart';
import 'package:zant/sharedprefences/userPref.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/phone_otp_verify_screen.dart';

class InstructorMethods {
  Future<void> sendVerificationCode({
    required int phoneNumber,
    required String qualification,
    // required String location,
    required List<String> subjects,
    required int feesPerHour,
    required Map<String, Map<String, String>> subjectTimings,
  
  }) async {
    try {
      // Send a verification code to the new phone number
      String number = "+92$phoneNumber";
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Verification completed automatically (optional).
          // You can proceed with updating the user's phone number.
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure, e.g., invalid phone number format.
          showCustomToast("unable to send the verification code number $number $e ");
        },
        codeSent: (String verificationId, int? resendToken) {
          // Save the verification ID and redirect the user to the verification screen.
          Get.offAll(() => PhoneOTPVerificationScreen(
              verificationId: verificationId,
              selectedSubjects: subjects,
              selectedQualification: qualification,
              feesPerHour: feesPerHour,
              phoneNumber: phoneNumber,
              availableTimings: subjectTimings));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout, if needed.
          showCustomToast("verification code is been expired");
        },
      );
    } catch (e) {
      // Handle errors, e.g., unable to send the verification code.
      showCustomToast("Error verifying phone number: $e");
    }
  }

  Future<void> addInstructor({
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
      String uid = FirebaseAuth.instance.currentUser!.uid;
      InstructorModel instructorModel = InstructorModel(
        uid: uid,
        phoneNumber: phoneNumber,
        isPhoneNumberVerified: true,
        qualification: qualification,
        location: "",
        feesPerHour: feesPerHour,
        reviews: [],
        ratings: 0,
        subjects: subjects,
        availableTimings: availableTimings,
        accountType: AccountTypeEnum.instructor,
        createdOn: Timestamp.fromDate(DateTime.now()),
      );

      // Create a PhoneAuthCredential using the verification ID and code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: verificationCode,
      );

      // Sign in with the credential (this will verify the phone number)
      await FirebaseAuth.instance.signInWithCredential(credential);

      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(uid)
          .collection(instructorsCollections)
          .doc(uid)
          .set(instructorModel.toMap());

      // Updating the user account type from users collection
      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(uid)
          .update({
        "accountType": AccountTypeEnum.instructor.value,
        "phoneNumber": phoneNumber,
        "isPhoneNumberVerified": true
      });

      // Updating the user account type in SharedPreferences
      await UserPreferences.setAccountType(
          AccountTypeEnum.instructor.toString().split('.').last);
      await UserPreferences.setPhoneNumber(phoneNumber.toString());
      await UserPreferences.setIsPhoneNumberVerified(true);
      showCustomToast("You have become an instructor");
     Future.delayed(const Duration(seconds: 3),() {
          Get.offAll(() => const HomeScreen());
     },);
   
    } catch (e) {
      showCustomToast("An error occurred. Please try again");
    }
  }
}
