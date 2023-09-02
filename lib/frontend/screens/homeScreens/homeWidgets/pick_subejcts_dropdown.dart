import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class PickSubjectsDropdown extends StatefulWidget {
  final List<String> selectedSubjects;
  final ValueChanged<List<String>> onChanged;

  const PickSubjectsDropdown({
    Key? key,
    required this.selectedSubjects,
    required this.onChanged,
  }) : super(key: key);

  @override
  _PickSubjectsDropdownState createState() => _PickSubjectsDropdownState();
}

class _PickSubjectsDropdownState extends State<PickSubjectsDropdown> {
  List<String> _subjectsList = [
    "Mathematics",
    "Science",
    "English",
    "History",
    // Add more subjects as needed...
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
        MultiSelectDialogField(
          onConfirm: (selectedItems) {
            List<String> selectedSubjects =
                selectedItems.map((item) => item.toString()).toList();
            widget.onChanged(selectedSubjects);
          },
          items: _subjectsList
              .map((subject) => MultiSelectItem<String>(subject, subject))
              .toList(),
          listType: MultiSelectListType.CHIP,
          // Remove initialValue to prevent selected subjects from appearing in the dropdown
          // initialValue: widget.selectedSubjects,
          onSelectionChanged: (selectedSubjects) {
            setState(() {
              widget.onChanged(selectedSubjects);
            });
          },
          buttonText: const Text(
            "Select Subjects",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[200]!,
            ),
          ),
        ),
        
        
          
      ],
    );
  }
}
