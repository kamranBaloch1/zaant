import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zaanth/frontend/models/home/instructor_model.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/details/instructor_details_screen.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/global/colors.dart';

class SearchResultScreen extends StatelessWidget {
  final StreamController<List<Map<String, dynamic>>> searchResultController;

  const SearchResultScreen({
    Key? key,
    required this.searchResultController,
  }) : super(key: key);

  Widget _buildInstructorTile(Map<String, dynamic> instructorData) {
    // Extract instructor information
    final String instructorName = instructorData['name'];
    final String instructorLocation = instructorData['address'];
    final String instructorProfilePicUrl = instructorData['profilePicUrl'];
    final String city = instructorData['city'];
    final String gender = instructorData['gender'];
    final double instructorRating = instructorData['ratings'] ?? 0.0;
    final List<String> subjects = List<String>.from(instructorData['subjects'] ?? []);

    return GestureDetector(
      onTap: () {
        // Navigate to the detailed instructor screen
        Get.to(()=> InstructorDetailScreen(instructorModel: InstructorModel.fromMap(instructorData)));
      },
      child: ListTile(
        title: Text(
          instructorName,
          style: const TextStyle(color: Colors.black),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  city,
                  style: const TextStyle(color: Colors.black54),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  instructorLocation,
                  style: const TextStyle(color: Colors.black45),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Gender: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  gender,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            if (subjects.isNotEmpty)
              Row(
                children: [
                  const Text(
                    'Subjects: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subjects.join(', '),
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            Row(
              children: [
                const Text(
                  'Rating: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      color:
                          index < instructorRating ? Colors.amber : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(instructorProfilePicUrl),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        backgroundColor: appBarColor,
        title: "Search Results",
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: searchResultController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while data is being fetched
              return  const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return _buildInstructorTile(snapshot.data![index]);
                },
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error occurred',
                  style: TextStyle(color: Colors.black),
                ),
              );
            } else {
              return  Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 360.h),
                  child: const Text(
                    'No results found',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
