import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/custom_home_text_field.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/pick_subejcts_dropdown.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/select_user_location.screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_dropdown.dart';
import 'package:zant/global/colors.dart';

class AddInstructorScreen extends StatefulWidget {
  const AddInstructorScreen({super.key});

  @override
  State<AddInstructorScreen> createState() => _AddInstructorScreenState();
}

class _AddInstructorScreenState extends State<AddInstructorScreen> {
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _qualification = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _feesPerHour = TextEditingController();
  final TextEditingController _availableTimings = TextEditingController();

  List<String> _selectedSubjects = [];
  String? selected_qualification;

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
    _qualification.dispose();
    _location.dispose();
    _availableTimings.dispose();
    _feesPerHour.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              controller: _phoneNumber,
              labelText: "Fees per hour",
              icon: Icons.numbers,
              keyBoardType: TextInputType.number,
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomDropdown(items: qualificationList, value: selected_qualification,  onChanged: (value) {
                      setState(() {
                        selected_qualification = value; // Store the selected value
                      });
                    }, labelText: "select qualification", icon: Icons.book),
                      SizedBox(
              height: 20.h,
            ),
          
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
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
            onTap: (){
              // Get.to(()=>  SelectLocationScreen());
            },
            width: 200, height: 40, text: "next", bgColor: Colors.blue)
          ],
        ),
      ),
    );
  }
}
