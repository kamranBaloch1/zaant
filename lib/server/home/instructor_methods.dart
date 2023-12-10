import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:zaanth/frontend/models/home/instructor_model.dart';
import 'package:zaanth/enum/account_type.dart';
import 'package:zaanth/frontend/models/home/review_model.dart';
import 'package:zaanth/frontend/models/home/review_reply_model.dart';
import 'package:zaanth/frontend/screens/homeScreens/home/home_screen.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/details/widgets/show_instructor_reviews.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/firebase_collection_names.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/phone/phone_number_otp_screen.dart';
import 'package:zaanth/server/notifications/notification_method.dart';
import 'package:zaanth/server/notifications/send_notifications.dart';
import 'package:zaanth/sharedprefences/userPref.dart';

class InstructorMethods {
  final FirebaseCollectionNamesFields _collectionNamesFields =
      FirebaseCollectionNamesFields();
  final FirebaseAuth _auth = FirebaseAuth.instance;

// method to add new instructor
// method to add new instructor
  Future<void> addNewInstructor({
    required String phoneNumber,
    required String qualification,
    required List<String> subjects,
    required int feesPerMonth,
    required Map<String, Map<String, Map<String, String>>>
        selectedTimingsForSubjects,
    required Map<String, List<String>> selectedDaysForSubjects,
    required List<String>? selectedGrades,
  }) async {
    try {
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
      String dobString =
          UserPreferences.getDob().toString(); // Replace with your logic

// Convert the String to DateTime
      DateTime? dob =
          dobString.isNotEmpty ? DateTime.tryParse(dobString) : null;

      final userDocRef = FirebaseFirestore.instance
          .collection(_collectionNamesFields.userCollection)
          .doc(uid);

      final userDoc = await userDocRef.get();
      if (!userDoc.exists) {
        throw Exception("User document not found.");
      }

      final instructorModel = InstructorModel(
          uid: uid,
          phoneNumber: phoneNumber,
          isPhoneNumberVerified: true,
          qualification: qualification,
          feesPerMonth: feesPerMonth,
          ratings: 1,
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
          dob: dob,
          selectedGradesLevel: selectedGrades!);

      await FirebaseFirestore.instance
          .collection(_collectionNamesFields.instructorsCollection)
          .doc(uid)
          .set(instructorModel.toMap());

      await userDocRef.update({
        "accountType": AccountTypeEnum.instructor.value,
        "phoneNumber": phoneNumber,
        "isPhoneNumberVerified": true,
      });

      await UserPreferences.setAccountType(
          AccountTypeEnum.instructor.toString().split('.').last);
      await UserPreferences.setPhoneNumber(phoneNumber);
      await UserPreferences.setIsPhoneNumberVerified(true);

      showCustomToast("You have successfully become an instructor");

      Get.offAll(() => const HomeScreen());
    } catch (e) {
      showCustomToast(
          "An error occurred while becoming an instructor. Please try again later. $e");
      print(
          "An error occurred while becoming an instructor. Please try again later. $e");
    }
  }

// method to verify instructor phone number
  Future<void> verifyPhoneNumber({
    required String? phoneNumber,
    required String? selectedQualification,
    required int? feesPerMonth,
  }) async {
    try {
      // Check if the phone number is already associated with a user
      QuerySnapshot<Map<String, dynamic>> usersWithPhoneNumber =
          await FirebaseFirestore.instance
              .collection(_collectionNamesFields.userCollection)
              .where("phoneNumber", isEqualTo: phoneNumber)
              .get();

      if (usersWithPhoneNumber.docs.isNotEmpty) {
        // The phone number is already associated with a user
        showCustomToast('this phone number is already in use by another user.');
        return;
      }
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber!,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          String errorMessage;
          if (e.code == 'invalid-phone-number') {
            errorMessage = 'Invalid phone number';
          } else if (e.code == 'too-many-requests') {
            errorMessage = 'phone number blocked due to too many requests';
          } else {
            errorMessage =
                'pshone Number Verification Failed, please check the number';
          }
          showCustomToast(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          Get.offAll(() => PhoneNumberOTPScreen(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
                feesPerMonth: feesPerMonth,
                selectedQualification: selectedQualification,
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          showCustomToast('code retrieval timed out');
        },
        timeout: const Duration(minutes: 2),
      );
    } catch (e) {
      showCustomToast("error sending OTP");
    }
  }

// method to verify instructor phone number Otp code
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
        verificationId: phoneNumberVerificationId!,
        smsCode: otp!,
      );

