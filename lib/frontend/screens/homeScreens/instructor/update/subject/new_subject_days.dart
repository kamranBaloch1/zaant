import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/update/subject/new_subject_timings_screen.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';

class NewSubjectDaysScreen extends StatefulWidget {
  final List<String> selectedSubjects;

  const NewSubjectDaysScreen({
    Key? key,
    required this.selectedSubjects,
  }) : super(key: key);

  @override
  State<NewSubjectDaysScreen> createState() => _NewSubjectDaysScreenState();
}

class _NewSubjectDaysScreenState extends State<NewSubjectDaysScreen> {
  bool _isLoading = false;

  // Create a map to store selected days for each subject
  Map<String, List<String>> selectedDays = {};

  @override
  void initState() {
    super.initState();

    // Simulate loading delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

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
      Get.to(() => AddNewSubjectTimingsScreen(
          selectedSubjects: widget.selectedSubjects,
          selectedDaysForSubjects: selectedDays));
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
          appBar: const CustomAppBar(
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
                          fontSize: 20.sp,
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
                                      fontSize: 16.sp,
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
                    onTap: _isLoading ? null : _navigateToNextScreen,
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

        // Show a loading overlay if loading is true
        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }
}
