import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/phone/phone_number_screen.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_dropdown.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/custom_home_text_field.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';

class AddDetailsScreen extends StatefulWidget {
  const AddDetailsScreen({super.key});

  @override
  State<AddDetailsScreen> createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  final TextEditingController _feesPerMonth = TextEditingController();
  final TextEditingController _teachingExperience = TextEditingController();

  String? selectedQualification;
  String? selectedTuitionType;
  String? selectedExperienceType;
  String? selectedCompletionStatus = "";

  bool _isLoading = false;

  final List<String> _qualificationList = [
    "School Student",
    "Matric",
    "Bachelor",
    "Master's",
    "PHD"
  ];
  final List<String> _tuitionTypeList = ["online", "offline"];
  final List<String> _experiencedTypeList = ["Experienced", "Fresher"];
  final List<String> _completionStatusList = ["Completed", "Not Completed"];

  @override
  void dispose() {
    super.dispose();
    _feesPerMonth.dispose();
    _teachingExperience.dispose();
  }

  Future<void> _moveToNextScreenMethod() async {
    setState(() {
      _isLoading = true;
    });

    // Get input values
    String feesPerMonth = _feesPerMonth.text.trim();

    if (feesPerMonth.isNotEmpty &&
        selectedQualification != null &&
        selectedQualification!.isNotEmpty &&
        selectedTuitionType != null &&
        selectedTuitionType!.isNotEmpty &&
        selectedExperienceType != null &&
        selectedExperienceType!.isNotEmpty) {
      // Check if job experience is required and not empty when user is "Experienced"
      if (selectedExperienceType == "Experienced" &&
          _teachingExperience.text.trim().isEmpty) {
        setState(() {
          _isLoading = false;
        });
        showCustomToast("Please enter teaching experience");
      } else {
        // Input validation successful
        setState(() {
          _isLoading = false;
        });

        // Navigate to the next screen with collected data
        Get.to(() => PhoneNumberScreen(
              feesPerMonth: int.parse(feesPerMonth),
              selectedQualification: selectedQualification,
              teachingExperience: selectedExperienceType == "Experienced"
                  ? _teachingExperience.text.trim()
                  : "Fresher",
              tuitionType: selectedTuitionType,
              degreeCompletionStatus: selectedCompletionStatus,
            ));
      }
    } else {
      // Input validation failed
      setState(() {
        _isLoading = false;
      });
      showCustomToast("Please fill in all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(
            backgroundColor: appBarColor,
            title: "Become an instructor",
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                SizedBox(
                  height: 20.h,
                ),
                HomeCustomTextField(
                  controller: _feesPerMonth,
                  labelText: "Fees per month",
                  icon: Icons.money,
                  keyBoardType: TextInputType.number,
                ),
                SizedBox(
                  height: 20.h,
                ),
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

                SizedBox(
                  height: 20.h,
                ),
                CustomDropdown(
                  items: _tuitionTypeList,
                  value: selectedTuitionType,
                  onChanged: (value) {
                    setState(() {
                      selectedTuitionType = value;
                    });
                  },
                  labelText: "Tuition Type",
                  icon: Icons.book_online,
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomDropdown(
                  items: _experiencedTypeList,
                  value: selectedExperienceType,
                  onChanged: (value) {
                    setState(() {
                      selectedExperienceType = value;
                    });
                  },
                  labelText: "Teaching Experience",
                  icon: Icons.work,
                ),
                if (selectedExperienceType == "Experienced")
                  SizedBox(
                    height: 60.h,
                    child: HomeCustomTextField(
                      controller: _teachingExperience,
                      labelText: "Experience (Years)",
                      icon: Icons.school,
                      keyBoardType: TextInputType.number,
                    ),
                  ),
                SizedBox(
                  height: 100.h,
                ),
                CustomButton(
                  onTap: _moveToNextScreenMethod,
                  width: 200,
                  height: 40,
                  text: "Next",
                  bgColor: Colors.blue,
                )
              ],
            ),
          ),
        ),
        // Showing a loading overlay if _isLoading is true
        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }

  // Helper method to check if the selected qualification is a selected
  bool _isDegreeSelected(String? qualification) {
    return qualification == "Matric" ||
        qualification == "PHD" ||
        qualification == "Bachelor" ||
        qualification == "School Student" ||
        qualification == "Master's";
  }

  // Helper method to show the completion status dropdown
  void _showCompletionStatusDropdown() {
    setState(() {
      selectedCompletionStatus = _completionStatusList.first;
    });
  }
}
