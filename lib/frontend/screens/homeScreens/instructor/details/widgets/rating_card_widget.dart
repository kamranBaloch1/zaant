import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/details/widgets/star_rating_widget.dart';

class RatingCardWidget extends StatelessWidget {
  const RatingCardWidget({
    super.key,
    required this.rating,
  });

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          Icons.star,
          size: 32.sp,
          color: Colors.blue,
        ),
        title: Text(
          "Ratings",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 8.w),
            StarRating(rating: rating),
          ],
        ),
      ),
    );
  }
}

