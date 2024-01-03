import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zaanth/frontend/screens/authSceens/login/login_screen.dart';
import 'package:zaanth/frontend/screens/authSceens/register/select_profile_pic_screen.dart';
import 'package:zaanth/global/colors.dart';
import 'package:zaanth/global/constant_values.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Fade Animation
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);

    // Slide Animation
    _slideController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeInOut,
      ),
    );

    // Scale Animation
    _scaleController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_scaleController);

    // Start all animations when the widget is mounted
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50.h),
                      Center(
                        child: Image.asset(
                          logoImg,
                          width: 250.w,
                          height: 180.h,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        height: 20.h, // Adjust the height of the line
                        child: ClipPath(
                          clipper: CurveClipper(),
                          child: Container(
                            width: double.infinity,
                            color: const Color.fromARGB(255, 35, 49, 129),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Welcome To",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 35, 49, 129),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Zaanth!",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 35, 49, 129),
                          fontSize: 35.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Where Learning Begins.",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 35, 49, 129),
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.to(() => const  LoginScreen());
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 20.sp,
                                decoration: TextDecoration.underline,
                                color: const Color.fromARGB(255, 35, 49, 129),
                              ),
                            ),
                          ),
                          SizedBox(width: 18.w), 
                          TextButton(
                            onPressed: () {
                               Get.to(() => const  SelectProfilePicScreen());
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Signup',
                              style: TextStyle(
                                fontSize: 18.sp,
                                decoration: TextDecoration.underline,
                                color: const Color.fromARGB(255, 35, 49, 129), 
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width / 2, size.height - 20, size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
