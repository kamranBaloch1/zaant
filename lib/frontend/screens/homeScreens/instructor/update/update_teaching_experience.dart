import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zaanth/frontend/providers/home/instructor_provider.dart';
import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/custom_home_text_field.dart';

import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_dropdown.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';


class UpdateTeachingExperienceScreen extends StatefulWidget {
  final String? teachingExperience;

  const UpdateTeachingExperienceScreen({
    Key? key,
    required this.teachingExperience,
  }) : super(key: key);

  @override
  State<UpdateTeachingExperienceScreen> createState() =>
      _UpdateTeachingExperienceScreenState();
}

class _UpdateTeachingExperienceScreenState
    extends State<UpdateTeachingExperienceScreen> {
  late TextEditingController _teachingExperience;
  String? selectedExperienceType;
  bool _isLoading = false;

  final List<String> _experienceTypeList = ["Experienced", "Fresher"];

  @override
  void dispose() {
    _teachingExperience.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _teachingExperience =
        TextEditingController(text: widget.teachingExperience);
    selectedExperienceType =
        isFresher(widget.teachingExperience) ? "Fresher" : "Experienced";
  }

  bool isFresher(String? value) {
    return value == null || !RegExp(r'^[0-9]+$').hasMatch(value);
  }

   // Function to update the user teaching experience

   void _updateTeachingExperience() async {
     setState(() {
        _isLoading =true;
      });
    if (selectedExperienceType == null && selectedExperienceType!.isEmpty) {
       setState(() {
        _isLoading = false;
      });
      showCustomToast("Please select teaching experience");
      return;
    }

    // Check if job experience is required and not empty when user is "Experienced"
    if (selectedExperienceType == "Experienced" &&
        _teachingExperience.text.trim().isEmpty) {
         setState(() {
        _isLoading = false;
      });
      showCustomToast("Please enter teaching experience");
    } else {
      // Input validation successful
      final instructorProvider =
          Provider.of<InstructorProviders>(context, listen: false);
      await instructorProvider.updateTeachingExperienceProvider(
        teachingExperience: selectedExperienceType == "Experienced"
            ? _teachingExperience.text.trim()
            : "Fresher",
      );
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
            title: "Update Teaching Experience",
          ),
          body: Column(
            children: [
              SizedBox(height: 40.h),
              CustomDropdown(
                items: _experienceTypeList,
                value: selectedExperienceType,
                onChanged: (value) {
                  setState(() {
                    selectedExperienceType = value;
                    if (value == "Experienced") {
                      // Set the text field value to an empty string if not numerical
                      if (isFresher(_teachingExperience.text)) {
                        _teachingExperience.text = "";
                      }
                    }
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
                height: 40.h,
              ),
              CustomButton(
                onTap: () {
                  _updateTeachingExperience();
                },
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
}
