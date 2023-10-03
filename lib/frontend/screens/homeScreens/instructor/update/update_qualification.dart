import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zant/frontend/providers/home/instructor_provider.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_dropdown.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';

class UpdateQualificationScreen extends StatefulWidget {
  final String? selectedQualification;

  const UpdateQualificationScreen({
    Key? key,
    required this.selectedQualification,
  }) : super(key: key);

  @override
  State<UpdateQualificationScreen> createState() =>
      _UpdateQualificationScreenState();
}

class _UpdateQualificationScreenState extends State<UpdateQualificationScreen> {
  String? selectedQualification;
  final List<String> qualificationList = [
    "Matric",
    "PhD",
    "Bachelor",
    "School Student",
    "Master"
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the selected qualification from the widget parameter
    selectedQualification = widget.selectedQualification;
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
      await instructorProvider.updateInstrcutorQualificationProvider(
          qualification: selectedQualification!);

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
          appBar: CustomAppBar(
            backgroundColor: appBarColor,
            title: "Update Qualification",
          ),
          body: Column(
            children: [
              SizedBox(height: 40.h),
              CustomDropdown(
                items: qualificationList,
                value: selectedQualification,
                onChanged: (value) {
                  setState(() {
                    selectedQualification = value; // Store the selected value
                  });
                },
                labelText: "Update Qualification",
                icon: Icons.book,
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
}
