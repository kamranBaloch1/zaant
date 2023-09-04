// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zant/frontend/providers/home/instructor_provider.dart';

import 'package:zant/frontend/screens/homeScreens/homeWidgets/custom_time_picker.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';

class SelectTimingsScreen extends StatefulWidget {
  final List<String> selectedSubjects;
  final String? selectedQualification;
  final int? phoneNumber;
  final int? feesPerHour;

  const SelectTimingsScreen({
    Key? key,
    required this.selectedSubjects,
    required this.selectedQualification,
    required this.phoneNumber,
    required this.feesPerHour,
  }) : super(key: key);

  @override
  State<SelectTimingsScreen> createState() => _SelectTimingsScreenState();
}

class _SelectTimingsScreenState extends State<SelectTimingsScreen> {
  Map<String, Map<String, TimeOfDay>> subjectTimings = {};

  Map<String, Map<String, String>> dayTimings = {}; // Added dayTimings map

  bool _isLoading = false;

  void _handleSubjectTiming(
    String subject,
    String day, // Added day parameter
    String timeType,
    TimeOfDay time,
  ) {
    setState(() {
      if (!subjectTimings.containsKey(subject)) {
        subjectTimings[subject] = {};
      }
      if (!dayTimings.containsKey(subject)) {
        dayTimings[subject] = {};
      }
      subjectTimings[subject]![timeType] = time;
      dayTimings[subject]![day] = "${time.hour}:${time.minute}";
    });
  }

  Future<void> saveTheInstructorData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      // Iterate through selectedSubjects and check if timings are selected for each subject
      for (final subject in widget.selectedSubjects) {
        final timings = subjectTimings[subject];
        if (timings == null ||
            timings['start'] == null ||
            timings['end'] == null) {
          // Timings are missing for at least one subject
          setState(() {
            _isLoading = false;
          });
          showCustomToast("Please select timings for all subjects");
          return; // Exit the method if any subject's timings are missing
        }
      }

      // All subjects have timings selected, proceed with saving data

      final instructorProvider =
          Provider.of<InstructorProviders>(context, listen: false);
      final availableTimings = <String, Map<String, Map<String, String>>>{};
      subjectTimings.forEach((subject, timings) {
        final dayTimings = <String, Map<String, String>>{};
        timings.forEach((day, time) {
        
            final start = '${time.hour}:${time.minute}';
            dayTimings[day] = {
              'start': start,
              'end': start, // You can adjust 'end' as needed
            };
          
        });

        availableTimings[subject] = dayTimings;
      });

      await instructorProvider.sendVerificationCodeProvider(
        phoneNumber: widget.phoneNumber!,
        qualification: widget.selectedQualification!,
        subjects: widget.selectedSubjects,
        feesPerHour: widget.feesPerHour!,
        subjectTimings: availableTimings,
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast("Error occurred");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: ReusableAppBar(
            backgroundColor: appBarColor,
            title: "Select timings for subjects",
          ),
          body: Column(
            // Wrap ListView.builder and custom button in a Column
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.selectedSubjects.length,
                  itemBuilder: (context, index) {
                    final subject = widget.selectedSubjects[index];
                    final timings = subjectTimings[subject] ?? {};
                    final selectedDay = dayTimings[subject]?.keys.first;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                          child: Text(
                            subject,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                       DropdownButton<String>(
  style: const TextStyle(color: Colors.black),
  value: selectedDay,
  onChanged: (day) {
    setState(() {
      dayTimings[subject] = {
        day!: ""
      };
    });
  },
  items: [
  const  DropdownMenuItem<String>(
      value: null,
      child:  Text(
        "Select a day",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
    for (String value in [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ])
      DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      ),
  ],
),

                      
                        ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: CustomTimePicker(
                                  icon: Icons.time_to_leave_outlined,
                                  labelText: "Start Time",
                                  selectedTime: timings['start'],
                                  onTimeChanged: (time) => _handleSubjectTiming(
                                    subject,
                                    selectedDay!,
                                    'start',
                                    time,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CustomTimePicker(
                                  icon: Icons.time_to_leave_outlined,
                                  labelText: "End Time",
                                  selectedTime: timings['end'],
                                  onTimeChanged: (time) => _handleSubjectTiming(
                                    subject,
                                    selectedDay!,
                                    'end',
                                    time,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(), // Add a divider to separate subjects
                      ],
                    );
                  },
                ),
              ),
              // Custom button added outside the ListView.builder
              Padding(
                padding: EdgeInsets.all(16.0.w),
                child: CustomButton(
                  onTap: saveTheInstructorData,
                  width: 200,
                  height: 40,
                  text: "Done",
                  bgColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),

        // showing an loading bar if loading is true
        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }
}
