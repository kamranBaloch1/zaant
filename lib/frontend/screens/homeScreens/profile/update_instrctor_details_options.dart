// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/profile/widgets/update_charges_per_hour.dart';
import 'package:zant/frontend/screens/homeScreens/profile/widgets/update_qualification.dart';
import 'package:zant/frontend/screens/homeScreens/profile/widgets/update_subjects.dart';
import 'package:zant/frontend/screens/homeScreens/profile/widgets/update_subjects_days.dart';
import 'package:zant/frontend/screens/homeScreens/profile/widgets/update_subjects_timings.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';

class UpdateInstrctorOptionsScreen extends StatefulWidget {
  final List<String> selectedSubjects;
  final Map<String, Map<String, Map<String, String>>> selectedDaysForSubjects;
  final  String feesPerHour;
  final String Qualification;
  const UpdateInstrctorOptionsScreen({
    Key? key,
    required this.selectedSubjects,
    required this.selectedDaysForSubjects,
    required this.feesPerHour,
    required this.Qualification,
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
          appBar: CustomAppBar(
            backgroundColor: appBarColor,
            title: "Edit Profile",
          ),
          body: ListView(
            children: [
              SizedBox(
                height: 20.h,
              ),
              // Edit Profile ListTile
              _buildListTile(Icons.book, 'Change subjects', () {
                Get.to(() => UpdateSubjectsScreen(
                    selectedSubjects: widget.selectedSubjects));
              }),
              _buildListTile(Icons.calendar_month, 'Change subjects Days', () {
                Get.to(() => UpdateSubjectDaysScreen(
                    selectedSubjects: widget.selectedSubjects));
              }),
              _buildListTile(Icons.punch_clock, 'Change subjects Timings', () {
                Get.to(() => UpdateSubjectsTimingsScreen(
                      selectedSubjects: widget.selectedSubjects,
                      selectedDaysForSubjects: widget.selectedDaysForSubjects,
                    ));
              }),
              _buildListTile(Icons.money, 'Change charges per hour', () {
                Get.to(() =>  UpdateChargesPerHour(feesPerHour: widget.feesPerHour,));
              }),
              _buildListTile(Icons.school, 'Change Qualification', () {
                Get.to(() =>  UpdateQualificationScreen(selectedQualification: widget.Qualification,));
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
        style: TextStyle(color: Colors.black),
      ),
      onTap: onTap,
    );
  }
}
