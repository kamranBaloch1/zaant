import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zaanth/frontend/screens/homeScreens/home/search_result_screen.dart';

import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/pick_subejcts_dropdown.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';
import 'package:zaanth/server/home/instructor_methods.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}): super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> _selectedSubjects = [];
  String? _selectedGender;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _searchFieldController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(
            backgroundColor: appBarColor,            title: "Search Instructor",
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 5.0,
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: TextFormField(
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          onChanged: (query) {
                            // Handle onChanged
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please write the area name';
                            }
                            return null;
                          },
                          controller: _searchFieldController,
                          decoration: InputDecoration(
                            hintText: "Write the area name",
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5.0,
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PickSubjectsDropdown(
                              selectedSubjects: _selectedSubjects,
                              onChanged: (selectedSubjects) {
                                setState(() {
                                  _selectedSubjects = selectedSubjects;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5.0,
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Instructor gender:',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildGenderButton('male', Icons.boy),
                                  SizedBox(width: 10.w),
                                  _buildGenderButton('female', Icons.girl),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5.0,
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price Range:',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.black),
                                    controller: _minPriceController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'From',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.black),
                                    controller: _maxPriceController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'To',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: ElevatedButton(
            onPressed: () async {
               if(_formKey.currentState!.validate()){
                 await _performSearch(context);
               }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: const Text('Search'),
          ),
        ),
        // showing an loading bar if loading is true

        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }

  Widget _buildGenderButton(String gender, IconData icon) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedGender == gender ? Colors.blue : Colors.white,
      ),
      child: Row(
        children: [
          Icon(icon,
              color: _selectedGender == gender ? Colors.white : Colors.black),
          SizedBox(width: 8.w),
          Text(
            gender,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: _selectedGender == gender ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performSearch(BuildContext context) async {
    String address = _searchFieldController.text.trim();
    String gender = _selectedGender ?? "";
    int minPrice = int.tryParse(_minPriceController.text.trim()) ?? 0;
    int maxPrice =
        int.tryParse(_maxPriceController.text.trim()) ?? (1 << 63) - 1;

    try {
      setState(() {
        _isLoading = true;
      });

      // Create a new StreamController instance
      StreamController<List<Map<String, dynamic>>> searchResultController =
          StreamController<List<Map<String, dynamic>>>();

      List<Map<String, dynamic>> searchResults =

      
          await InstructorMethods().searchInstructors(
        address: address,
        gender: gender,
        minPrice: minPrice,
        maxPrice: maxPrice,
        subjects: _selectedSubjects,
      );

      // Update the stream with the search results
      searchResultController.add(searchResults);
      // Navigate to SearchResultScreen
      Get.to(() => SearchResultScreen(
            searchResultController: searchResultController,
          ));

      // Dispose of the StreamController when it's no longer needed
      searchResultController.close();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors, e.g., show an error message
      showCustomToast('Error during search');
    }
  }
}
