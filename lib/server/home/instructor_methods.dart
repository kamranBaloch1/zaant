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
  Future<void> addInstructor(
      {required String phoneNumber,
      required String qualification,
      required String location,
      required List<String> subjects,
      required int feesPerHour,
      required List<String> availableTimings}) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      InstructorModel instructorModel = InstructorModel(
          uid: uid,
          phoneNumber: phoneNumber,
          isPhoneNumberVerified: false,
          qualification: qualification,
          location: location,
          feesPerHour: feesPerHour,
          reviews: [],
          ratings: 0,
          subjects: subjects,
          availableTimings: availableTimings,
          accountType: AccountTypeEnum.instructor,
          createdOn: Timestamp.fromDate(DateTime.now()));
   
      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(uid)
          .collection(instructorsCollections)
          .doc(uid)
          .set(instructorModel.toMap());

      //updating the user account type from users collection

      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(uid)
          .update({"accountType": AccountTypeEnum.instructor});

           //updating the user account type from sharedPref 
          await UserPreferences.setAccountType(AccountTypeEnum.instructor.toString().split('.').last);

          showCustomToast("You have been an instructor");

          Get.offAll(()=> const HomeScreen());


    } catch (e) {
       showCustomToast("error accoured please try again");
    }
  }

 
}
