import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/update/subject/add_new_subject.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/update/subject/remove_subjects.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/global/colors.dart';

// Define a StatefulWidget for the UpdateSubjectsScreen
class UpdateSubjectsScreen extends StatefulWidget {
  final List<String> subjectList;

  const UpdateSubjectsScreen({
    Key? key,
    required this.subjectList,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UpdateSubjectsScreenState createState() => _UpdateSubjectsScreenState();
}

// Define the state class for UpdateSubjectsScreen
class _UpdateSubjectsScreenState extends State<UpdateSubjectsScreen> {
  // Create a list to store selected subjects
  final List<String> _selectedSubjects = [];

  @override
  void initState() {
    super.initState();
    // Initialize selected subjects with the provided subjectList
    _selectedSubjects.addAll(widget.subjectList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(backgroundColor: appBarColor, title: "Update Subjects"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 200.h),
              // Button to navigate to AddNewSubjectForInstructorScreen
              CustomButton(
                onTap: () {
                  Get.to(() => const AddNewSubjectForInstructorScreen());
                },
                width: 200,
                height: 40,
                text: "Add",
                bgColor: Colors.blue,
              ),
              SizedBox(height: 20.h),
              // Button to navigate to RemoveSubjects screen with subjectList
              CustomButton(
                onTap: () {
                  Get.to(() => RemoveSubjects(
                        subjectList: widget.subjectList,
                      ));
                },
                width: 200,
                height: 40,
                text: "Remove",
                bgColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
