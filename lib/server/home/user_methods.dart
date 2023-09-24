import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zant/global/firebase_collection_names.dart';

class UserMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Enroll the current user to an instructor.



Future<void> enrollUserToInstructor({required String instructorId}) async {
  try {
    // Get the current user
    User? user = _auth.currentUser;

    if (user != null) {
      // Get the user's ID
      String currentUserId = user.uid;

      // Get the current date as a Firestore Timestamp
      Timestamp currentDate = Timestamp.now();

      // Check if the user is already enrolled
      DocumentReference userCollectionRef =
          _firestore.collection(userCollection).doc(currentUserId);
      DocumentReference instructorCollectionRef =
          _firestore.collection(instructorsCollections).doc(instructorId);

      // Fetch both documents
      DocumentSnapshot userDocSnapshot = await userCollectionRef.get();
      DocumentSnapshot instructorDocSnapshot =
          await instructorCollectionRef.get();

      if (userDocSnapshot.exists && instructorDocSnapshot.exists) {
        // Get the current enrollments list
        List<Map<String, dynamic>> userEnrollments =
            List<Map<String, dynamic>>.from(userDocSnapshot.get('enrollments') ?? []);
        List<Map<String, dynamic>> instructorEnrollments =
            List<Map<String, dynamic>>.from(instructorDocSnapshot.get('enrollments') ?? []);

        // Check if the user is already enrolled
        bool isUserEnrolled = userEnrollments.any((enrollment) => enrollment.containsValue(instructorId));
        bool isInstructorEnrolled = instructorEnrollments.any((enrollment) => enrollment.containsValue(currentUserId));

        if (!isUserEnrolled && !isInstructorEnrolled) {
          // If not enrolled, create a new enrollment map with the date and instructor ID
          Map<String, dynamic> newEnrollment = {
             instructorId: currentDate.toDate().toString(),
          };

          // Add the new enrollment map to the user's enrollments list
          userEnrollments.add(newEnrollment);

          // Create a new enrollment map for the instructor
          Map<String, dynamic> instructorEnrollment = {
            currentUserId: currentDate.toDate().toString(),
            
          };

          // Add the new enrollment map for the instructor
          instructorEnrollments.add(instructorEnrollment);

          // Update the Firestore documents with the updated enrollments lists
          await userCollectionRef.update({'enrollments': userEnrollments});
          await instructorCollectionRef.update({'enrollments': instructorEnrollments});

          // Show a success message indicating successful enrollment
          Fluttertoast.showToast(msg: "Enrolled successfully!");
        } else {
          // Show a message indicating that the user is already enrolled
          Fluttertoast.showToast(msg: "You are already enrolled.");
        }
      } else {
        // Handle the case where one or both documents do not exist
        print("User or instructor not found.");
        Fluttertoast.showToast(msg: "User or instructor not found.");
      }
    } else {
      // Handle the case where the user is not authenticated
      print("User not authenticated.");
      Fluttertoast.showToast(msg: "User not authenticated.");
    }
  } catch (e) {
    // Handle errors gracefully and log the error
    print("Error enrolling user: $e");
    Fluttertoast.showToast(msg: "Error enrolling user. Please try again later.");
  }
}


  /// Check if the current user is enrolled with the specified instructor.
Future<bool> checkEnrollmentStatus({required String instructorId}) async {
  try {
    // Get the current user
    User? user = _auth.currentUser;

    if (user != null) {
      String currentUserId = user.uid;

      // Fetch the instructor's document from Firestore 
      DocumentSnapshot instructorDoc = await _firestore
          .collection(instructorsCollections)
          .doc(instructorId)
          .get();

      if (instructorDoc.exists) {
        // Get the enrollments list from the instructor's document
        List<Map<String, dynamic>> enrollments =
            List<Map<String, dynamic>>.from(instructorDoc.get('enrollments') ?? []);

        // Check if the current user's ID is a key in any of the enrollment maps
        bool userEnrolled = enrollments.any(
          (enrollment) => enrollment.containsKey(currentUserId),
        );

        return userEnrolled;
      } else {
        // Handle the case where the instructor document does not exist
        Fluttertoast.showToast(msg: "Instructor not found.");
      }
    }
  } catch (e) {
    // Handle any potential errors here
    print("Error checking enrollment status: $e");
    Fluttertoast.showToast(msg: "Error checking enrollment status. Please try again later.");
  }

  // Return false if an error occurred or the user is not enrolled
  return false;
}

}
