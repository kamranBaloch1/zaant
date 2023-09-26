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
  final Map<String, List<String>> selectedDaysForSubjects;

  const SelectTimingsScreen({
    Key? key,
    required this.selectedSubjects,
    required this.selectedQualification,
    required this.phoneNumber,
    required this.feesPerHour,
    required this.selectedDaysForSubjects,
  }) : super(key: key);

  @override
  State<SelectTimingsScreen> createState() => _SelectTimingsScreenState();
}

class _SelectTimingsScreenState extends State<SelectTimingsScreen> {
  Map<String, Map<String, TimeOfDay>> subjectTimings = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
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

  Future<void> _sendVerificationCode() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Check if all subjects have timings selected
      bool allSubjectsTimed = widget.selectedSubjects.every((subject) {
        final timings = subjectTimings[subject] ?? {};
        return timings.containsKey('start') && timings.containsKey('end');
      });

      if (!allSubjectsTimed) {
        // Display an error message if any subject is missing timing information
        showCustomToast("Please select timings for all subjects.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Proceed to send the verification code

      // Convert TimeOfDay objects to strings
      Map<String, Map<String, Map<String, String>>> selectedTimings = {};
      subjectTimings.forEach((subject, timings) {
        selectedTimings[subject] = {
          'Start Time': {
            'time': "${timings['start']!.hour}:${timings['start']!.minute}",
          },
          'End Time': {
            'time': "${timings['end']!.hour}:${timings['end']!.minute}",
          },
        };
      });

      final instructorProvider =
          Provider.of<InstructorProviders>(context, listen: false);

      await instructorProvider.addInstructorProvider(
        phoneNumber: widget.phoneNumber!,
        qualification: widget.selectedQualification!,
        subjects: widget.selectedSubjects,
        feesPerHour: widget.feesPerHour!,
        selectedTimingsForSubjects: selectedTimings,
        selectedDaysForSubjects: widget.selectedDaysForSubjects,
      );

      setState(() {
        _isLoading = false;
      });

      // Show a success message or navigate to the next screen if needed
      showCustomToast("Verification code sent successfully.");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast("An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            backgroundColor: appBarColor,
            title: "Select timings for subjects",
          ),
          body: Column(
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
                                  icon: Icons.access_time,
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
                                  icon: Icons.access_time,
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
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0.w),
                child: CustomButton(
                  onTap: _isLoading ? null : _sendVerificationCode,
                  width: 200,
                  height: 40,
                  text: "Done",
                  bgColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),

        // Showing a loading overlay if _isLoading is true
        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }
}
