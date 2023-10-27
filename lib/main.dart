import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zant/frontend/models/auth/user_model.dart';
import 'package:zant/frontend/providers/auth/login_providers.dart';
import 'package:zant/frontend/providers/auth/register_providers.dart';
import 'package:zant/frontend/providers/home/chat_providers.dart';
import 'package:zant/frontend/providers/home/enrollmens_provider.dart';
import 'package:zant/frontend/providers/home/instructor_provider.dart';
import 'package:zant/frontend/providers/home/notification_provider.dart';
import 'package:zant/frontend/providers/home/profile_providers.dart';
import 'package:zant/frontend/screens/authSceens/login/onBoarding_screen.dart';
import 'package:zant/frontend/screens/homeScreens/home/home_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/firebase_collection_names.dart';
import 'package:zant/server/auth/logout.dart';
import 'package:zant/sharedprefences/userPref.dart';


// Entry point for the application
void main() async {
  // Ensure that Firebase is initialized before the app starts
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // initializing the sharedPrefences
  await UserPreferences.init();

  runApp(
    // Use MultiProvider to manage different provider instances
    MultiProvider(
      providers: [
        // Auth Providers
        ChangeNotifierProvider(create: (context) => RegisterProviders()),
        ChangeNotifierProvider(create: (context) => LoginProviders()),

        // home providers

        ChangeNotifierProvider(create: (context) => InstructorProviders()),
        ChangeNotifierProvider(create: (context) => ProfileProviders()),
        ChangeNotifierProvider(create: (context) => ChatProviders()),
        ChangeNotifierProvider(create: (context) => EnrollmentsProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProviders()),
      ],
      // Initialize the app
      child: const MyApp(),
    ),
  );
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Initialize ScreenUtil to handle screen sizes and fonts
    return ScreenUtilInit(
      designSize: Size(width, height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Zaant',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: FutureBuilder<Widget>(
            future: _buildHomeScreen(),
            builder: (context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return snapshot.data!;
              }
            },
          ),
        );
      },
    );
  }
}

Future<User?> _getCurrentUser() async {
  return FirebaseAuth.instance.currentUser;
}

Future<DocumentSnapshot<Map<String, dynamic>>> _getUserDocument(
    User user) async {
  return FirebaseFirestore.instance
      .collection(FirebaseCollectionNamesFields().userCollection)
      .doc(user.uid)
      .get();
}

Future<Widget> _buildHomeScreen() async {
  User? user = await _getCurrentUser();
  if (user != null) {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await _getUserDocument(user);
    if (docSnapshot.exists) {
      UserModel userModel = UserModel.fromMap(docSnapshot.data()!);
      bool isEmailVerified = userModel.isEmailVerified!;

      bool accountStatus = userModel.accountStatus!;

      if (!isEmailVerified) {
        await _deleteUserData(user);
        return const StartScreen();
      } else if (!accountStatus) {
        // Call the logout method
        await LogoutMethod().logoutUser();
        return const StartScreen();
      } else {
        return const HomeScreen();
      }
    } else {
      // Call the logout method
      await LogoutMethod().logoutUser();
      return const StartScreen();
    }
  } else {
    return const StartScreen();
  }
}

Future<void> _deleteUserData(User user) async {
  // Delete user data from Firestore and Firebase Auth if isEmailVerified is false
  try {
    await FirebaseFirestore.instance
        .collection(FirebaseCollectionNamesFields().userCollection)
        .doc(user.uid)
        .delete();
    await user.delete();
  } catch (e) {
    showCustomToast("Somethig went wrong");
  }
}
