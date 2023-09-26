import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/profile/profile_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/firebase_collection_names.dart';
import 'package:zant/sharedprefences/userPref.dart';

class ProfileMethods {
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
}
