import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zant/frontend/models/home/instructor_model.dart';

import 'package:zant/frontend/screens/homeScreens/instructor/details/widgets/build_info_card_widget.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/details/widgets/show_days_widget.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/details/widgets/show_timings_widget.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/update/update_instrctor_details_options.dart';

import 'package:zant/frontend/screens/widgets/custom_button.dart';

import 'package:zant/global/firebase_collection_names.dart';
import 'package:get/get.dart';

class ShowInstructorDetailsScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ShowInstructorDetailsScreen({super.key});

  Future<InstructorModel?> getInstructorDetails() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(FirebaseCollectionNamesFields().instructorsCollection)
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        final instructorData = snapshot.data();
        return InstructorModel.fromMap(instructorData!);
      }
    }

    return null; // Return null if no data is found.
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<InstructorModel?>(
        future: getInstructorDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(top: 300.h),
              child: const CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.black));
          } else if (snapshot.data == null) {
            return const Text(
              'No data found.',
              style: TextStyle(color: Colors.black),
            );
          } else {
            final instructor = snapshot.data!;

            return Column(
              children: [
                _showCurrentInstructorData(instructor),
                SizedBox(
                  height: 20.h,
                ),
                CustomButton(
                  onTap: () {
                    Get.to(() => UpdateInstrctorOptionsScreen(
                          subjectList: instructor.subjects,
                          selectedTimingsForSubjects:
                              instructor.selectedTimingsForSubjects,
                          qualification: instructor.qualification,
                          feesPerHour: instructor.feesPerHour,
                          selectedDaysOfSubjects:
                              instructor.selectedDaysForSubjects,
                        ));
                  },
                  width: 300,
                  height: 40,
                  text: "Edit",
                  bgColor: Colors.blue,
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _showCurrentInstructorData(InstructorModel instructorModel) {
    return Column(
      children: [
        BuildInfoCardWidget(
          icon: Icons.subject,
          title: "Subjects",
          content: instructorModel.subjects.isNotEmpty
              ? instructorModel.subjects.join(", ")
              : "No subjects specified",
        ),
        SizedBox(height: 16.h),
        ShowDaysWidget(
          daysForSubjects: instructorModel.selectedDaysForSubjects,
        ),
        SizedBox(height: 16.h),
        ShowTimingWidget(
          selectedTimings: instructorModel.selectedTimingsForSubjects,
        ),
        SizedBox(height: 16.h),
        BuildInfoCardWidget(
          icon: Icons.attach_money,
          title: "Fees per Hour",
          content: "\$${instructorModel.feesPerHour.toString()}",
        ),
        SizedBox(height: 16.h),
        BuildInfoCardWidget(
          icon: Icons.location_on,
          title: "Address",
          content: instructorModel.address,
        ),
        SizedBox(height: 16.h),
        BuildInfoCardWidget(
          icon: Icons.location_city,
          title: "City",
          content: instructorModel.city,
        ),
        SizedBox(height: 16.h),
        BuildInfoCardWidget(
          icon: Icons.school,
          title: "Qualification",
          content: instructorModel.qualification,
        ),
      ],
    );
  }
}
