// ignore_for_file: public_member_api_docs, sort_constructors_first

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

class UpdateTuitionTypeScreen extends StatefulWidget {
  final String? tuitionType;

  const UpdateTuitionTypeScreen({
    Key? key,
    this.tuitionType,
  }) : super(key: key);

  @override
  State<UpdateTuitionTypeScreen> createState() =>
      _UpdateTuitionTypeScreenState();
}

class _UpdateTuitionTypeScreenState extends State<UpdateTuitionTypeScreen> {
  String? selectedTuitionType;

  final List<String> _tuitionTypeList = ["online", "offline"];

  @override
  void initState() {
    super.initState();
    selectedTuitionType = widget.tuitionType;
  }

  bool _isLoading = false;

  // Function to update the user's qualification
  void _updateQualification() async {
    setState(() {
      _isLoading = true;
    });

    if (selectedTuitionType!.isNotEmpty && selectedTuitionType != null) {
      // Call the backend method to update the qualification
      final instructorProvider =
          Provider.of<InstructorProviders>(context, listen: false);
      await instructorProvider.updateInstructorTuitionTypeProvider(
          tuitionType: selectedTuitionType!);

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
              backgroundColor: appBarColor, title: "Change tuition type"),
          body: Column(
            children: [
              SizedBox(height: 40.h),
              CustomDropdown(
                items: _tuitionTypeList,
                value: selectedTuitionType,
                onChanged: (value) {
                  setState(() {
                    selectedTuitionType = value;
                  });
                },
                labelText: "Select Tuition Type",
                icon: Icons.book_online,
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
