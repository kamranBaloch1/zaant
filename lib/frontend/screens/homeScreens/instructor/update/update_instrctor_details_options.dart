// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:zant/frontend/screens/homeScreens/instructor/update/update_charges_per_hour.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/update/update_qualification.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/update/update_subjects.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/update/update_subjects_days.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/update/update_subjects_timings.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';

class UpdateInstrctorOptionsScreen extends StatefulWidget {
  final List<String> subjectList;
  final Map<String, Map<String, Map<String, String>>> selectedTimingsForSubjects;
  final int feesPerHour;
  final String qualification;
  final Map<String, List<String>> selectedDaysOfSubjects;
  const UpdateInstrctorOptionsScreen({
    Key? key,
    required this.subjectList,
    required this.selectedTimingsForSubjects,
    required this.feesPerHour,
    required this.qualification,
    required this.selectedDaysOfSubjects,
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
              _buildListTile(Icons.money, 'Change charges per hour', () {
                Get.to(() => UpdateChargesPerHour(feesPerHour: widget.feesPerHour));
              }),
              _buildListTile(Icons.school, 'Change Qualification', () {
                Get.to(() => UpdateQualificationScreen(selectedQualification: widget.qualification));
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
