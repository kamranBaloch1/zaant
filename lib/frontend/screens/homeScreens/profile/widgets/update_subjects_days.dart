// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';

import 'package:zant/global/colors.dart';

class UpdateSubjectDaysScreen extends StatefulWidget {
  final List<String> selectedSubjects;

  const UpdateSubjectDaysScreen({
    Key? key,
    required this.selectedSubjects,
  }) : super(key: key);

  @override
  State<UpdateSubjectDaysScreen> createState() =>
      _UpdateSubjectDaysScreenState();
}

class _UpdateSubjectDaysScreenState extends State<UpdateSubjectDaysScreen> {
  bool _isLoading = false;

  // Create a map to store selected days for each subject
  Map<String, List<String>> selectedDays = {};

 @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            backgroundColor: appBarColor,
            title: "Update Subject Days",
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
                      EdgeInsets.symmetric(vertical: 40.h, horizontal: 80.w),
                  child: const CustomButton(
                    // onTap: _isLoading ? null : _navigateToNextScreen,

                    width: 200,
                    height: 40,
                    text: "update",
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
