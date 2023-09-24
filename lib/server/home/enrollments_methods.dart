import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zant/frontend/models/auth/user_model.dart';
import 'package:zant/frontend/models/home/instructor_model.dart';
import 'package:zant/global/firebase_collection_names.dart';

class EnrollmentsMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get enrollment instructor IDs for the current user.
  Future<List<String>> getEnrollmentInstrcutorsIDsForUsers() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      final DocumentSnapshot userSnapshot =
          await firestore.collection(userCollection).doc(userId).get();
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

      firestore
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
  Future<List<String>> getEnrollmenUsersIDsForInstrctors() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      final DocumentSnapshot userSnapshot =
          await firestore.collection(instructorsCollections).doc(userId).get();
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

    getEnrollmenUsersIDsForInstrctors().then((enrollmentIds) {
      // Check if there are no enrollment IDs to avoid unnecessary Firestore queries.
      if (enrollmentIds.isEmpty) {
        print("empty");
        controller.add([]);
        return;
      }

      firestore
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
}
