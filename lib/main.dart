import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zaanth/frontend/models/auth/user_model.dart';
import 'package:zaanth/frontend/providers/auth/login_providers.dart';
import 'package:zaanth/frontend/providers/auth/register_providers.dart';
import 'package:zaanth/frontend/providers/home/chat_providers.dart';
import 'package:zaanth/frontend/providers/home/enrollmens_provider.dart';
import 'package:zaanth/frontend/providers/home/instructor_provider.dart';
import 'package:zaanth/frontend/providers/home/notification_provider.dart';
import 'package:zaanth/frontend/providers/home/profile_providers.dart';
import 'package:zaanth/frontend/screens/authSceens/splash/start_loading_bar.dart';
import 'package:zaanth/frontend/screens/authSceens/splash/splash_screen.dart';
import 'package:zaanth/frontend/screens/homeScreens/home/home_screen.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/firebase_collection_names.dart';
import 'package:zaanth/server/auth/logout.dart';
import 'package:zaanth/sharedprefences/userPref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegisterProviders()),
        ChangeNotifierProvider(create: (context) => LoginProviders()),
        ChangeNotifierProvider(create: (context) => InstructorProviders()),
        ChangeNotifierProvider(create: (context) => ProfileProviders()),
        ChangeNotifierProvider(create: (context) => ChatProviders()),
        ChangeNotifierProvider(create: (context) => EnrollmentsProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProviders()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return ScreenUtilInit(
      designSize: Size(width, height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Zaanth',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home:FutureBuilder<Widget>(
            future: _buildHomeScreen(),
            builder: (context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const StartLoadingBar();
              
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
        return const SplashScreen();
      } else if (!accountStatus) {
        await LogoutMethod().logoutUser();
        return const SplashScreen();
      } else {
        return const HomeScreen();
      }
    } else {
      await LogoutMethod().logoutUser();
      return const SplashScreen();
    }
  } else {
    return const SplashScreen();
  }
}

Future<void> _deleteUserData(User user) async {
  try {
    await FirebaseFirestore.instance
        .collection(FirebaseCollectionNamesFields().userCollection)
        .doc(user.uid)
        .delete();
    await user.delete();
  } catch (e) {
    showCustomToast("Something went wrong");
  }
}

