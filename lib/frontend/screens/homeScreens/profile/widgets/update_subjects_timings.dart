import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/custom_time_picker.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/server/home/profile_methods.dart';

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

    // Initialize subjectTimings with the values from selectedTimingsForSubjects
    widget.selectedTimingsForSubjects.forEach((subject, timings) {
      final startTime = timings['Start Time']?['time'] ?? '00:00';
      final endTime = timings['End Time']?['time'] ?? '00:00';

      final startParts = startTime.split(':');
      final endParts = endTime.split(':');

      final startTimeOfDay = TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      );

      final endTimeOfDay = TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      );

      subjectTimings[subject] = {
        'start': startTimeOfDay,
        'end': endTimeOfDay,
      };
    });
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
      _subjectToUpdate = subject; // Store the subject that needs to be updated
    });
  }

  Future<void> _updateSubjectTimings() async {
    if (!_isUpdating && _subjectToUpdate != null) {
      // Check if an update is not already in progress and a subject is to be updated
      setState(() {
        _isLoading = true;
        _isUpdating = true; // Set the flag to indicate an update is in progress
      });

      final timings = subjectTimings[_subjectToUpdate!] ?? {};
      final startTime = timings['start'] ?? TimeOfDay(hour: 0, minute: 0);
      final endTime = timings['end'] ?? TimeOfDay(hour: 0, minute: 0);

      final newTimings = {
        'Start Time': {
          'time': "${startTime.hour}:${startTime.minute}",
        },
        'End Time': {
          'time': "${endTime.hour}:${endTime.minute}",
        },
      };

      // Update only the selected subject
      await ProfileMethods().updateInstrcutorSubjectTiming(
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            backgroundColor: appBarColor,
            title: "Update timings for subjects",
          ),
          body: Column(
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
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            subject,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                        Divider(),
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
        if (_isLoading) CustomLoadingOverlay()
      ],
    );
  }
}
