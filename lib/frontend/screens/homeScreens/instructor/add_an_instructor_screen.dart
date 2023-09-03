import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/custom_home_text_field.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/pick_subejcts_dropdown.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/select_timings_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_dropdown.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';

class AddInstructorScreen extends StatefulWidget {
  const AddInstructorScreen({super.key});

  @override
  State<AddInstructorScreen> createState() => _AddInstructorScreenState();
}

class _AddInstructorScreenState extends State<AddInstructorScreen> {
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _feesPerHour = TextEditingController();

  List<String> _selectedSubjects = [];
  String? selectedQualification;
  bool _isLoading = false;

  List<String> qualificationList = [
    "Matric",
    "Phd",
    "Bachelor",
    "School student",
    "Master"
  ];

  @override
  void dispose() {
    super.dispose();
    _phoneNumber.dispose();
    _feesPerHour.dispose();
  }

  Future<void> _movieToNextScreenMethod() async {
    setState(() {
      _isLoading=true;
    });
  String  number = _phoneNumber.text.trim();
  String feesPerHour = _feesPerHour.text.trim();

  if (number.isNotEmpty &&
      feesPerHour.isNotEmpty &&
      selectedQualification != null &&
      selectedQualification!.isNotEmpty &&
      _selectedSubjects.isNotEmpty) {
         setState(() {
      _isLoading=false;
    });
  
    Get.to(() => SelectTimingsScreen(
        selectedSubjects: _selectedSubjects,
        selectedQualification: selectedQualification,
        phoneNumber: int.parse(number),
        feesPerHour:int.parse(feesPerHour)));
       
  } else {
    setState(() {
      _isLoading=false;
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
                  icon: Icons.numbers,
                  keyBoardType: TextInputType.number,
                ),
                SizedBox(
                  height: 20.h,
                ),
                homeCustomTextField(
                  controller: _feesPerHour,
                  labelText: "Fees per hour",
                  icon: Icons.numbers,
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
                        selectedQualification = value; // Store the selected value
                      });
                    },
                    labelText: "select qualification",
                    icon: Icons.book),
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
                SizedBox(
                  height: 70.h,
                ),
                CustomButton(
                    onTap: _movieToNextScreenMethod,
                    width: 200,
                    height: 40,
                    text: "next",
                    bgColor: Colors.blue)
              ],
            ),
          ),
        ),
         // showing an loading bar if loading is true
        if(_isLoading)
        const CustomLoadingOverlay()
      ],
    );
  }
}
