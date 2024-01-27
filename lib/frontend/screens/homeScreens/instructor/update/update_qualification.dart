import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zaanth/frontend/providers/home/instructor_provider.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_dropdown.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';

class UpdateQualificationScreen extends StatefulWidget {
  final String? selectedQualification;
  final String? degreeCompletionStatus;

  const UpdateQualificationScreen({
    Key? key,
    required this.selectedQualification,
    required this.degreeCompletionStatus,
  }) : super(key: key);

  @override
  State<UpdateQualificationScreen> createState() =>
      _UpdateQualificationScreenState();
}

class _UpdateQualificationScreenState extends State<UpdateQualificationScreen> {
  String? selectedQualification;
  String? selectedCompletionStatus;
  final List<String> _completionStatusList = ["Completed", "Not Completed"];
  final List<String> _qualificationList = [
    "School Student",
    "Matric",
    "Bachelor",
    "Master's",
    "PHD"
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the selected qualification from the widget parameter
    selectedQualification = widget.selectedQualification;
    selectedCompletionStatus = widget.degreeCompletionStatus;
  }

  bool _isLoading = false;

  // Function to update the user's qualification
  void _updateQualification() async {
    setState(() {
      _isLoading = true;
    });

    if (selectedQualification!.isNotEmpty && selectedQualification != null) {
      // Call the backend method to update the qualification
      final instructorProvider =
          Provider.of<InstructorProviders>(context, listen: false);
      await instructorProvider.updateInstructorQualificationProvider(
          qualification: selectedQualification!,
          degreeCompletionStatus: selectedCompletionStatus!);

      setState(() {
        _isLoading = false;
      });
    } else {
      // Show a toast message and stop loading if qualification is not selected
      showCustomToast("Please fill out the field");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(
            backgroundColor: appBarColor,
            title: "Change qualification",
          ),
          body: Column(
            children: [
              SizedBox(height: 40.h),
              CustomDropdown(
                items: _qualificationList,
                value: selectedQualification,
                onChanged: (value) {
                  setState(() {
                    selectedQualification = value;
                  });
                  
                    _showCompletionStatusDropdown();
                 
                },
                labelText: "Select Qualification",
                icon: Icons.book,
              ),
              // New dropdown for completion status
              if (_isDegreeSelected(selectedQualification))
                CustomDropdown(
                  items: _completionStatusList,
                  value: selectedCompletionStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedCompletionStatus = value;
                    });
                  },
                  labelText: "Select Completion Status",
                  icon: Icons.check,
                ),

              SizedBox(height: 40.h),
              CustomButton(
                onTap: _updateQualification,
                width: 200,
                height: 40,
                text: "Update",
                bgColor: Colors.blue,
              )
            ],
          ),
        ),
        // Show loading overlay if Loading is true
        if (_isLoading) const CustomLoadingOverlay(),
      ],
    );
  }

  // Helper method to check if the selected qualification is a degree
  bool _isDegreeSelected(String? qualification) {
    return qualification == "Matric" ||
        qualification == "PhD" ||
        qualification == "Bachelor" ||
        qualification == "Master's" ||
        qualification == "School Student";
  }

  // Helper method to show the completion status dropdown
  void _showCompletionStatusDropdown() {
    setState(() {
      selectedCompletionStatus =
          _completionStatusList.first; // Set default value
    });
  }
}
