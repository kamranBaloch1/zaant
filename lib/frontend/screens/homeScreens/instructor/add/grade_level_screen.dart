import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/add/select_subjects_screen.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';

class GradeLevelScreen extends StatefulWidget {
  final String? selectedQualification;
  final String? phoneNumber;
  final int? feesPerMonth;
  final List<String>? selectedSyllabusTypes;
  final String? address;
   final String? tuitionType;
  final String? teachingExperience;
  final String? degreeCompletionStatus;
  

  const GradeLevelScreen({
    Key? key,
   required this.selectedQualification,
   required this.phoneNumber,
   required this.feesPerMonth,
   required this.selectedSyllabusTypes,
   required this.address,
   required this.teachingExperience,
   required this.tuitionType,
   required this.degreeCompletionStatus,
  
  }) : super(key: key);

  @override
  State<GradeLevelScreen> createState() => _GradeLevelScreenState();
}

class _GradeLevelScreenState extends State<GradeLevelScreen> {
  List<String> selectedGrades = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const CustomAppBar(backgroundColor: appBarColor, title: "Choose your Grade level"),
      body: Center(
        child: Padding(
          padding:  EdgeInsets.all(16.w),
          child: Container(
            padding:  EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2.r,
                  blurRadius: 5.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16.w,
              runSpacing: 16.w,
              children: [
                _buildGradeLevelOption("playGroup to nursery"),
                _buildGradeLevelOption("1st to 5th"),
                _buildGradeLevelOption("6th to 8th"),
                _buildGradeLevelOption("6th to 10th"),
                _buildGradeLevelOption("9th to 10th"),
                _buildGradeLevelOption("11th to 12th"),
                _buildGradeLevelOption("1st to 12th"),

                CustomButton(
                  onTap: () {
                    if (selectedGrades.isNotEmpty && selectedGrades.length <= 2) {
                      Get.to(() => SelectSubjectsScreen(
                            selectedQualification: widget.selectedQualification,
                            phoneNumber: widget.phoneNumber,
                            feesPerMonth: widget.feesPerMonth,
                            selectedGrades: selectedGrades, 
                            selectedSyllabusTypes: widget.selectedSyllabusTypes,
                            address:widget.address,
                            teachingExperience:widget.teachingExperience,
                            tuitionType:widget.tuitionType,
                            degreeCompletionStatus:widget.degreeCompletionStatus,
                          ));
                    } else {
                      // Display an error message or take appropriate action
                      showCustomToast("Please select at least one and at most two grades.");
                    }
                  },
                  width: 300,
                  height: 40,
                  text: "Next",
                  bgColor: Colors.blue,
                )
              ],
            ),
          ),
        ),
    
    
      ),
    );
  }

  Widget _buildGradeLevelOption(String gradeLevel) {
    bool isSelected = selectedGrades.contains(gradeLevel);
    bool isDisabled = selectedGrades.length >= 2 && !isSelected;

    return InkWell(
      onTap: () {
        setState(() {
          if (isDisabled) {
            // User is trying to select more than two grades, do nothing
            return;
          }

          if (isSelected) {
            // Deselect the grade if it's already selected
            selectedGrades.remove(gradeLevel);
          } else {
            // Select the grade
            selectedGrades.add(gradeLevel);
          }
        });
      },
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : (isDisabled ? Colors.grey[300] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.blueAccent.withOpacity(0.3) : Colors.transparent,
              spreadRadius: 2.r,
              blurRadius: 5.r,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          gradeLevel,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDisabled ? Colors.grey[600] : Colors.black),
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }



}
