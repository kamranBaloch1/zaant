import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTimePicker extends StatelessWidget {
  final String labelText;
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay)? onTimeChanged;
  final IconData icon;

  CustomTimePicker({
    required this.labelText,
    required this.selectedTime,
    required this.onTimeChanged,
    required this.icon,
  });

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      onTimeChanged?.call(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(icon),
              SizedBox(width: 8.w),
              Text(
                selectedTime?.format(context) ?? 'Select time',
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
