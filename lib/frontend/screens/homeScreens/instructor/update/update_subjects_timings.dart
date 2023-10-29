import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zant/frontend/providers/home/instructor_provider.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/custom_time_picker.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/global/colors.dart';

class UpdateSubjectsTimingsScreen extends StatefulWidget {
  final Map<String, Map<String, Map<String, String>>>
      selectedTimingsForSubjects;

  const UpdateSubjectsTimingsScreen({
    Key? key,
    required this.selectedTimingsForSubjects,
  }) : super(key: key);

  @override
  State<UpdateSubjectsTimingsScreen> createState() =>
      _UpdateSubjectsTimingsScreenState();
}

class _UpdateSubjectsTimingsScreenState
    extends State<UpdateSubjectsTimingsScreen> {
  Map<String, Map<String, TimeOfDay?>> subjectTimings = {};
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _subjectToUpdate; // Store the subject that needs to be updated

  @override
  void initState() {
    super.initState();
    try {
      // Initialize subjectTimings with the values from selectedTimingsForSubjects
      _initializeSubjectTimings();
    } catch (error) {
      // Handle the error here, e.g., print it to the console
      print("Error during initialization: $error");
      
    }
  }

  // Helper function to initialize subjectTimings
  void _initializeSubjectTimings() {
    widget.selectedTimingsForSubjects.forEach((subject, timings) {
      final startTime = timings['Start Time']?['time'] ?? '00:00';
      final endTime = timings['End Time']?['time'] ?? '00:00';

      // Parsing and processing start and end times
      final startParts = startTime.split(' ');
      final endParts = endTime.split(' ');

      final timeParts = startParts[0].split(':');
      final startTimeHour = int.parse(timeParts[0]);
      final startTimeMinute = int.parse(timeParts[1]);

      final timeParts2 = endParts[0].split(':');
      final endTimeHour = int.parse(timeParts2[0]);
      final endTimeMinute = int.parse(timeParts2[1]);

      // Convert "pm" hours to 24-hour format
      int adjustedStartTimeHour = startTimeHour;
      if (startParts[1] == 'pm' && startTimeHour != 12) {
        adjustedStartTimeHour += 12;
      }

      int adjustedEndTimeHour = endTimeHour;
      if (endParts[1] == 'pm' && endTimeHour != 12) {
        adjustedEndTimeHour += 12;
      }

      final startTimeOfDay = TimeOfDay(
        hour: adjustedStartTimeHour,
        minute: startTimeMinute,
      );

      final endTimeOfDay = TimeOfDay(
        hour: adjustedEndTimeHour,
        minute: endTimeMinute,
      );

      subjectTimings[subject] = {
        'start': startTimeOfDay,
        'end': endTimeOfDay,
      };
    });
  }

  // Update subject timings when a time is changed
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
      _subjectToUpdate = subject; // Store the subject that needs to be updated
    });
  }

  // Update subject timings on the server
  void _updateSubjectTimings() async {
    if (!_isUpdating && _subjectToUpdate != null) {
      // Check if an update is not already in progress and a subject is to be updated
      setState(() {
        _isLoading = true;
        _isUpdating = true; // Set the flag to indicate an update is in progress
      });

      final timings = subjectTimings[_subjectToUpdate!] ?? {};
      final startTime = timings['start'] ?? const TimeOfDay(hour: 0, minute: 0);
      final endTime = timings['end'] ?? const TimeOfDay(hour: 0, minute: 0);

      // Format start and end times to "hh:mm am/pm" format
      final formattedStartTime = _formatTime(startTime);
      final formattedEndTime = _formatTime(endTime);

      final newTimings = {
        'Start Time': {'time': formattedStartTime},
        'End Time': {'time': formattedEndTime},
      };

      // Update only the selected subject
      final instructorProvider =
          Provider.of<InstructorProviders>(context, listen: false);

      await instructorProvider.updateInstructorSubjectTimingProvider(
        subject: _subjectToUpdate!,
        newTimings: newTimings,
      );

      setState(() {
        _isLoading = false;
        _isUpdating = false;
        _subjectToUpdate = null; // Reset the subject to update
      });
    }
  }

  // Helper function to format TimeOfDay to "hh:mm am/pm" format
  String _formatTime(TimeOfDay time) {
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
            title:"Update timings for subjects",
          ),
          body:  widget.selectedTimingsForSubjects.isEmpty
              ? Center(
                  child: Text(
                    "You don't have any subjects",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              :  Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: subjectTimings.length,
                  itemBuilder: (context, index) {
                    final subject = subjectTimings.keys.toList()[index];
                    final timings = subjectTimings[subject] ?? {};

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.sp,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                padding:
                    EdgeInsets.symmetric(vertical: 50.h, horizontal: 100.w),
                child: CustomButton(
                  onTap: _isLoading ? null : _updateSubjectTimings,
                  width: 200,
                  height: 40,
                  text: "Update",
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
