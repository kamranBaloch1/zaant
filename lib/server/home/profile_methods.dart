import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/profile/number_otp_verify_screen.dart';
import 'package:zant/frontend/screens/homeScreens/profile/profile_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/firebase_collection_names.dart';
import 'package:zant/sharedprefences/userPref.dart';

class ProfileMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Upload image to Firebase Storage and return download URL
  Future<String?> uploadImageToStorage(File? photoUrl) async {
    try {
      if (photoUrl == null) {
        return null; // Return null when photoUrl is null
      }

      // Generate a unique image ID based on the current timestamp
      String imgId = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child(usersProfileImages).child(imgId);

      TaskSnapshot snapshot = await ref.putFile(photoUrl);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      // Handle errors gracefully
      throw 'Image upload failed: $e';
    }
  }

  // Update user information in Firestore and SharedPreferences
  Future<void> updateUserInformation(
      {required String name,
      required File? imageUrl,
      required String selectedCity,
      required String address}) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Upload image and get download URL if imageUrl is not null
      String? downloadUrl;
      if (imageUrl != null) {
        downloadUrl = await uploadImageToStorage(imageUrl);
      }

      // Prepare data to be updated in Firestore
      Map<String, dynamic> updateData = {
        'name': name,
        'city': selectedCity,
        'address': address,
      };

      if (downloadUrl != null) {
        updateData["profilePicUrl"] = downloadUrl;
      }

      // Check if the uid exists in the instructorsCollections collection
      DocumentSnapshot<Map<String, dynamic>> instructorsSnapshot =
          await FirebaseFirestore.instance
              .collection(instructorsCollections)
              .doc(uid)
              .get();

      // Update user information in userCollection
      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(uid)
          .update(updateData);

      // If the uid exists in instructorsCollections, also update the document there
      if (instructorsSnapshot.exists) {
        await FirebaseFirestore.instance
            .collection(instructorsCollections)
            .doc(uid)
            .update(updateData);
      }

      // Update user information in SharedPreferences
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection(userCollection)
          .doc(uid)
          .get();

      if (snapshot.exists) {
        // Update local variables with data from Firestore
        Map<String, dynamic> userData = snapshot.data()!;

        UserPreferences.setName(userData['name']);
        UserPreferences.setProfileUrl(userData['profilePicUrl']);
        UserPreferences.setCity(userData['city']);
        UserPreferences.setAddress(userData['address']);
      }

      // Show a success message
      showCustomToast("User information updated successfully");
      Get.offAll(() => const ProfileScreen());
    } catch (e) {
      // Show an error message
      showCustomToast("An error occurred while updating the information");
    }
  }

  // Step 1: Send OTP for phone number verification
  Future<void> verifyPhoneNumber({required String? phoneNumber}) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Verification is completed automatically (rare scenario)
          // Implement if needed
        },
        verificationFailed: (FirebaseAuthException e) {
          String errorMessage;
          if (e.code == 'invalid-phone-number') {
            errorMessage = 'Invalid phone number';
          } else if (e.code == 'too-many-requests') {
            errorMessage = 'Phone number blocked due to too many requests';
          } else {
            errorMessage =
                'Phone Number Verification Failed, please check the number';
          }
          showCustomToast(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to OTP screen when code is sent
          Get.offAll(() => NumberOtpVerifyScreen(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout for code retrieval
          showCustomToast('Code retrieval timed out');
          // Implement additional actions if needed
        },
        timeout: const Duration(minutes: 2), // Timeout for the code to be sent
      );
    } catch (e) {
      showCustomToast("Error sending OTP");
    }
  }

  // Step 2: Verify the OTP code
Future<bool> verifyOTP({
  required String? phoneNumberVerificationId,
  required String? otp,
  required String? phoneNumber,
}) async {
  try {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      showCustomToast("User not signed in.");
      return false;
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId:
          phoneNumberVerificationId!, // Ensure you have the correct verificationId here
      smsCode: otp!,
    );

    // Verify the OTP code with Firebase using the current user
    await currentUser.updatePhoneNumber(credential);

    // Update the user collection
    await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(_auth.currentUser!.uid)
        .update({"phoneNumber": phoneNumber, "isPhoneNumberVerified": true});

    // Check if the instructor collection exists
    DocumentSnapshot<Map<String, dynamic>> instructorDoc =
        await FirebaseFirestore.instance
            .collection(instructorsCollections)
            .doc(_auth.currentUser!.uid)
            .get();

    if (instructorDoc.exists) {
      // Update the instructor collection
      await FirebaseFirestore.instance
          .collection(instructorsCollections)
          .doc(_auth.currentUser!.uid)
          .update({"phoneNumber": phoneNumber, "isPhoneNumberVerified": true});
    }

    await UserPreferences.setPhoneNumber(phoneNumber!);
    await UserPreferences.setIsPhoneNumberVerified(true);
    showCustomToast("Phone number has been added successfully");

    return true;
  } catch (e) {
    showCustomToast("Error verifying OTP: Invalid OTP or Try again");
    return false; // Return false if an error occurs during verification
  }
}

}