      await currentUser.updatePhoneNumber(credential);

      return true;
    } catch (e) {
      // Check for specific error conditions and display appropriate error messages
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-verification-code') {
          showCustomToast("Invalid OTP code. Please try again.");
        } else if (e.code == 'expired-action-code') {
          showCustomToast(
              "The OTP code has expired. Please request a new one.");
        } else if (e.code == 'provider-already-linked') {
          showCustomToast(
              "This phone number is already linked to another account.");
        } else {
          showCustomToast("Error verifying OTP: ${e.message}");
        }
      } else {
        showCustomToast("an unexpected error occurred");
      }
      return false; // Return false if an error occurs during verification
    }
  }

// method to fecth the instrctors for user search

  Future<List<Map<String, dynamic>>> searchInstructors({
    required String address,
    required String gender,
    required int minPrice,
    required int maxPrice,
    required List<String> subjects,
    required List<String> selectedGradesLevel,
  }) async {
    CollectionReference instructors = FirebaseFirestore.instance
        .collection(_collectionNamesFields.instructorsCollection);

    try {
      // Construct a single query with basic conditions
      Query query = instructors;

      if (gender.isNotEmpty) {
        query = query.where('gender', isEqualTo: gender);
      }

      if (minPrice > 0 || maxPrice < double.infinity) {
        query = query.where('feesPerMonth', isGreaterThanOrEqualTo: minPrice);

        if (maxPrice < double.infinity) {
          query = query.where('feesPerMonth', isLessThanOrEqualTo: maxPrice);
        }
      }

      QuerySnapshot querySnapshot = await query.get();

      // Convert documents to a list of Map<String, dynamic>
      List<Map<String, dynamic>> searchResults = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Apply additional filtering for subjects and grades locally
      searchResults = searchResults.where((doc) {
        bool subjectFilter = subjects.isEmpty ||
            subjects.any((subject) => doc['subjects'].contains(subject));
        bool gradeFilter = selectedGradesLevel.isEmpty ||
            selectedGradesLevel
                .any((grade) => doc['selectedGradesLevel'].contains(grade));
        return subjectFilter && gradeFilter;
      }).toList();

      // If addressing is provided, filter the results based on Levenshtein distance
      if (address.isNotEmpty) {
        searchResults = searchResults
            .where((doc) => _isAddressFuzzyMatch(address, doc['address'], 3))
            .toList();
      }

      return searchResults;
    } catch (e) {
      // Handle errors, e.g., show an error message

      showCustomToast('Error during search ');
      return [];
    }
  }

// part of  searchInstructors method code
  bool _isAddressFuzzyMatch(
      String userInput, String actualAddress, int maxDistance) {
    userInput = userInput.toLowerCase();
    actualAddress = actualAddress.toLowerCase();

    final int distance =
        _calculateLevenshteinDistance(userInput, actualAddress);

    return distance <= maxDistance;
  }

// part of  searchInstructors method code
  int _calculateLevenshteinDistance(String a, String b) {
    final int lenA = a.length;
    final int lenB = b.length;

    final List<List<int>> dp =
        List.generate(lenA + 1, (i) => List<int>.filled(lenB + 1, 0));

    for (int i = 0; i <= lenA; i++) {
      for (int j = 0; j <= lenB; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else {
          dp[i][j] = _min(dp[i - 1][j - 1] + (a[i - 1] != b[j - 1] ? 1 : 0),
              _min(dp[i - 1][j] + 1, dp[i][j - 1] + 1));
        }
      }
    }

    return dp[lenA][lenB];
  }

// part of  searchInstructors method code
  int _min(int a, int b) {
    return a < b ? a : b;
  }

