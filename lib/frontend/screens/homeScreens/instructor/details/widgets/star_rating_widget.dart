
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
