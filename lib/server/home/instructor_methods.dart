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
    required Map<String, Map<String, Map<String, String>>> selectedTimingsForSubjects,
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

  // Update method for instructor subjects days
  Future<void> updateInstrcutorSubjectsDays({
    required Map<String, List<String>> selectedDaysForSubjects,
  }) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Retrieve the current data from Firestore
      final DocumentSnapshot instructorDoc = await FirebaseFirestore.instance
          .collection(instructorsCollections)
          .doc(uid)
          .get();

      // Retrieve the current data from Firestore and cast it to Map<String, dynamic>?
      final Map<String, dynamic>? existingData =
          instructorDoc.data() as Map<String, dynamic>?;

      // Create a new map for "selectedDaysForSubjects"
      Map<String, List<String>> selectedDaysData = {};

      if (existingData != null &&
          existingData["selectedDaysForSubjects"] != null) {
        // Convert dynamic to List<String> if the data exists
        final Map<String, dynamic> existingSelectedDaysData =
            existingData["selectedDaysForSubjects"] as Map<String, dynamic>;

        existingSelectedDaysData.forEach((subject, days) {
          if (days is List<dynamic>) {
            // Cast days to List<String> if needed
            selectedDaysData[subject] = List<String>.from(days);
          } else if (days is List<String>) {
            selectedDaysData[subject] = days;
          }
        });
      }

      // Merge the existing data with the new data
      selectedDaysForSubjects.forEach((subject, days) {
        if (selectedDaysData.containsKey(subject)) {
          // Check if the value is not already in the list before adding
          days.forEach((day) {
            if (!selectedDaysData[subject]!.contains(day)) {
              selectedDaysData[subject]!.add(day);
            }
          });
        } else {
          // Create a new entry if the subject is new
          selectedDaysData[subject] = days;
        }
      });

      // Update the Firestore document with the merged data
      await FirebaseFirestore.instance
          .collection(instructorsCollections)
          .doc(uid)
          .update({"selectedDaysForSubjects": selectedDaysData});

      showCustomToast("Subjects days updated");
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      showCustomToast(e.toString());
    }
  }

  // Update method for instructor subjects timings
  Future<void> updateInstrcutorSubjectTiming({
    required String subject,
    required Map<String, dynamic> newTimings,
  }) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Retrieve the current data from Firestore
      final DocumentSnapshot instructorDoc = await FirebaseFirestore.instance
          .collection(instructorsCollections)
          .doc(uid)
          .get();

      // Retrieve the current data from Firestore and cast it to Map<String, dynamic>?
      final Map<String, dynamic>? existingData =
          instructorDoc.data() as Map<String, dynamic>?;

      // Create a new map for "selectedTimingsForSubjects"
      final Map<String, Map<String, dynamic>> selectedTimingsData = {
        ...?existingData?[
          "selectedTimingsForSubjects"], // Use the existing data if available
        subject: newTimings, // Update the timings for the specified subject
      };

      // Merge the existing data with the new data
      final Map<String, dynamic> mergedData = {
        ...(existingData ??
            {}), // Use the empty map as a fallback if existingData is null
        "selectedTimingsForSubjects": selectedTimingsData
      };

      // Update the Firestore document with the merged data
      await FirebaseFirestore.instance
          .collection(instructorsCollections)
          .doc(uid)
          .update(mergedData);

      showCustomToast("$subject timings updated");
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      showCustomToast(e.toString());
      print(e.toString());
    }
  }

  // Update method for instructor fees charges
  Future<void> updateInstrcutorFeesCharges({required int feesPerHour}) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection(instructorsCollections)
          .doc(uid)
          .update({"feesPerHour": feesPerHour});
      showCustomToast("Charges updated");
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      showCustomToast(e.toString());
    }
  }

  // Update method for instructor Qualification
  Future<void> updateInstrcutorQualification(
      {required String qualification}) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection(instructorsCollections)
          .doc(uid)
          .update({"qualification": qualification});
      showCustomToast("Qualification updated");
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      showCustomToast(e.toString());
    }
  }

  // Function to add new subjects
  Future<void> addNewSubjects({
    required List<String> newSubjects,
    required Map<String, Map<String, Map<String, String>>> selectedTimingsForSubjects,
    required Map<String, List<String>> selectedDaysForSubjects,
  }) async {
    try {
      // Get the current user's information
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not authenticated.");
      }

      final uid = user.uid;

      // Reference to the instructor document
      final instructorDocRef =
          FirebaseFirestore.instance.collection(instructorsCollections).doc(uid);

      // Fetch the existing subjects, timings, and days from the instructor document
      final instructorDoc = await instructorDocRef.get();
      final existingSubjects = (instructorDoc.data()?['subjects'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();

      // Fetch the existing selectedTimingsForSubjects and selectedDaysForSubjects
      final existingTimings = instructorDoc.data()?['selectedTimingsForSubjects']
          as Map<String, dynamic>;
      final existingDays = instructorDoc.data()?['selectedDaysForSubjects']
          as Map<String, dynamic>;

      // Check if any of the new subjects already exist in the existing subjects list
      for (final newSubject in newSubjects) {
        if (existingSubjects.contains(newSubject)) {
          throw Exception("Subject '$newSubject' already exists.");
        }
      }

      // Combine the new subjects with the existing subjects
      final allSubjects = [...existingSubjects, ...newSubjects];

      // Merge the new selectedTimingsForSubjects and selectedDaysForSubjects
      final mergedTimings = {
        ...existingTimings,
        for (final subjectId in selectedTimingsForSubjects.keys)
          subjectId: {
            ...existingTimings[subjectId] as Map<String, dynamic>? ?? {},
            ...?selectedTimingsForSubjects[subjectId],
          },
      };

      final mergedDays = {
        ...existingDays,
        for (final subjectId in selectedDaysForSubjects.keys)
          subjectId: [
            ...(existingDays[subjectId] as List<String>? ?? []),
            ...selectedDaysForSubjects[subjectId]!,
          ],
      };

      // Update the instructor document with the combined data
      await instructorDocRef.update({
        "subjects": allSubjects,
        "selectedTimingsForSubjects": mergedTimings,
        "selectedDaysForSubjects": mergedDays,
      });

      // Display a success message
      showCustomToast("New subjects added successfully");
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      // Handle errors gracefully
      if (e.toString().contains("Subject")) {
        showCustomToast("One or more subjects already exist. Please choose different subjects.");
      } else {
        showCustomToast(
            "An error occurred while adding a new subject. Please try again later.");
      }
    }
  }

  // Function to remove subjects
  Future<void> removeSubjects({
    required List<String> subjectsToRemove,
  }) async {
    try {
      // Get the current user's information
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not authenticated.");
      }

      final uid = user.uid;

      // Reference to the instructor document
      final instructorDocRef =
          FirebaseFirestore.instance.collection(instructorsCollections).doc(uid);

      // Fetch the existing instructor document data
      final instructorDoc = await instructorDocRef.get();
      final existingSubjects = (instructorDoc.data()?['subjects'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();

      // Check if any subject in subjectsToRemove is not present in the existingSubjects
      final subjectsNotInCollection = subjectsToRemove
          .where((subject) => !existingSubjects.contains(subject))
          .toList();

      if (subjectsNotInCollection.isNotEmpty) {
        throw Exception("Subjects not found: ${subjectsNotInCollection.join(', ')}");
      }

      // Remove the subjects from existingSubjects
      final updatedSubjects = existingSubjects
          .where((subject) => !subjectsToRemove.contains(subject))
          .toList();

      // Remove the subjects from selectedTimingsForSubjects and selectedDaysForSubjects
      final Map<String, dynamic> existingTimings =
          instructorDoc.data()?['selectedTimingsForSubjects'] as Map<String, dynamic>;
      final Map<String, dynamic> existingDays =
          instructorDoc.data()?['selectedDaysForSubjects'] as Map<String, dynamic>;

      for (final subjectToRemove in subjectsToRemove) {
        existingTimings.remove(subjectToRemove);
        existingDays.remove(subjectToRemove);
      }

      // Update the instructor document with the updated data
      await instructorDocRef.update({
        "subjects": updatedSubjects,
        "selectedTimingsForSubjects": existingTimings,
        "selectedDaysForSubjects": existingDays,
      });

      // Display a success message
      showCustomToast("Subjects removed successfully");
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      // Handle errors gracefully
      if (e.toString().contains("Subjects not found")) {
        showCustomToast("$e. Please choose existing subjects.");
      } else {
        showCustomToast("An error occurred while removing subjects. Please try again later.");
      }
    }
  }
}
