import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/models/auth/user_model.dart';
import 'package:zant/frontend/screens/homeScreens/home/home_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/firebase_collection_names.dart';
import 'package:zant/sharedprefences/userPref.dart';

class LoginMethods {
  // Method to handle user login with email and password
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? currentUser = credential.user;

      if (currentUser != null) {
        // Fetch user data from Firestore
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection(userCollection)
                .doc(currentUser.uid)
                .get();

        if (userSnapshot.exists) {
          UserModel userModel = UserModel.fromMap(userSnapshot.data()!);

          // Check if the user's email is verified
          if (userModel.isEmailVerified!) {
            if (userModel.accountStatus!) {
              // Save user information to Shared Preferences
              await saveUserInfoToSharedPref(userModel);
              await UserPreferences.setAccountType(userSnapshot.data()!["accountType"]);

              showCustomToast("Welcome back ${userModel.name}");

              Get.offAll(() => const HomeScreen());
            } else {
              // If the account is blocked, sign the user out and display a message
              await FirebaseAuth.instance.signOut();

              showCustomToast("Your account has been blocked");
            }
          } else {
            // If the user's email is not verified, sign the user out and display a message
            await FirebaseAuth.instance.signOut();
            showCustomToast("Your email is not verified");
          }
        } else {
          // If no user is found for the account, sign the user out and display a message
          await FirebaseAuth.instance.signOut();

          showCustomToast("No user found for this account");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showCustomToast("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showCustomToast("Wrong password provided for that user.");
      }
    }
  }

  // Method to save user information to Shared Preferences
  Future<void> saveUserInfoToSharedPref(UserModel userModel) async {
    await UserPreferences.setName(userModel.name!);
    await UserPreferences.setUid(userModel.uid!);
    await UserPreferences.setEmail(userModel.email!);
    await UserPreferences.setProfileUrl(userModel.profileUrl!);
    await UserPreferences.setAccountStatus(userModel.accountStatus!);
    await UserPreferences.setIsEmailVerified(userModel.isEmailVerified!);
    await UserPreferences.setCreatedOn(userModel.createdOn!.toDate());
    await UserPreferences.setDob(userModel.dob);
    await UserPreferences.setGender(userModel.gender!);
    await UserPreferences.setIsPhoneNumberVerified(
        userModel.isPhoneNumberVerified!);
    await UserPreferences.setLocation(userModel.location!);
    await UserPreferences.setPhoneNumber(userModel.phoneNumber.toString());
 

  }

 
 // Method to reset user password
Future<void> resetUserPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    showCustomToast("We have sent a password reset link to this email address");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      showCustomToast("No user found with this email address.");
    } else {
      showCustomToast("An error occurred. Please try again later.");
    }
  } catch (e) {
    showCustomToast("An error occurred. Please try again later.");
  }
}

}
