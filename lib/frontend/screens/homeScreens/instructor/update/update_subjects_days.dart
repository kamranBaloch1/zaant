import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zaanth/frontend/providers/home/instructor_provider.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';

class UpdateSubjectDaysScreen extends StatefulWidget {
  final Map<String, List<String>> selectedDaysOfSubjects;

  const UpdateSubjectDaysScreen({
    Key? key,
    required this.selectedDaysOfSubjects,
  }) : super(key: key);

  @override
  State<UpdateSubjectDaysScreen> createState() =>
      _UpdateSubjectDaysScreenState(selectedDaysOfSubjects);
}

class _UpdateSubjectDaysScreenState extends State<UpdateSubjectDaysScreen> {
  bool _isLoading = false;
  Map<String, List<String>> _updatedSelectedDays;

 _UpdateSubjectDaysScreenState(Map<String, List<String>> selectedDaysOfSubjects)
    : _updatedSelectedDays = Map.from(selectedDaysOfSubjects);

  void _handleCheckboxChange(String subject, String day, bool value) {
    setState(() {
      if (value) {
        if (_updatedSelectedDays.containsKey(subject)) {
          _updatedSelectedDays[subject]!.add(day);
        } else {
          _updatedSelectedDays[subject] = [day];
        }
      } else {
        if (_updatedSelectedDays.containsKey(subject)) {
          _updatedSelectedDays[subject]!.remove(day);
        }
      }
    });
  }


void _updateSelectedDays() {
  // Create a copy of the selectedDaysOfSubjects
  Map<String, List<String>> updatedData = {};

  // Validate that at least one day is selected for each subject
  bool isValid = true;

  for (final subject in widget.selectedDaysOfSubjects.keys) {
    final days = _updatedSelectedDays[subject] ?? [];

    if (days.isNotEmpty) {
      updatedData[subject] = days;
    }
    else {
      isValid = false;
    }
  }

  if (!isValid) {
    // Show an error message to the user and prevent the update action
    showCustomToast("Please select at least one day for each subject.");
    return;
  }

  setState(() {
    _isLoading = true;
  });

  // Call your backend update method with the updated data
  final instructorProvider = Provider.of<InstructorProviders>(context, listen: false);
  instructorProvider
      .updateInstructorSubjectsDaysProvider(selectedDaysForSubjects: updatedData)
      .then((_) {
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
          appBar: const CustomAppBar(
            backgroundColor: appBarColor,
            title: "Change subject days",
          ),
          body: widget.selectedDaysOfSubjects.isEmpty
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
              : ListView.builder(
                  itemCount: widget.selectedDaysOfSubjects.length + 1,
                  itemBuilder: (context, index) {
                    if (index < widget.selectedDaysOfSubjects.length) {
                      final subject =
                          widget.selectedDaysOfSubjects.keys.elementAt(index);
                      final days = _updatedSelectedDays[subject] ?? [];

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
                                        EdgeInsets.symmetric(horizontal: 8.w),
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
                                          value: days.contains(day),
                                          onChanged: (value) {
                                            _handleCheckboxChange(subject, day, value!);
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
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 40.h, horizontal: 80.w),
                        child: CustomButton(
                          onTap: _isLoading ? null : _updateSelectedDays,
                          width: 200,
                          height: 40,
                          text: "Update",
                          bgColor: Colors.blue,
                        ),
                      );
                    }
                  },
                ),
        ),
        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }
}
