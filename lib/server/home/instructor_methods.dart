import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:zant/frontend/models/home/instructor_model.dart';
import 'package:zant/enum/account_type.dart';
import 'package:zant/frontend/models/home/review_model.dart';
import 'package:zant/frontend/models/home/review_reply_model.dart';
import 'package:zant/frontend/screens/homeScreens/home/home_screen.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/details/widgets/show_instructor_reviews.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/firebase_collection_names.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/phone/phone_number_otp_screen.dart';
import 'package:zant/server/notifications/notification_method.dart';
import 'package:zant/server/notifications/send_notifications.dart';
import 'package:zant/sharedprefences/userPref.dart';

class InstructorMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addNewInstructor({
    required String phoneNumber,
    required String qualification,
    required List<String> subjects,
    required int feesPerHour,
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
      final name = UserPreferences.getName() ?? "";
      final city = UserPreferences.getCity() ?? "";
      final profilePicUrl = UserPreferences.getProfileUrl() ?? "";
      final gender = UserPreferences.getGender() ?? "";
      final address = UserPreferences.getAddress() ?? "";

      final userDocRef =
          FirebaseFirestore.instance.collection(userCollection).doc(uid);

      final userDoc = await userDocRef.get();
      if (!userDoc.exists) {
        throw Exception("User document not found.");
      }

      final instructorModel = InstructorModel(
        uid: uid,
        phoneNumber: phoneNumber,
        isPhoneNumberVerified: true,
        qualification: qualification,
        feesPerHour: feesPerHour,
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
      );

      await FirebaseFirestore.instance
          .collection(instructorsCollections)
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
    }
  }

  Future<void> verifyPhoneNumber({
    required String? phoneNumber,
    required String? selectedQualification,
    required int? feesPerHour,
  }) async {
    try {
      // Check if the phone number is already associated with a user
      QuerySnapshot<Map<String, dynamic>> usersWithPhoneNumber =
          await FirebaseFirestore.instance
              .collection(userCollection)
              .where("phoneNumber", isEqualTo: phoneNumber)
              .get();

      if (usersWithPhoneNumber.docs.isNotEmpty) {
        // The phone number is already associated with a user
        showCustomToast('This phone number is already in use by another user.');
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
            errorMessage = 'Phone number blocked due to too many requests';
          } else {
            errorMessage =
                'Phone Number Verification Failed, please check the number';
          }
          showCustomToast(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          Get.offAll(() => PhoneNumberOTPScreen(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
                feesPerHour: feesPerHour,
                selectedQualification: selectedQualification,
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          showCustomToast('Code retrieval timed out');
        },
        timeout: const Duration(minutes: 2),
      );
    } catch (e) {
      showCustomToast("Error sending OTP");
    }
  }

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
        showCustomToast("An unexpected error occurred: $e");
      }
      return false; // Return false if an error occurs during verification
    }
  }

  Stream<QuerySnapshot> getInstructorsStream({required String query}) {
    try {
      final queryText = query.toLowerCase();
      final queryRef = FirebaseFirestore.instance
          .collection(instructorsCollections)
          .where('address', isGreaterThanOrEqualTo: queryText)
          .where('address', isLessThan: '${queryText}z');

      return queryRef.snapshots();
    } catch (e) {
      print('Error in getInstructorsStream: $e');
      showCustomToast(e.toString());
      return const Stream.empty();
    }
  }

  Future<void> updateInstructorSubjectsDays({
    required Map<String, List<String>> selectedDaysForSubjects,
  }) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      final DocumentSnapshot instructorDoc = await FirebaseFirestore.instance
          .collection(instructorsCollections)
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
          if (days is List<dynamic>) {
            selectedDaysData[subject] = List<String>.from(days);
          } else if (days is List<String>) {
            selectedDaysData[subject] = days;
          }
        });
      }

      selectedDaysForSubjects.forEach((subject, days) {
        if (selectedDaysData.containsKey(subject)) {
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
          .collection(instructorsCollections)
          .doc(uid)
          .update({"selectedDaysForSubjects": selectedDaysData});

      showCustomToast("Subjects days updated");
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      showCustomToast(e.toString());
    }
  }

  Future<void> updateInstructorSubjectTiming({
    required String subject,
    required Map<String, dynamic> newTimings,
  }) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      final DocumentSnapshot instructorDoc = await FirebaseFirestore.instance
          .collection(instructorsCollections)
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

  Future<void> updateInstructorFeesCharges({required int feesPerHour}) async {
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

  Future<void> updateInstructorQualification(
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
          .collection(instructorsCollections)
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
        showCustomToast(
            "An error occurred while adding a new subject. Please try again later.");
      }
    }
  }

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
          .collection(instructorsCollections)
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
        showCustomToast(
            "An error occurred while removing subjects. Please try again later.");
      }
    }
  }

  Future<void> addInstructorReview({
    required String instructorUid,
    required double ratings,
    required String content,
  }) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String? currentUserName = UserPreferences.getName();

      final instructorDoc = FirebaseFirestore.instance
          .collection(instructorsCollections)
          .doc(instructorUid);

      final reviewsCollectionRef = instructorDoc.collection(reviewsCollection);

      final existingReviewDoc = await reviewsCollectionRef.doc(userId).get();

      if (existingReviewDoc.exists) {
        showCustomToast("You have already reviewed this instructor.");
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
      showCustomToast(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> fetchReviewsOfInstructor(
      {required String instructorUid}) async {
    try {
      final reviewsRef = FirebaseFirestore.instance
          .collection(instructorsCollections)
          .doc(instructorUid)
          .collection(reviewsCollection);

      final reviewsQuerySnapshot =
          await reviewsRef.orderBy('date', descending: true).get();

      final reviewsData = <Map<String, dynamic>>[];

      for (final reviewDoc in reviewsQuerySnapshot.docs) {
        final reviewData = reviewDoc.data() as Map<String, dynamic>;
        final userId = reviewData['userId'] as String;

        final userDoc = await FirebaseFirestore.instance
            .collection(userCollection)
            .doc(userId)
            .get();
        final userData = userDoc.data() as Map<String, dynamic>;

        reviewData['name'] = userData['name'];
        reviewData['profilePicUrl'] = userData['profilePicUrl'];

        reviewsData.add(reviewData);
      }

      return reviewsData;
    } catch (e) {
      showCustomToast("Error fetching reviews with user details: $e");
      return [];
    }
  }

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
          .collection(instructorsCollections)
          .doc(instructorUid)
          .collection(reviewsCollection)
          .doc(reviewId)
          .collection(reviewsReplyCollection)
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
      showCustomToast(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> fetchRepliesForReview({
    required String instructorUid,
    required String reviewId,
  }) async {
    try {
      final reviewsCollectionDoc = FirebaseFirestore.instance
          .collection(instructorsCollections)
          .doc(instructorUid)
          .collection(reviewsCollection);
      final reviewDoc = await reviewsCollectionDoc.doc(reviewId).get();

      if (reviewDoc.exists) {
        final repliesCollection =
            reviewDoc.reference.collection(reviewsReplyCollection);
        final repliesQuery =
            await repliesCollection.orderBy('date', descending: true).get();

        final replies =
            await Future.wait(repliesQuery.docs.map((replyDoc) async {
          final replyData = replyDoc.data() as Map<String, dynamic>;
          final userId = replyData['userId'] as String;

          // Fetch user data for the reply author
          final userDoc = await FirebaseFirestore.instance
              .collection(userCollection)
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
      throw e;
    }
  }

  Future<void> deleteReviewReply({
    required String instructorUid,
    required String reviewId,
    required String replyId,
  }) async {
    try {
      final replyDocRef = FirebaseFirestore.instance
          .collection(instructorsCollections)
          .doc(instructorUid)
          .collection(reviewsCollection)
          .doc(reviewId)
          .collection(reviewsReplyCollection)
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
      showCustomToast("Error occurred while deleting the reply: $e");
    }
  }
}
