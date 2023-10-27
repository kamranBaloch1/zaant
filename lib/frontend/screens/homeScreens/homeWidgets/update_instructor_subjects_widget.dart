import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateInstructorSubjectsWidgets extends StatefulWidget {
  final List<String> selectedSubjects;
  final ValueChanged<List<String>> onChanged;

  const UpdateInstructorSubjectsWidgets({
    Key? key,
    required this.selectedSubjects,
    required this.onChanged,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UpdateInstructorSubjectsWidgetsState createState() =>
      _UpdateInstructorSubjectsWidgetsState();
}

class _UpdateInstructorSubjectsWidgetsState
    extends State<UpdateInstructorSubjectsWidgets> {
final  List<String> _subjectsList = [
    "Mathematics",
    "Science",
    "English",
    "History",
    "dd",
    "eed",
    "rt",
    "edsse"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Subjects:",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          height: 200.h, // Set a fixed height for the list view
          child: ListView.builder(
             physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _subjectsList.length,
            itemBuilder: (BuildContext context, int index) {
              final subject = _subjectsList[index];
              final isSelected = widget.selectedSubjects.contains(subject);

              return CheckboxListTile(
                title: Text(
                  subject,
                  style: const TextStyle(color: Colors.black),
                ),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      widget.selectedSubjects.add(subject);
                    } else {
                      widget.selectedSubjects.remove(subject);
                    }
                    widget.onChanged(widget.selectedSubjects);
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
