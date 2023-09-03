// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:zant/frontend/screens/homeScreens/home/home_screen.dart';
// import 'package:zant/frontend/screens/widgets/custom_toast.dart';
// import 'package:zant/frontend/screens/homeScreens/instructor/phone_otp_verify_screen.dart';
// import 'package:zant/server/home/instructor_methods.dart';

// class PhoneNumberVerificationMethods {
//   // Inside your AccountMethods class, add a method to send a verification code.
//   Future<void> sendVerificationCode(String phoneNumber) async {
//     try {
//       // Send a verification code to the new phone number
//       await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) {
//           // Verification completed automatically (optional).
//           // You can proceed with updating the user's phone number.
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           // Handle verification failure, e.g., invalid phone number format.
//           showCustomToast("unable to send the verification code $e");
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           // Save the verification ID and redirect the user to the verification screen.
//           Get.offAll(() => PhoneOTPVerificationScreen(
//                 verificationId: verificationId,
//                 phoneNumber: phoneNumber,
//               ));
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           // Auto-retrieval timeout, if needed.
//           showCustomToast("verification code is been expired");
//         },
//       );
//     } catch (e) {
//       // Handle errors, e.g., unable to send the verification code.
//       showCustomToast("Error verifying phone number: $e");
//     }
//   }

//   Future<void> verifyCode(
//       {
//       required String verificationCode,
//       required String verificationId,
//       required int phoneNumber,
//       required String qualification,
//       required List<String> subjects,
//       required int feesPerHour,
//       required Map<String, Map<String, String>> availableTimings}) async {
//     try {
//       // Create a PhoneAuthCredential using the verification ID and code
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: verificationCode,
//       );

//       // Sign in with the credential (this will verify the phone number)
//       await FirebaseAuth.instance.signInWithCredential(credential);

//       await InstructorMethods().addInstructor(
//           phoneNumber: phoneNumber,
//           qualification: qualification,
//           subjects: subjects,
//           feesPerHour: feesPerHour,
//           availableTimings: availableTimings);

   
//     } catch (e) {
//       // Handle verification failure, e.g., incorrect code.
//       showCustomToast(" verification failure $e");
//     }
//   }
// }
