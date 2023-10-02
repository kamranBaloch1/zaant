import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowTimingWidget extends StatelessWidget {
  const ShowTimingWidget({
    Key? key,
    required this.selectedTimings,
  }) : super(key: key);

  final Map<String, Map<String, Map<String, String>>> selectedTimings;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(
              Icons.access_time,
              size: 32.sp,
              color: Colors.blue,
            ),
            title: Text(
              "Timings",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedTimings.entries.map((entry) {
                final subjectName = entry.key;
                final timings = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subjectName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: timings.entries.map((timingEntry) {
                        final timeType = timingEntry.key;
                        final timeData = timingEntry.value;
                        final time = timeData['time'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              timeType,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              time ?? 'No time available', // Handle null time
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4.h),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 8.h),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
