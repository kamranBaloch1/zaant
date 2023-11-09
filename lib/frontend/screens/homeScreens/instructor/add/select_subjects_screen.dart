// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/pick_subejcts_dropdown.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/add/select_subject_days_screen.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';

class SelectSubjectsScreen extends StatefulWidget {
  final String? selectedQualification;
  final String? phoneNumber;
  final int? feesPerHour;

  const SelectSubjectsScreen({
    Key? key,
  
    required this.selectedQualification,
    required this.phoneNumber,
    required this.feesPerHour,
  }) : super(key: key);

  @override
  State<SelectSubjectsScreen> createState() => _SelectSubjectsScreenState();
}

class _SelectSubjectsScreenState extends State<SelectSubjectsScreen> {
  List<String> _selectedSubjects = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Simulate loading delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _moveToNextScreenMethod() async {
    if (_selectedSubjects.isNotEmpty) {
      Get.to(() => SelectSubjectDaysScreen(
          selectedSubjects: _selectedSubjects,
          selectedQualification: widget.selectedQualification,
          phoneNumber: widget.phoneNumber,
          feesPerHour: widget.feesPerHour));
    } else {
      showCustomToast("Please select at least one subject.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: "Select subjects",
            backgroundColor: appBarColor,
          ),
          body: Column(
            children: [
              SizedBox(
                height: 40.h,
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
             
             
             
              SizedBox(
                height: 70.h,
              ),
              CustomButton(
                onTap: _isLoading ? null : _moveToNextScreenMethod,
                width: 200,
                height: 40,
                text: "Next",
                bgColor: Colors.blue,
              )
            ],
          ),
        ),

        // Show a loading overlay if loading is true
        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }
}
