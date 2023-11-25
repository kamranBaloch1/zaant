import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zaanth/frontend/providers/home/instructor_provider.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';
import 'package:zaanth/server/home/instructor_methods.dart';

class UpdateGradeLevelScreen extends StatefulWidget {
  final List<String>? selectedGradeLevel;

  const UpdateGradeLevelScreen({
    Key? key,
    required this.selectedGradeLevel,
  }) : super(key: key);

  @override
  State<UpdateGradeLevelScreen> createState() => _UpdateGradeLevelScreenState();
}

class _UpdateGradeLevelScreenState extends State<UpdateGradeLevelScreen> {
  late List<String> selectedGrades;
  List<String> selectedNewGrades = [];
  int? expandedPanel;
  int? selectedGradeIndex;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedGrades = List<String>.from(widget.selectedGradeLevel ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        backgroundColor: appBarColor,
        title: "Change your Grade level",
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                _buildPanel(
                  index: 0,
                  title: "Remove a Grade Level",
                  body: _buildRemoveGradeLevelPanel,
                ),
                SizedBox(height: 10.h),
                _buildPanel(
                  index: 1,
                  title: "Add new Grade Level",
                  body: _buildAddGradeLevelPanel,
                ),
              ],
            ),
          ),
          if (_isLoading) const CustomLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildRemoveGradeLevelPanel() {
    return Column(
      children: [
        // Existing code for generating the list of grade levels
        Column(
          children: List.generate(selectedGrades.length, (index) {
            final grade = selectedGrades[index];
            final isSelected = selectedGradeIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedGradeIndex = isSelected ? null : index;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[100] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      grade,
                      style: TextStyle(fontSize: 16.sp, color: Colors.black),
                    ),
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle,
                      color: isSelected ? Colors.blueAccent : Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 20.h),
        CustomButton(
          onTap: () async {
            _handleRemoveGrade();
          },
          width: 200,
          height: 40,
          text: "Remove",
          bgColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildAddGradeLevelPanel() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2.r,
            blurRadius: 5.r,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16.w,
        runSpacing: 16.w,
        children: [
          _buildGradeLevelOption("PlayGroup to Nursery"),
          _buildGradeLevelOption("1st to 5th"),
          _buildGradeLevelOption("6th to 8th"),
          _buildGradeLevelOption("6th to 10th"),
          _buildGradeLevelOption("9th to 10th"),
          _buildGradeLevelOption("11th to 12th"),
          _buildGradeLevelOption("1st to 12th"),
          SizedBox(height: 20.h),
          CustomButton(
            onTap: () async {
              _handleAddGrade();
            },
            width: 300,
            height: 40,
            text: "Update",
            bgColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildGradeLevelOption(String gradeLevel) {
    bool isSelected = selectedNewGrades.contains(gradeLevel);
    bool isDisabled = selectedNewGrades.length >= 1 && !isSelected;

    return InkWell(
      onTap: () {
        _handleGradeLevelOptionTap(isDisabled, isSelected, gradeLevel);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent
              : (isDisabled ? Colors.grey[300] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.blueAccent.withOpacity(0.3)
                  : Colors.transparent,
              spreadRadius: 2.r,
              blurRadius: 5.r,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          gradeLevel,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDisabled ? Colors.grey[600] : Colors.black),
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPanel(
      {required int index,
      required String title,
      required Widget Function() body}) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _handlePanelTap(index);
          },
          child: Container(
            padding: EdgeInsets.all(16.w),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (expandedPanel == index) body(),
      ],
    );
  }

  void _handleRemoveGrade() async {
    if (selectedGradeIndex != null) {
      setState(() {
        _isLoading = true;
      });

      String gradeToRemove = selectedGrades[selectedGradeIndex!];

      await Provider.of<InstructorProviders>(context, listen: false)
          .removeSelectedGradesProvider(selectedGrades: [gradeToRemove]);

      setState(() {
        selectedGradeIndex = null;
        _isLoading = false;
      });
    } else {
      showCustomToast("Please select a grade to remove.");
    }
  }

  void _handleAddGrade() async {
    if (selectedNewGrades.isNotEmpty && selectedNewGrades.length <= 1) {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<InstructorProviders>(context, listen: false)
          .updateSelectedGradesProvider(selectedNewGrades: selectedNewGrades);

      await InstructorMethods().updateSelectedGrades(
          selectedNewGrades: selectedNewGrades);

      setState(() {
        selectedNewGrades.clear();
        _isLoading = false;
      });
    } else {
      showCustomToast("Please select at least one grade.");
    }
  }

  void _handleGradeLevelOptionTap(
      bool isDisabled, bool isSelected, String gradeLevel) {
    setState(() {
      if (isDisabled) {
        return;
      }

      if (isSelected) {
        selectedNewGrades.remove(gradeLevel);
      } else {
        selectedNewGrades.add(gradeLevel);
      }
    });
  }

  void _handlePanelTap(int index) {
    setState(() {
      expandedPanel = expandedPanel == index ? null : index;
    });
  }
}
