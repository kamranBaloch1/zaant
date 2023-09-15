import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/home/search_screen.dart';


class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
          Get.to(()=> const SearchScreen());
      },
      child: Material(
        elevation: 4, // Add a shadow effect
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: double.infinity, // Set the width to occupy the available space
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Perform search action
                },
              ),
              SizedBox(width: 8.w),
               Expanded(
                child: Text(
                  'Search Service',
                  style: TextStyle(fontSize: 16.sp,color: Colors.black,fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(width: 16.w),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  // Open filter options
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
