import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/models/auth/user_model.dart';
import 'package:zant/frontend/models/home/instructor_model.dart';
import 'package:zant/frontend/screens/homeScreens/enrollments/enrolled_instructor_for_user.dart';
import 'package:zant/frontend/screens/homeScreens/enrollments/enrolled_users_for_insructor.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/firebase_collection_names.dart';

class EnrollmentsMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Enroll a user to an instructor.
  Future<void> enrollUserToInstructor({required String instructorId}) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String currentUserId = user.uid;
        Timestamp currentDate = Timestamp.now();

        // References to user and instructor documents
        DocumentReference userCollectionRef =
            _firestore.collection(userCollection).doc(currentUserId);
        DocumentReference instructorCollectionRef =
            _firestore.collection(instructorsCollections).doc(instructorId);

        // Fetch user and instructor documents
        DocumentSnapshot userDocSnapshot = await userCollectionRef.get();
        DocumentSnapshot instructorDocSnapshot =
            await instructorCollectionRef.get();

        if (userDocSnapshot.exists && instructorDocSnapshot.exists) {
          List<Map<String, dynamic>> userEnrollments =
              List<Map<String, dynamic>>.from(userDocSnapshot.get('enrollments') ?? []);
          List<Map<String, dynamic>> instructorEnrollments =
              List<Map<String, dynamic>>.from(instructorDocSnapshot.get('enrollments') ?? []);

          // Check if the user is already enrolled
          bool isUserEnrolled = userEnrollments.any((enrollment) => enrollment.containsValue(instructorId));
          bool isInstructorEnrolled = instructorEnrollments.any((enrollment) => enrollment.containsValue(currentUserId));

          if (!isUserEnrolled && !isInstructorEnrolled) {
            // Create new enrollment maps
            Map<String, dynamic> newEnrollment = {
               instructorId: currentDate.toDate().toString(),
            };

            // Update user's enrollments
            userEnrollments.add(newEnrollment);
            await userCollectionRef.update({'enrollments': userEnrollments});

            // Create new enrollment map for instructor
            Map<String, dynamic> instructorEnrollment = {
              currentUserId: currentDate.toDate().toString(),
            };

            // Update instructor's enrollments
            instructorEnrollments.add(instructorEnrollment);
            await instructorCollectionRef.update({'enrollments': instructorEnrollments});

            // Show success message
            showCustomToast( "Enrolled successfully!");
          } else {
            // User is already enrolled
            showCustomToast("You are already enrolled.");
          }
        } else {
          // User or instructor not found
          showCustomToast("User or instructor not found.");
        }
      } else {
        // User not authenticated
        print("User not authenticated.");
        showCustomToast("User not authenticated.");
      }
    } catch (e) {
      // Handle errors gracefully and log the error
      print("Error enrolling user: $e");
      showCustomToast("Error enrolling user. Please try again later.");
    }
  }

  // Check if the current user is enrolled with the specified instructor.
  Future<bool> checkEnrollmentStatus({required String instructorId}) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String currentUserId = user.uid;

        DocumentSnapshot instructorDoc = await _firestore
            .collection(instructorsCollections)
            .doc(instructorId)
            .get();

        if (instructorDoc.exists) {
          List<Map<String, dynamic>> enrollments =
              List<Map<String, dynamic>>.from(instructorDoc.get('enrollments') ?? []);

          // Check if the current user's ID is a key in any of the enrollment maps
          bool userEnrolled = enrollments.any(
            (enrollment) => enrollment.containsKey(currentUserId),
          );

          return userEnrolled;
        } else {
          // Instructor not found
          showCustomToast("Instructor not found.");
        }
      }
    } catch (e) {
      // Handle any potential errors here
      print("Error checking enrollment status: $e");
      showCustomToast("Error checking enrollment status. Please try again later.");
    }

    // Return false if an error occurred or the user is not enrolled
    return false;
  }

  // Get enrollment instructor IDs for the current user.
  Future<List<String>> getEnrollmentInstrcutorsIDsForUsers() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      final DocumentSnapshot userSnapshot =
          await _firestore.collection(userCollection).doc(userId).get();
      final Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      final List<dynamic>? enrollmentList = userData?['enrollments'];

      if (enrollmentList != null) {
        return enrollmentList.map<String>((enrollmentData) {
          final Map<String, dynamic> enrollmentMap =
              enrollmentData as Map<String, dynamic>;
          final String enrollmentId =
              enrollmentMap.keys.first; // Assuming there's only one key
          return enrollmentId;
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      // Handle errors when fetching enrollment IDs.
      print("Error fetching enrollment IDs: $e");
      throw e; // You can choose to rethrow the exception or handle it as needed
    }
  }

  // Get a stream of instructor models for the current user's enrollments.
  Stream<List<InstructorModel>> getInstructorsForUser() {
    final StreamController<List<InstructorModel>> controller =
        StreamController<List<InstructorModel>>();

    getEnrollmentInstrcutorsIDsForUsers().then((enrollmentIds) {
      // Check if there are no enrollment IDs to avoid unnecessary Firestore queries.
      if (enrollmentIds.isEmpty) {
        controller.add([]);
        return;
      }

      _firestore
          .collection(instructorsCollections)
          .where("uid", whereIn: enrollmentIds)
          .snapshots()
          .listen((querySnapshot) {
        final List<InstructorModel> instructors = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return InstructorModel.fromMap(data);
        }).toList();

        controller.add(instructors);
      });
    }).catchError((e) {
      // Handle errors when fetching instructors.
      print("Error fetching instructors: $e");
      controller.addError(e); // Pass the error to the stream controller
    });

    return controller.stream;
  }

  // Get enrollment user IDs for the current instructor.
  Future<List<String>> getEnrollmentUsersIDsForInstructors() async {
    String instructorId = FirebaseAuth.instance.currentUser!.uid;
    try {
      final DocumentSnapshot instructorSnapshot =
          await _firestore.collection(instructorsCollections).doc(instructorId).get();
      final Map<String, dynamic>? instructorData =
          instructorSnapshot.data() as Map<String, dynamic>?;

      final List<dynamic>? enrollmentList = instructorData?['enrollments'];

      if (enrollmentList != null) {
        return enrollmentList.map<String>((enrollmentData) {
          final Map<String, dynamic> enrollmentMap =
              enrollmentData as Map<String, dynamic>;
          final String enrollmentId =
              enrollmentMap.keys.first; // Assuming there's only one key
          return enrollmentId;
        }).toList();
      } else {
        print("No enrollments found for instructors.");
        return [];
      }
    } catch (e) {
      // Handle errors when fetching enrollment IDs.
      print("Error fetching enrollment IDs: $e");
      throw e; // You can choose to rethrow the exception or handle it as needed
    }
  }

  // Get a stream of user models for the current instructor's enrollments.
  Stream<List<UserModel>> getUsersForInstructors() {
    final StreamController<List<UserModel>> controller =
        StreamController<List<UserModel>>();

    getEnrollmentUsersIDsForInstructors().then((enrollmentIds) {
      // Check if there are no enrollment IDs to avoid unnecessary Firestore queries.
      if (enrollmentIds.isEmpty) {
        print("empty");
        controller.add([]);
        return;
      }

      _firestore
          .collection(userCollection)
          .where("uid", whereIn: enrollmentIds)
          .snapshots()
          .listen((querySnapshot) {
        final List<UserModel> users = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return UserModel.fromMap(data);
        }).toList();

        controller.add(users);
      });
    }).catchError((e) {
      // Handle errors when fetching users.
      print("Error fetching users: $e");
      controller.addError(e); // Pass the error to the stream controller
    });

    return controller.stream;
  }

  // Unenroll a user from an instructor.
  Future<void> unenrollInstructorForUser({required String instructorId}) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String currentUserId = user.uid;

        DocumentReference userCollectionRef =
            _firestore.collection(userCollection).doc(currentUserId);
        DocumentReference instructorCollectionRef =
            _firestore.collection(instructorsCollections).doc(instructorId);

        DocumentSnapshot userDocSnapshot = await userCollectionRef.get();
        DocumentSnapshot instructorDocSnapshot =
            await instructorCollectionRef.get();

        if (userDocSnapshot.exists && instructorDocSnapshot.exists) {
          List<Map<String, dynamic>> userEnrollments =
              List<Map<String, dynamic>>.from(
                  userDocSnapshot.get('enrollments') ?? []);
          List<Map<String, dynamic>> instructorEnrollments =
              List<Map<String, dynamic>>.from(
                  instructorDocSnapshot.get('enrollments') ?? []);

          bool isUserEnrolled = userEnrollments
              .any((enrollment) => enrollment.containsKey(instructorId));
          bool isInstructorEnrolled = instructorEnrollments
              .any((enrollment) => enrollment.containsKey(currentUserId));

          if (isUserEnrolled && isInstructorEnrolled) {
            userEnrollments.removeWhere(
                (enrollment) => enrollment.containsKey(instructorId));
            instructorEnrollments.removeWhere(
                (enrollment) => enrollment.containsKey(currentUserId));

            await userCollectionRef.update({'enrollments': userEnrollments});
            await instructorCollectionRef
                .update({'enrollments': instructorEnrollments});

            Get.offAll(() => const ShowEnrolledInstructorForUserScreen());

            showCustomToast("Unenrolled successfully!");
          } else {
            showCustomToast("You are not enrolled in this instructor.");
          }
        } else {
          showCustomToast("User or instructor not found.");
        }
      } else {
        print("User not authenticated.");
        showCustomToast("User not authenticated.");
      }
    } catch (e) {
      print("Error unenrolling user: $e");
      showCustomToast("Error unenrolling user. Please try again later.");
    }
  }

  // Unenroll a user from an instructor (instructor's perspective).
  Future<void> unenrollUserForInstrcutor({required String userId}) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String currentUserId = user.uid;

        DocumentReference userCollectionRef =
            _firestore.collection(userCollection).doc(userId);
        DocumentReference instructorCollectionRef =
            _firestore.collection(instructorsCollections).doc(currentUserId);

        DocumentSnapshot userDocSnapshot = await userCollectionRef.get();
        DocumentSnapshot instructorDocSnapshot =
            await instructorCollectionRef.get();

        if (userDocSnapshot.exists && instructorDocSnapshot.exists) {
          List<Map<String, dynamic>> userEnrollments =
              List<Map<String, dynamic>>.from(
                  userDocSnapshot.get('enrollments') ?? []);
          List<Map<String, dynamic>> instructorEnrollments =
              List<Map<String, dynamic>>.from(
                  instructorDocSnapshot.get('enrollments') ?? []);

          bool isUserEnrolled = userEnrollments
              .any((enrollment) => enrollment.containsKey(currentUserId));
          bool isInstructorEnrolled = instructorEnrollments
              .any((enrollment) => enrollment.containsKey(userId));

          if (isUserEnrolled && isInstructorEnrolled) {
            userEnrollments
                .removeWhere((enrollment) => enrollment.containsKey(currentUserId));
            instructorEnrollments.removeWhere(
                (enrollment) => enrollment.containsKey(userId));

            await userCollectionRef.update({'enrollments': userEnrollments});
            await instructorCollectionRef
                .update({'enrollments': instructorEnrollments});

            Get.offAll(() => const ShowEnrolledUsersForInstructor());

            showCustomToast("Unenrolled successfully!");
          } else {
            showCustomToast("You are not enrolled in this instructor.");
          }
        } else {
          showCustomToast("User or instructor not found.");
        }
      } else {
        print("User not authenticated.");
        showCustomToast("User not authenticated.");
      }
    } catch (e) {
      print("Error unenrolling user: $e");
      showCustomToast("Error unenrolling user. Please try again later.");
    }
  }
}
