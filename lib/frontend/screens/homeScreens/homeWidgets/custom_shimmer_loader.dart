import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
class CustomShimmerLoadingBar extends StatelessWidget {
  const CustomShimmerLoadingBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 200.w,
              height: 24.h,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 150.w,
              height: 16.h,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 250.w,
              height: 16.h,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