// method to update instructor subjects
  Future<void> updateInstructorSubjectsDays({
    required Map<String, List<String>> selectedDaysForSubjects,
  }) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      final DocumentSnapshot instructorDoc = await FirebaseFirestore.instance
          .collection(_collectionNamesFields.instructorsCollection)
          .doc(uid)
          .get();

      final Map<String, dynamic>? existingData =
          instructorDoc.data() as Map<String, dynamic>?;

      Map<String, List<String>> selectedDaysData = {};

      if (existingData != null &&
          existingData["selectedDaysForSubjects"] != null) {
        final Map<String, dynamic> existingSelectedDaysData =
            existingData["selectedDaysForSubjects"] as Map<String, dynamic>;

        existingSelectedDaysData.forEach((subject, days) {
          if (days is List<String>) {
            selectedDaysData[subject] = days;
          }
        });
      }

      selectedDaysForSubjects.forEach((subject, days) {
        if (selectedDaysData.containsKey(subject)) {
          // Remove deselected days
          selectedDaysData[subject]!.removeWhere((day) => !days.contains(day));

          // Add selected days
          days.forEach((day) {
            if (!selectedDaysData[subject]!.contains(day)) {
              selectedDaysData[subject]!.add(day);
            }
          });
        } else {
          selectedDaysData[subject] = days;
        }
      });

      await FirebaseFirestore.instance
          .collection(_collectionNamesFields.instructorsCollection)
          .doc(uid)
          .update({"selectedDaysForSubjects": selectedDaysData});

      showCustomToast("Subjects days updated");
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      showCustomToast("error occurred while updating the subjects days");
    }
  }

// method to update instructor subjects timings
  Future<void> updateInstructorSubjectTiming({
    required String subject,
    required Map<String, dynamic> newTimings,
  }) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      final DocumentSnapshot instructorDoc = await FirebaseFirestore.instance
          .collection(_collectionNamesFields.instructorsCollection)
          .doc(uid)
          .get();

      final Map<String, dynamic>? existingData =
          instructorDoc.data() as Map<String, dynamic>?;

      final Map<String, Map<String, dynamic>> selectedTimingsData = {
        ...?existingData?["selectedTimingsForSubjects"],
        subject: newTimings,
      };

      final Map<String, dynamic> mergedData = {
        ...(existingData ?? {}),
        "selectedTimingsForSubjects": selectedTimingsData
      };

      await FirebaseFirestore.instance
          .collection(_collectionNamesFields.instructorsCollection)
          .doc(uid)
          .update(mergedData);

      showCustomToast("$subject timings updated");
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      showCustomToast("error accoured while updating the timings");
    }
  }

  // method to update instructor fees charges

  Future<void> updateInstructorFeesCharges({required int feesPerMonth}) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection(_collectionNamesFields.instructorsCollection)
          .doc(uid)
          .update({"feesPerMonth": feesPerMonth});
      showCustomToast("Fees updated");
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      showCustomToast("error accoured while updating the fees");
    }
  }

  // method to update instructor qualification

  Future<void> updateInstructorQualification(
      {required String qualification}) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection(_collectionNamesFields.instructorsCollection)
          .doc(uid)
          .update({"qualification": qualification});
      showCustomToast("Qualification updated");
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      showCustomToast("error accoured while updating the qualification");
    }
  }

// method to add new subjects for  instructor

  Future<void> addNewSubjects({
    required List<String> newSubjects,
    required Map<String, Map<String, Map<String, String>>>
        selectedTimingsForSubjects,
    required Map<String, List<String>> selectedDaysForSubjects,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not authenticated.");
      }

      final uid = user.uid;

      final instructorDocRef = FirebaseFirestore.instance
          .collection(_collectionNamesFields.instructorsCollection)
          .doc(uid);

      final instructorDoc = await instructorDocRef.get();
      final existingSubjects =
          (instructorDoc.data()?['subjects'] as List<dynamic>)
              .map((e) => e.toString())
              .toList();

      final existingTimings = instructorDoc
          .data()?['selectedTimingsForSubjects'] as Map<String, dynamic>;
      final existingDays = instructorDoc.data()?['selectedDaysForSubjects']
          as Map<String, dynamic>;

      for (final newSubject in newSubjects) {
        if (existingSubjects.contains(newSubject)) {
          throw Exception("Subject '$newSubject' already exists.");
        }
      }

      final allSubjects = [...existingSubjects, ...newSubjects];

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

      await instructorDocRef.update({
        "subjects": allSubjects,
        "selectedTimingsForSubjects": mergedTimings,
        "selectedDaysForSubjects": mergedDays,
      });

      showCustomToast("New subjects added successfully");
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      if (e.toString().contains("Subject")) {
        showCustomToast(
            "One or more subjects already exist. Please choose different subjects.");
      } else {
        showCustomToast("error occurred while adding a new subject.");
      }
    }
  }

