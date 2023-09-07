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
  final String? phoneNumber;
  final int? feesPerHour;
final  Map<String, List<String>> selectedDays;

  const SelectTimingsScreen({
    Key? key,
    required this.selectedSubjects,
    required this.selectedQualification,
    required this.phoneNumber,
    required this.feesPerHour,
    required this.selectedDays,
  }) : super(key: key);

  @override
  State<SelectTimingsScreen> createState() => _SelectTimingsScreenState();
}

class _SelectTimingsScreenState extends State<SelectTimingsScreen> {
  Map<String, Map<String, TimeOfDay>> subjectTimings = {};
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

  void _handleSubjectTiming(
    String subject,
    String timeType,
    TimeOfDay time,
  ) {
    setState(() {
      if (!subjectTimings.containsKey(subject)) {
        subjectTimings[subject] = {};
      }
      subjectTimings[subject]![timeType] = time;
    });
  }

  // Rest of your code...

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
                  onTap: (){},
                  // saveTheInstructorData,
                  width: 200,
                  height: 40,
                  text: "Done",
                  bgColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),

        // showing a loading bar if loading is true
        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }
}
