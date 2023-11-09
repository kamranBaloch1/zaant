import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zaanth/enum/account_type.dart';
import 'package:zaanth/frontend/models/auth/user_model.dart';
import 'package:zaanth/frontend/screens/authSceens/register/verify_email.screen.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/firebase_collection_names.dart';
import 'package:zaanth/sharedprefences/userPref.dart';


class RegisterMethod {
   
    final FirebaseCollectionNamesFields _collectionNamesFields = FirebaseCollectionNamesFields();


  // Method to upload image to Firebase Storage and get download URL
  Future<String?> uploadImageToStorage(XFile? photoUrl) async {
    try {
      if (photoUrl == null) {
        return null; // Return null when photoUrl is null
      }

      String imgId = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child(_collectionNamesFields.usersProfileImages).child(imgId);

      TaskSnapshot snapshot = await ref.putFile(File(photoUrl.path));
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      // Handle errors gracefully
      throw 'Image upload failed: $e';
    }
  }

  // Method to register a user with email and password
  Future<void> registerWithEmailAndPassword(
      {required String email,
      required String password,
      required XFile? photoUrl,
      required String name,
      required String? gender,
      required DateTime? dob,
      required String city,
      required String address}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;

      if (user != null) {
        // Send email verification link
        user.sendEmailVerification();

        // Upload user profile image to Firebase Storage

        String? downloadUrl = await uploadImageToStorage(photoUrl);

        // Create UserModel object
        UserModel userModel = UserModel(
            uid: user.uid,
            name: name,
            email: email,
            profilePicUrl: downloadUrl,
            dob: dob!,
            gender: gender,
            address: address, 
            phoneNumber: "",
            isEmailVerified: false,
            isPhoneNumberVerified: false,
            createdOn: Timestamp.fromDate(DateTime.now()),
            accountStatus: false,
            accountType: AccountTypeEnum.user,
            city: city,
            enrollments: []);

        // Save user data to Firestore
        await FirebaseFirestore.instance
            .collection(_collectionNamesFields.userCollection)
            .doc(user.uid)
            .set(userModel.toMap());

        // // Save user data to SharedPreferences
        await UserPreferences.setName(name);
        await UserPreferences.setUid(user.uid);
        await UserPreferences.setEmail(email);
        await UserPreferences.setProfileUrl(downloadUrl!);
        await UserPreferences.setAccountStatus(false);
        await UserPreferences.setIsEmailVerified(false);
        await UserPreferences.setCreatedOn(DateTime.now());
        await UserPreferences.setDob(dob);
        await UserPreferences.setGender(gender!);
        await UserPreferences.setIsPhoneNumberVerified(false);
        await UserPreferences.setAddress(address);
        await UserPreferences.setPhoneNumber("");
        await UserPreferences.setAccountType(
            AccountTypeEnum.user.toString().split('.').last);
        await UserPreferences.setCity(city);

        showCustomToast(
            "We have sent an email verification link to this email address");
        Get.offAll(() => const EmailVerificationScreen());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showCustomToast("The password provided is too weak");
      } else if (e.code == 'email-already-in-use') {
        showCustomToast("A account already exists for that email.");
      }
    } catch (e) {
      showCustomToast("Error occurred while creating an account");
    }
  }

  // Method to update user account status after email verification
  Future<void> updateUserAccountStatus() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection(_collectionNamesFields.userCollection)
          .doc(uid)
          .update({"accountStatus": true, "isEmailVerified": true});

      // Update data in SharedPreferences
      await UserPreferences.setAccountStatus(true);
      await UserPreferences.setIsEmailVerified(true);
    } catch (e) {
      showCustomToast("Something went wrong");
    }
  }



}
