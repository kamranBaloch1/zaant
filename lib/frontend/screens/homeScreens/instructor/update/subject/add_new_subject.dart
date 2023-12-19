import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/pick_subejcts_dropdown.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/update/subject/new_subject_days.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';

class AddNewSubjectForInstructorScreen extends StatefulWidget {
  const AddNewSubjectForInstructorScreen({Key? key}) : super(key: key);

  @override
  State<AddNewSubjectForInstructorScreen> createState() =>
      _AddNewSubjectForInstructorScreenState();
}

class _AddNewSubjectForInstructorScreenState
    extends State<AddNewSubjectForInstructorScreen> {
  List<String> _selectedSubjects = [];

  void _moveToNextScreenMethod() async {
    if (_selectedSubjects.isNotEmpty) {
      // Navigate to the next screen with selected subjects
      Get.to(() => NewSubjectDaysScreen(
            selectedSubjects: _selectedSubjects,
          ));
    } else {
      // Show a custom toast message if no subjects are selected
      showCustomToast("Please select at least one subject.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const  CustomAppBar(
        backgroundColor: appBarColor,
        title:'Add new subject',
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: PickSubjectsDropdown(
              selectedSubjects: _selectedSubjects,
              onChanged: (selectedSubjects) {
                setState(() {
                  _selectedSubjects = selectedSubjects;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
            child: CustomButton(
              onTap: _moveToNextScreenMethod,
              width: 200,
              height: 40,
              text: "Next",
              bgColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
