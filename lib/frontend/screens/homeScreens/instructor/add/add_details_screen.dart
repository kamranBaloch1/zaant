import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/add/select_user_location.screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_dropdown.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/custom_home_text_field.dart';

import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';

class AddDetailsScreen extends StatefulWidget {
  const AddDetailsScreen({super.key});

  @override
  State<AddDetailsScreen> createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _feesPerHour = TextEditingController();

  String? selectedQualification;

  bool _isLoading = false;

  List<String> qualificationList = [
    "Matric",
    "PhD",
    "Bachelor",
    "School Student",
    "Master"
  ];

  @override
  void dispose() {
    super.dispose();
    _phoneNumber.dispose();
    _feesPerHour.dispose();
  }

  Future<void> _moveToNextScreenMethod() async {
    setState(() {
      _isLoading = true;
    });

    // Get input values
    String phoneNumber = _phoneNumber.text.trim();
    String feesPerHour = _feesPerHour.text.trim();

    if (phoneNumber.isNotEmpty &&
        feesPerHour.isNotEmpty &&
        selectedQualification != null &&
        selectedQualification!.isNotEmpty) {
      // Input validation successful
      setState(() {
        _isLoading = false;
      });

      // Navigate to the next screen with collected data
      Get.to(() => SelectUserLocationScreen(
            selectedQualification: selectedQualification,
            phoneNumber: phoneNumber,
            feesPerHour: int.parse(feesPerHour),
          ));
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
          appBar: ReusableAppBar(
            backgroundColor: appBarColor,
            title: "Become an instructor",
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                homeCustomTextField(
                  controller: _phoneNumber,
                  labelText: "Phone Number",
                  icon: Icons.phone,
                  keyBoardType: TextInputType.number,
                ),
                SizedBox(
                  height: 20.h,
                ),
                homeCustomTextField(
                  controller: _feesPerHour,
                  labelText: "Fees per hour",
                  icon: Icons.money,
                  keyBoardType: TextInputType.number,
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomDropdown(
                    items: qualificationList,
                    value: selectedQualification,
                    onChanged: (value) {
                      setState(() {
                        selectedQualification =
                            value; // Store the selected value
                      });
                    },
                    labelText: "Select Qualification",
                    icon: Icons.book),
                SizedBox(
                  height: 70.h,
                ),
                CustomButton(
                    onTap: _moveToNextScreenMethod,
                    width: 200,
                    height: 40,
                    text: "Next",
                    bgColor: Colors.blue)
              ],
            ),
          ),
        ),
        // Showing a loading overlay if _isLoading is true
        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }
}
