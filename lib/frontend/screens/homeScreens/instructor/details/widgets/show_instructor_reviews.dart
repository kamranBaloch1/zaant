import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zant/frontend/providers/home/instructor_provider.dart';

import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';
class ShowInstructorReviewsScreen extends StatelessWidget {
  final String instructorId;
  const ShowInstructorReviewsScreen({
    Key? key,
    required this.instructorId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
Widget buildStarRating(double rating) {
  List<Widget> stars = [];
  for (int i = 0; i < rating; i++) {
    stars.add( const Icon(Icons.star, color: Colors.amber, size: 16));
  }
  return Row(children: stars);
}



    return Scaffold(
      appBar: CustomAppBar(backgroundColor: appBarColor, title: "Reviews"),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future:Provider.of<InstructorProviders>(context,listen: false).fetchReviewsOfInstructorProvider(instructorUid: instructorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child:  Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.black),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No reviews yet.',
                style: TextStyle(color: Colors.black),
              ),
            );
          } else {
            final reviewsData = snapshot.data;

            return ListView.builder(
              itemCount: reviewsData!.length,
              itemBuilder: (context, index) {
                final reviewData = reviewsData[index];
                final userName = reviewData['name'] as String;
                final userProfilePicUrl = reviewData['profilePicUrl'] as String;
                final reviewDate = reviewData['date'] as Timestamp;
                final content = reviewData['content'] as String;
                final ratings = reviewData['ratings'] as double;

                final formattedDate =
                    DateFormat.yMMMd().format(reviewDate.toDate());

                return Padding(
                  padding:  EdgeInsets.all(8.w),
                  child: Card(
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(userProfilePicUrl),
                      ),
                      title: Text(
                        userName,
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                     subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      content,
      style: TextStyle(fontSize: 14.sp, color: Colors.black),
    ),
    buildStarRating(ratings),
    Text(
      formattedDate,
      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
    ),
  ],
),

                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
