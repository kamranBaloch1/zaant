// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/update/update_charges_per_month.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/update/update_grade_level_Screen.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/update/update_qualification.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/update/update_subjects.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/update/update_subjects_days.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/update/update_subjects_timings.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/update/update_teaching_experience.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/update/update_tuition_type.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/global/colors.dart';

class UpdateInstrctorOptionsScreen extends StatefulWidget {
  final List<String> subjectList;
  final Map<String, Map<String, Map<String, String>>> selectedTimingsForSubjects;
  final int feesPerMonth;
  final String qualification;
  final Map<String, List<String>> selectedDaysOfSubjects;
  final List<String>? selectedGradeLevel;
  final String? teachingExperience;
  final String? degreeCompletionStatus; 
  final String? tuitionType; 

  const UpdateInstrctorOptionsScreen({
    Key? key,
    required this.subjectList,
    required this.selectedTimingsForSubjects,
    required this.feesPerMonth,
    required this.qualification,
    required this.selectedDaysOfSubjects,
    required this.selectedGradeLevel,
    required this.teachingExperience,
    required this.degreeCompletionStatus, 
    required this.tuitionType, 
  }) : super(key: key);

  @override
  State<UpdateInstrctorOptionsScreen> createState() =>
      _UpdateInstrctorOptionsScreenState();
}

class _UpdateInstrctorOptionsScreenState
    extends State<UpdateInstrctorOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(
            backgroundColor: appBarColor,
            title: "Edit Profile",
          ),
          body: ListView(
            children: [
              SizedBox(
                height: 20.h,
              ),
              // Edit Profile ListTile
              _buildListTile(Icons.book, 'Edit subjects', () {
                Get.to(() => UpdateSubjectsScreen(
                    subjectList: widget.subjectList));
              }),
              _buildListTile(Icons.calendar_month, 'Change subjects Days', () {
                Get.to(() => UpdateSubjectDaysScreen(
                    selectedDaysOfSubjects: widget.selectedDaysOfSubjects));
              }),
              _buildListTile(Icons.punch_clock, 'Change subjects Timings', () {
                Get.to(() => UpdateSubjectsTimingsScreen(
                  selectedTimingsForSubjects: widget.selectedTimingsForSubjects,
                ));
              }),
              _buildListTile(Icons.money, 'Change charges per month', () {
                Get.to(() => UpdateChargesPerMonth(feesPerMonth: widget.feesPerMonth));
              }),
              _buildListTile(Icons.school, 'Change qualification', () {
                Get.to(() => UpdateQualificationScreen(selectedQualification: widget.qualification,degreeCompletionStatus: widget.degreeCompletionStatus,));
              }),
              _buildListTile(Icons.grade, 'Change grade Level', () {
                Get.to(() => UpdateGradeLevelScreen(selectedGradeLevel: widget.selectedGradeLevel,));
              }),
              _buildListTile(Icons.grade, 'Change teaching experience ', () {
                Get.to(() => UpdateTeachingExperienceScreen( teachingExperience: widget.teachingExperience,));
              }),
              _buildListTile(Icons.grade, 'Change tuition type ', () {
                Get.to(() => UpdateTuitionTypeScreen( tuitionType: widget.tuitionType,));
              }),
            ],
          ),
        ),
      ],
    );
  }

  // Helper function to create a ListTile with an icon and title
  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      onTap: onTap,
    );
  }
}