// method to remove instructor subjects
  Future<void> removeSubjects({
    required List<String> subjectsToRemove,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not authenticated.");
      }

      final uid = user.uid;

      final instructorDocRef = FirebaseFirestore.instance
          .collection(_collectionNamesFields.instructorsCollection)
          .doc(uid);

      final instructorDoc = await instructorDocRef.get();
      final existingSubjects =
          (instructorDoc.data()?['subjects'] as List<dynamic>)
              .map((e) => e.toString())
              .toList();

      final subjectsNotInCollection = subjectsToRemove
          .where((subject) => !existingSubjects.contains(subject))
          .toList();

      if (subjectsNotInCollection.isNotEmpty) {
        throw Exception(
            "Subjects not found: ${subjectsNotInCollection.join(', ')}");
      }

      final updatedSubjects = existingSubjects
          .where((subject) => !subjectsToRemove.contains(subject))
          .toList();

      final Map<String, dynamic> existingTimings = instructorDoc
          .data()?['selectedTimingsForSubjects'] as Map<String, dynamic>;
      final Map<String, dynamic> existingDays = instructorDoc
          .data()?['selectedDaysForSubjects'] as Map<String, dynamic>;

      for (final subjectToRemove in subjectsToRemove) {
        existingTimings.remove(subjectToRemove);
        existingDays.remove(subjectToRemove);
      }

      await instructorDocRef.update({
        "subjects": updatedSubjects,
        "selectedTimingsForSubjects": existingTimings,
        "selectedDaysForSubjects": existingDays,
      });

      showCustomToast("Subjects removed successfully");
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      if (e.toString().contains("Subjects not found")) {
        showCustomToast("$e. Please choose existing subjects.");
      } else {
        showCustomToast("error occurred while removing subjects.");
      }
    }
  }

// method to add instructor review
  Future<void> addInstructorReview({
    required String instructorUid,
    required double ratings,
    required String content,
  }) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String? currentUserName = UserPreferences.getName();

      final instructorDoc = FirebaseFirestore.instance
          .collection(_collectionNamesFields.instructorsCollection)
          .doc(instructorUid);

      final reviewsCollectionRef =
          instructorDoc.collection(_collectionNamesFields.reviewsCollection);

      final existingReviewDoc = await reviewsCollectionRef.doc(userId).get();

      if (existingReviewDoc.exists) {
        showCustomToast("You have already added a review for this instructor.");
      } else {
        ReviewModel reviewModel = ReviewModel(
          userId: userId,
          reviewId: userId,
          content: content,
          ratings: ratings,
          date: Timestamp.fromDate(DateTime.now()),
        );

        final ratingsQuery = await instructorDoc.get();

        if (ratingsQuery.exists) {
          final totalRatings = ratingsQuery['ratings'] as double;

          final updatedTotalRatings = totalRatings + ratings;

          final averageRating = updatedTotalRatings / (totalRatings + 1);
          final clampedAverageRating = averageRating.clamp(1.0, 5.0);

          await instructorDoc.update({'ratings': clampedAverageRating});

          await reviewsCollectionRef.doc(userId).set(reviewModel.toMap());
          await SendNotificationsMethod()
              .sendNotificationsToInstructorForNewReview(
            instructorUid: instructorUid,
            userName: currentUserName!,
          );

          //Saving the notification to firestore

          await NotificationMethod().saveNotificationToFireStore(
              notificationText: "added a review",
              receiverUserId: instructorUid,
              senderUserId: userId);

          showCustomToast("Review added");
          Get.to(
              () => ShowInstructorReviewsScreen(instructorId: instructorUid));
        }
      }
    } catch (e) {
      showCustomToast("error accoured please try again");
    }
  }

