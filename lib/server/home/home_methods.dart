
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zant/global/firebase_collection_names.dart';

class HomeMethods{

 Future<Map<String, dynamic>> fetchCurrenUserInfo() async {
    // Fetch user info from Firestore
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance
            .collection(userCollection)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    if (userSnapshot.exists) {
      return userSnapshot.data()!;
    }
  return {};
  }



}