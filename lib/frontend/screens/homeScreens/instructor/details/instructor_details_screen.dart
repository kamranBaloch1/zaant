import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zant/frontend/models/home/instructor_model.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/server/home/instructor_methods.dart';

class InstructorDetailScreen extends StatefulWidget {
  final InstructorModel instructorModel;

  InstructorDetailScreen({required this.instructorModel});

  @override
  State<InstructorDetailScreen> createState() => _InstructorDetailScreenState();
}

class _InstructorDetailScreenState extends State<InstructorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        title: 'Instructor Details',
        backgroundColor: appBarColor,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: InstructorMethods().fetchUserDataForInstrcutorDetailScreen(uid: widget.instructorModel.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading message in the center of the screen.
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('User data not found.'),
            );
          } else {
            final userData = snapshot.data!;
            final name = userData['name'] ?? 'Name not found';
            final gender = userData['gender'] ?? 'Gender not found';
            final profilePicUrl = userData['profileUrl'] ?? 'Profile picture not found';
            final location = userData['location'] ?? 'Location not found';
            final city = userData['city'] ?? 'City not found';

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80.r,
                    backgroundImage: NetworkImage(profilePicUrl),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoCard(
                    icon: Icons.school,
                    title: "Qualification",
                    content: widget.instructorModel.qualification,
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoCard(
                    icon: Icons.location_on,
                    title: "Location",
                    content: location,
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoCard(
                    icon: Icons.location_city,
                    title: "City",
                    content: city,
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoCard(
                    icon: Icons.attach_money,
                    title: "Fees per Hour",
                    content: "\$${widget.instructorModel.feesPerHour.toString()}",
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoCard(
                    icon: Icons.phone,
                    title: "Phone Number",
                    content: widget.instructorModel.phoneNumber,
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoCard(
                    icon: widget.instructorModel.isPhoneNumberVerified
                        ? Icons.verified
                        : Icons.info_outline,
                    title: "Phone Number Verification",
                    content: widget.instructorModel.isPhoneNumberVerified
                        ? "Verified"
                        : "Not Verified",
                  ),
                  _buildInfoCard(
                    icon: gender == "male" ? Icons.male : Icons.female,
                    title: "Gender",
                    content: gender,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(height: 20.h),
                  _buildInfoCard(
                    icon: Icons.subject,
                    title: "Subjects",
                    content: widget.instructorModel.subjects.isNotEmpty
                        ? widget.instructorModel.subjects.join(", ")
                        : "No subjects specified",
                  ),
                  SizedBox(height: 20.h),
                  _buildDaysCard(widget.instructorModel.selectedDaysForSubjects),
                  // Display selected timings
                  _buildSelectedTimings(widget.instructorModel.selectedTimingsForSubjects),
                  SizedBox(height: 20.h),
                  _buildRatingCard(widget.instructorModel.ratings.toDouble()),
                  SizedBox(height: 16.h),
                  _buildInfoCard(
                    icon: Icons.chat_bubble,
                    title: "Reviews",
                    content: widget.instructorModel.reviews.isEmpty
                        ? "No reviews yet."
                        : widget.instructorModel.reviews.join("\n"),
                  ),
                  SizedBox(height: 30.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle edit button press
                    },
                    icon: Icon(Icons.edit),
                    label: Text('Edit Instructor'),
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle delete button press
                    },
                    icon: Icon(Icons.delete),
                    label: Text('Delete Instructor'),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String content}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 32.sp,
          color: Colors.blue, // Customize icon color
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Text color
          ),
        ),
        subtitle: Text(
          content,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black, // Text color
          ),
        ),
      ),
    );
  }

  Widget _buildRatingCard(double rating) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          Icons.star,
          size: 32.sp,
          color: Colors.blue, // Customize icon color
        ),
        title: Text(
          "Ratings",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Text color
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black, // Text color
              ),
            ),
            SizedBox(width: 8.w),
            // Display stars here (create a custom widget)
            StarRating(rating: rating),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysCard(Map<String, List<String>> daysForSubjects) {
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
              Icons.calendar_today,
              size: 32.sp,
              color: Colors.blue, // Customize icon color
            ),
            title: Text(
              "Days",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: daysForSubjects.entries.map((entry) {
                final subjectName = entry.key;
                final daysList = entry.value.join(", ");
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subjectName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Text color
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      daysList,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black, // Text color
                      ),
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

Widget _buildSelectedTimings(Map<String, Map<String, Map<String, String>>> selectedTimings) {
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
            color: Colors.blue, // Customize icon color
          ),
          title: Text(
            "Selected Timings",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Text color
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
                      color: Colors.black, // Text color
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
                              color: Colors.black, // Text color
                            ),
                          ),
                          Text(
                            time!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black, // Text color
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

class StarRating extends StatelessWidget {
  final double rating;

  StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    final double starSize = 20.w;
    final int totalStars = 5;
    final int fullStars = rating ~/ 1;
    final double halfStar = rating - fullStars.toDouble();

    return Row(
      children: List.generate(totalStars, (index) {
        if (index < fullStars) {
          return Icon(
            Icons.star,
            size: starSize,
            color: Colors.yellow,
          );
        } else if (index == fullStars && halfStar > 0) {
          return Icon(
            Icons.star_half,
            size: starSize,
            color: Colors.yellow,
          );
        } else {
          return Icon(
            Icons.star_border,
            size: starSize,
            color: Colors.yellow,
          );
        }
      }),
    );
  }
}