// method to fecth reviews of  instructor
  Future<List<Map<String, dynamic>>> fetchReviewsOfInstructor(
      {required String instructorUid}) async {
    try {
      final reviewsRef = FirebaseFirestore.instance
          .collection(_collectionNamesFields.instructorsCollection)
          .doc(instructorUid)
          .collection(_collectionNamesFields.reviewsCollection);

      final reviewsQuerySnapshot =
          await reviewsRef.orderBy('date', descending: true).get();

      final reviewsData = <Map<String, dynamic>>[];

      for (final reviewDoc in reviewsQuerySnapshot.docs) {
        final reviewData = reviewDoc.data() as Map<String, dynamic>;
        final userId = reviewData['userId'] as String;

        final userDoc = await FirebaseFirestore.instance
            .collection(_collectionNamesFields.userCollection)
            .doc(userId)
            .get();
        final userData = userDoc.data() as Map<String, dynamic>;

        reviewData['name'] = userData['name'];
        reviewData['profilePicUrl'] = userData['profilePicUrl'];

        reviewsData.add(reviewData);
      }

      return reviewsData;
    } catch (e) {
      print("error fetching reviews with user details: $e");
      return [];
    }
  }

// method to add a replay for an review
  Future<void> addInstructorReviewReply({
    required String instructorUid,
    required String reviewId,
    required String replyText,
  }) async {
    try {
      final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final String replyId = const Uuid().v4();
      String? currentUserName = UserPreferences.getName();

      ReviewReplyModel reviewReplyModel = ReviewReplyModel(
          userId: currentUserId,
          instructorId: instructorUid,
          reviewId: reviewId,
          replyText: replyText,
          date: Timestamp.fromDate(DateTime.now()),
          replyId: replyId);

      await FirebaseFirestore.instance
          .collection(_collectionNamesFields.instructorsCollection)
          .doc(instructorUid)
          .collection(_collectionNamesFields.reviewsCollection)
          .doc(reviewId)
          .collection(_collectionNamesFields.reviewsReplyCollection)
          .doc(replyId)
          .set(reviewReplyModel.toMap());
      await SendNotificationsMethod().sendNotificationsToUsersForReviewReplay(
          userName: currentUserName!, userId: instructorUid);

      //Saving the notification to firestore

      await NotificationMethod().saveNotificationToFireStore(
          notificationText: "replied you",
          receiverUserId: instructorUid,
          senderUserId: currentUserId);
      showCustomToast("Reply added");
    } catch (e) {
      showCustomToast("error accoured while adding an reply");
    }
  }

  // method to fecth reviews replies

  Future<List<Map<String, dynamic>>> fetchRepliesForReview({
    required String instructorUid,
    required String reviewId,
  }) async {
    try {
      final reviewsCollectionDoc = FirebaseFirestore.instance
          .collection(_collectionNamesFields.instructorsCollection)
          .doc(instructorUid)
          .collection(_collectionNamesFields.reviewsCollection);
      final reviewDoc = await reviewsCollectionDoc.doc(reviewId).get();

      if (reviewDoc.exists) {
        final repliesCollection = reviewDoc.reference
            .collection(_collectionNamesFields.reviewsReplyCollection);
        final repliesQuery =
            await repliesCollection.orderBy('date', descending: true).get();

        final replies =
            await Future.wait(repliesQuery.docs.map((replyDoc) async {
          final replyData = replyDoc.data() as Map<String, dynamic>;
          final userId = replyData['userId'] as String;

          // Fetch user data for the reply author
          final userDoc = await FirebaseFirestore.instance
              .collection(_collectionNamesFields.userCollection)
              .doc(userId)
              .get();
          final userData = userDoc.data() as Map<String, dynamic>;

          // Add user data to the reply
          replyData['name'] = userData['name'];
          replyData['profilePicUrl'] = userData['profilePicUrl'];

          return replyData;
        }).toList());

        return replies;
      } else {
        throw 'Review document not found';
      }
    } catch (e) {
      print('Error fetching replies: $e');
      rethrow;
    }
  }

