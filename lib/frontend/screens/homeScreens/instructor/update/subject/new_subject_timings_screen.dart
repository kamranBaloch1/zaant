import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zaanth/frontend/providers/home/instructor_provider.dart';
import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/custom_time_picker.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';

class AddNewSubjectTimingsScreen extends StatefulWidget {
  final List<String> selectedSubjects;
  final Map<String, List<String>> selectedDaysForSubjects;

  const AddNewSubjectTimingsScreen({
    Key? key,
    required this.selectedSubjects,
    required this.selectedDaysForSubjects,
  }) : super(key: key);

  @override
  State<AddNewSubjectTimingsScreen> createState() =>
      _AddNewSubjectTimingsScreenState();
}

class _AddNewSubjectTimingsScreenState
    extends State<AddNewSubjectTimingsScreen> {
  Map<String, Map<String, TimeOfDay?>> subjectTimings = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize subjectTimings with null values for selectedSubjects
    for (String subject in widget.selectedSubjects) {
      subjectTimings[subject] = {
        'start': null,
        'end': null,
      };
    }
  }

  void _handleSubjectTiming(
    String subject,
    String timeType,
    TimeOfDay? time,
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

      // Convert TimeOfDay objects to formatted strings
      Map<String, Map<String, Map<String, String>>> selectedTimings = {};

      // Populate selectedTimings based on user input
      for (String subject in widget.selectedSubjects) {
        final timings = subjectTimings[subject] ?? {};
        selectedTimings[subject] = {
          'Start Time': {
            'time': _formatTime(timings['start']),
          },
          'End Time': {
            'time': _formatTime(timings['end']),
          },
        };
      }

      // Call the backend method to add new subjects with timings

      final instructorProvider =
          Provider.of<InstructorProviders>(context, listen: false);

      await instructorProvider.addNewSubjectsProvider(
        newSubjects: widget.selectedSubjects,
        selectedTimingsForSubjects: selectedTimings,
        selectedDaysForSubjects: widget.selectedDaysForSubjects,
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast("An error occurred: $e");
    }
  }

  // Helper function to format TimeOfDay to "hh:mm am/pm" format
  String _formatTime(TimeOfDay? time) {
    if (time == null) return "";
    final hour = time.hourOfPeriod;
    final minute = time.minute;
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(
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
        if (_isLoading) const CustomLoadingOverlay(),
      ],
    );
  }
}
