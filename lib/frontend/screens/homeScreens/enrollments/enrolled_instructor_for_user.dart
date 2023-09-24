import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/models/home/instructor_model.dart';
import 'package:zant/frontend/screens/homeScreens/drawer/drawer.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/details/instructor_details_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/server/home/enrollments_methods.dart';

class ShowEnrolledInstructorForUserScreen extends StatefulWidget {
  const ShowEnrolledInstructorForUserScreen({Key? key}) : super(key: key);

  @override
  State<ShowEnrolledInstructorForUserScreen> createState() =>
      _ShowEnrolledInstructorForUserScreenState();
}

class _ShowEnrolledInstructorForUserScreenState
    extends State<ShowEnrolledInstructorForUserScreen> {
  Widget _buildInstructorItem(InstructorModel instructor) {
    return GestureDetector(
      onTap: () {
        Get.to(() => InstructorDetailScreen(instructorModel: instructor));
      },
      child: Column(
        children: [
          CircleAvatar(
            key: ValueKey(instructor.uid), // Provide a unique key
            radius: 40.r,
            backgroundImage: NetworkImage(instructor.profilePicUrl),
          ),
          SizedBox(height: 8.h),
          FittedBox(
            // Use FittedBox to handle long names
            fit: BoxFit.scaleDown,
            child: Text(
              instructor.name,
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

  Widget _buildInstructorList(List<InstructorModel> instructors) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
        ),
        itemCount: instructors.length,
        itemBuilder: (context, index) {
          return _buildInstructorItem(instructors[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: appBarColor,
        title: "Your Enrolled Instructors", // Corrected spelling here
      ),
      drawer: const MyDrawer(),
      body: StreamBuilder<List<InstructorModel>>(
        stream: EnrollmentsMethods().getInstructorsForUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading Instructors",
                style: TextStyle(color: Colors.black),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No Instructors",
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
              ),
            );
          } else {
            List<InstructorModel> instructors = snapshot.data!;

            return _buildInstructorList(instructors);
          }
        },
      ),
    );
  }
}
