import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/models/auth/user_model.dart';
import 'package:zant/frontend/screens/homeScreens/drawer/drawer.dart';
import 'package:zant/frontend/screens/homeScreens/user/user_detail_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/server/home/enrollments_methods.dart';

class ShowEnrolledUsersForInstructor extends StatefulWidget {
  const ShowEnrolledUsersForInstructor({Key? key}) : super(key: key);

  @override
  State<ShowEnrolledUsersForInstructor> createState() =>
      _ShowEnrolledUsersForInstructorState();
}

class _ShowEnrolledUsersForInstructorState
    extends State<ShowEnrolledUsersForInstructor> {
  Widget _buildUserItem(UserModel user) {
    return GestureDetector(
      onTap: () {
        Get.to(() => UserDetailScreen(userModel: user));
      },
      child: Column(
        children: [
          CircleAvatar(
            key: ValueKey(user.uid), // Provide a unique key
            radius: 40.r,
            backgroundImage: NetworkImage(user.profilePicUrl!),
          ),
          SizedBox(height: 8.h),
          FittedBox(
            // Use FittedBox to handle long names
            fit: BoxFit.scaleDown,
            child: Text(
              user.name!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(List<UserModel> users) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
        ),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return _buildUserItem(users[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: appBarColor,
        title: "Your Enrolled Users",
      ),
      drawer: const MyDrawer(),
      body: StreamBuilder<List<UserModel>>(
        stream: EnrollmentsMethods().getUsersForInstructors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading enrolled users",
                style: TextStyle(color: Colors.black),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No enrolled users",
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
              ),
            );
          } else {
            List<UserModel> users = snapshot.data!;

            return _buildUserList(users);
          }
        },
      ),
    );
  }
}
