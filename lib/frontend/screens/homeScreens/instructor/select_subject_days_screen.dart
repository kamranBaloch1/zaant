import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/select_timings_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';

class SelectSubjectDaysScreen extends StatefulWidget {
  final List<String> selectedSubjects;
  final String? selectedQualification;
  final String? phoneNumber;
  final int? feesPerHour;
  const SelectSubjectDaysScreen({
    Key? key,
    required this.selectedSubjects,
    required this.selectedQualification,
    required this.phoneNumber,
    required this.feesPerHour,
  }) : super(key: key);

  @override
  State<SelectSubjectDaysScreen> createState() =>
      _SelectSubjectDaysScreenState();
}

class _SelectSubjectDaysScreenState extends State<SelectSubjectDaysScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  // Create a map to store selected days for each subject
  Map<String, List<String>> selectedDays = {};

  void _navigateToNextScreen() {
    bool allSubjectsHaveDaysSelected = true;

    for (final subject in widget.selectedSubjects) {
      if (selectedDays[subject]?.isEmpty ?? true) {
        allSubjectsHaveDaysSelected = false;
        break;
      }
    }

    if (allSubjectsHaveDaysSelected) {
      // Proceed to the next screen
      // Implement navigation to the next screen here

      Get.to(() => SelectTimingsScreen(
          selectedDays: selectedDays,
          selectedSubjects: widget.selectedSubjects,
          selectedQualification: widget.selectedQualification,
          phoneNumber: widget.phoneNumber,
          feesPerHour: widget.feesPerHour));
    } else {
      // Show a custom toast message
      showCustomToast("Please select at least one day for each subject.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: ReusableAppBar(
            backgroundColor: appBarColor,
            title: "Select Subject Days",
          ),
          body: ListView.builder(
            itemCount:
                widget.selectedSubjects.length + 1, // +1 for the "Next" button
            itemBuilder: (context, index) {
              if (index < widget.selectedSubjects.length) {
                final subject = widget.selectedSubjects[index];

                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        subject,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final day in [
                            'Monday',
                            'Tuesday',
                            'Wednesday',
                            'Thursday',
                            'Friday',
                            'Saturday',
                            'Sunday'
                          ])
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    day,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Checkbox(
                                    value: (selectedDays[subject] ?? [])
                                        .contains(day),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null) {
                                          if (value) {
                                            selectedDays.update(
                                              subject,
                                              (days) {
                                                days.add(day);
                                                return days;
                                              },
                                              ifAbsent: () => [day],
                                            );
                                          } else {
                                            selectedDays.update(
                                              subject,
                                              (days) {
                                                days.remove(day);
                                                return days;
                                              },
                                              ifAbsent: () => [],
                                            );
                                          }
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                // Render the "Next" button
                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
                  child: CustomButton(
                    onTap: _navigateToNextScreen,
                    width: 200,
                    height: 40,
                    text: "Next",
                    bgColor: Colors.blue,
                  ),
                );
              }
            },
          ),
        ),

        // show an loading bar if loading is true

        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }
}