// method to delete an review
  Future<void> deleteReviewReply({
    required String instructorUid,
    required String reviewId,
    required String replyId,
  }) async {
    try {
      final replyDocRef = FirebaseFirestore.instance
          .collection(_collectionNamesFields.instructorsCollection)
          .doc(instructorUid)
          .collection(_collectionNamesFields.reviewsCollection)
          .doc(reviewId)
          .collection(_collectionNamesFields.reviewsReplyCollection)
          .doc(replyId);

      final replyDoc = await replyDocRef.get();

      if (replyDoc.exists) {
        // The reply document exists; proceed with deletion
        await replyDocRef.delete();
        showCustomToast("Reply deleted");
      } else {
        showCustomToast(
            "Reply not found"); // Handle the case where the reply doesn't exist
      }
    } catch (e) {
      showCustomToast("error occurred while deleting the reply");
    }
  }

// method to remove instrctor grade level

  Future<void> removeSelectedGrades(
      {required List<String> selectedGrades}) async {
    try {
      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the instructor collection
      CollectionReference instructors =
          firestore.collection(_collectionNamesFields.instructorsCollection);

      // Update the document with the specified user ID
      DocumentReference instructorDoc =
          instructors.doc(FirebaseAuth.instance.currentUser!.uid);

      // Get the current data
      DocumentSnapshot instructorSnapshot = await instructorDoc.get();
      Map<String, dynamic>? userData =
          instructorSnapshot.data() as Map<String, dynamic>?;

      // Check if the user data exists
      if (userData != null) {
        // Get the current selectedGradeLevel list
        List<String> currentSelectedGrades =
            List<String>.from(userData['selectedGradesLevel'] ?? []);

        // Check if the list is empty before removal
        if (currentSelectedGrades.isEmpty) {
          showCustomToast("At least one grade level must be selected.");
          return; // Stop execution if no grade levels are selected
        }
// Check if there is only one grade level after removal
        if (currentSelectedGrades.length == 1) {
          showCustomToast(
              "At least one grade level must be present at your profile.");
          return; // Stop execution if trying to remove all values
        }

        // Remove selected grades
        currentSelectedGrades
            .removeWhere((grade) => selectedGrades.contains(grade));

        // Update the selectedGradeLevel list in the document
        await instructorDoc
            .update({'selectedGradesLevel': currentSelectedGrades});

        showCustomToast("Grade level updated");
        // Navigate to the HomeScreen if more than one grade level remains
        Get.offAll(() => const HomeScreen());
      }
    } catch (e) {
      showCustomToast('Error removing grades');
      // Handle errors as needed
    }
  }

// method to update instrctor grade level
  Future<void> updateSelectedGrades(
      {required List<String> selectedNewGrades}) async {
    try {
      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the instructor collection
      CollectionReference instructors =
          firestore.collection(_collectionNamesFields.instructorsCollection);

      // Update the document with the specified user ID
      DocumentReference instructorDoc =
          instructors.doc(FirebaseAuth.instance.currentUser!.uid);

      // Get the current data
      DocumentSnapshot instructorSnapshot = await instructorDoc.get();
      Map<String, dynamic>? userData =
          instructorSnapshot.data() as Map<String, dynamic>?;

      // Check if the user data exists
      if (userData != null) {
        // Get the current selectedGradesLevel list
        List<String> currentSelectedGrades =
            List<String>.from(userData['selectedGradesLevel'] ?? []);

        // Check if the selectedGradesLevel list already has two values
        if (currentSelectedGrades.length == 2) {
          showCustomToast("You can only add up to two grade levels.");
          return; // Stop execution if two grade levels are already present
        }

        // Check for duplicates
        for (String grade in selectedNewGrades) {
          if (currentSelectedGrades.contains(grade)) {
            showCustomToast("Grade level '$grade' is already present.");
            return; // Stop execution if a duplicate grade level is found
          }
        }

        // Add selected grades to the current list
        currentSelectedGrades.addAll(selectedNewGrades);

        // Update the selectedGradesLevel list in the document
        await instructorDoc
            .update({'selectedGradesLevel': currentSelectedGrades});

        showCustomToast("Grade levels added successfully");
        Get.offAll(() => const HomeScreen());
      }
    } catch (e) {
      showCustomToast('Error adding grades');
    }
  }
}
