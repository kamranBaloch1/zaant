// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_dropdown.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/server/home/profile_methods.dart';

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

  List<String> qualificationList = [
    "Matric",
    "PhD",
    "Bachelor",
    "School Student",
    "Master"
  ];

  @override
  void initState() {
    // TODO: implement initState

    selectedQualification = widget.selectedQualification;

    super.initState();
  }

  bool _isLoading = false;

  Future<void> _updateQualification() async {
    setState(() {
      _isLoading = true;
    });

    if (selectedQualification!.isNotEmpty && selectedQualification != null) {
      await ProfileMethods()
          .updateInstrcutorQualification(qualification: selectedQualification!);

      setState(() {
        _isLoading = false;
      });
    } else {
      showCustomToast("please fill out the field");
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
              backgroundColor: appBarColor, title: "Update Qualification"),
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
                  labelText: "update Qualification",
                  icon: Icons.book),
              SizedBox(height: 40.h),
              CustomButton(
                onTap: _updateQualification,
                width: 200,
                height: 40,
                text: "update",
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
