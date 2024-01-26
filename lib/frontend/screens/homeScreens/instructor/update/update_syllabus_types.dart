import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zaanth/frontend/providers/home/instructor_provider.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';

class UpdateSyllabusTypesScreen extends StatefulWidget {
  final List<String>? selectedsyllabusTypes;

  const UpdateSyllabusTypesScreen({
    Key? key,
    required this.selectedsyllabusTypes,
  }) : super(key: key);

  @override
  State<UpdateSyllabusTypesScreen> createState() =>
      _UpdateSyllabusTypesScreenState();
}

class _UpdateSyllabusTypesScreenState extends State<UpdateSyllabusTypesScreen> {
  late List<String> selectedSyllabusTypes;
  List<String> selectedNewSyllabusTypes = [];
  int? expandedPanel;
  int? selectedSyllabusTypesIndex;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedSyllabusTypes =
        List<String>.from(widget.selectedsyllabusTypes ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(
            backgroundColor: appBarColor,
            title: "Change your syllabus types",
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                _buildPanel(
                  index: 0,
                  title: "Remove a Syllabus Type",
                  body: _buildRemoveSyllabusTypesPanel,
                ),
                SizedBox(height: 10.h),
                _buildPanel(
                  index: 1,
                  title: "Add new Syllabus Type",
                  body: _buildAddSyllabusTypesPanel,
                ),
              ],
            ),
          ),
        ),

        // loading bar when isLoading is true
        if (_isLoading) const CustomLoadingOverlay(),
      ],
    );
  }

  Widget _buildRemoveSyllabusTypesPanel() {
    return Column(
      children: [
        // Existing code for generating the list of grade levels
        Column(
          children: List.generate(selectedSyllabusTypes.length, (index) {
            final grade = selectedSyllabusTypes[index];
            final isSelected = selectedSyllabusTypesIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSyllabusTypesIndex = isSelected ? null : index;
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
            _handleRemoveSyllabus();
          },
          width: 200,
          height: 40,
          text: "Remove",
          bgColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildAddSyllabusTypesPanel() {
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
          _buildSyllabusTypesOption("Karachi Board"),
          _buildSyllabusTypesOption("Balochistan Borad"),
          _buildSyllabusTypesOption("Sindh Board"),
          _buildSyllabusTypesOption("Punjab Board"),
          _buildSyllabusTypesOption("Federal Board"),
          _buildSyllabusTypesOption("KPK Board"),
          SizedBox(height: 20.h),
          CustomButton(
            onTap: () async {
              _handleAddSyllabus();
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

  Widget _buildSyllabusTypesOption(String syllabusType) {
    bool isSelected = selectedNewSyllabusTypes.contains(syllabusType);
    bool isDisabled = selectedNewSyllabusTypes.isNotEmpty && !isSelected;

    return InkWell(
      onTap: () {
        _handleSyllabusTypesOptionTap(isDisabled, isSelected, syllabusType);
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
          syllabusType,
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

  void _handleRemoveSyllabus() async {
    if (selectedSyllabusTypesIndex != null) {
      setState(() {
        _isLoading = true;
      });

      String syllabusTypesToRemove =
          selectedSyllabusTypes[selectedSyllabusTypesIndex!];

      await Provider.of<InstructorProviders>(context, listen: false)
          .removeSelectedSyllabusTypesProvider(
              selectedSyllabusTypes: [syllabusTypesToRemove]);

      setState(() {
        selectedSyllabusTypesIndex = null;
        _isLoading = false;
      });
    } else {
      showCustomToast("Please select a syllabus type to remove.");
    }
  }

  void _handleAddSyllabus() async {
    if (selectedNewSyllabusTypes.isNotEmpty &&
        selectedNewSyllabusTypes.length <= 1) {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<InstructorProviders>(context, listen: false)
          .updateSelectedSyllabusTypesProvider(
              selectedSyllabusTypes: selectedNewSyllabusTypes);
      if (mounted) {
        setState(() {
          selectedNewSyllabusTypes.clear();
          _isLoading = false;
        });
      }
    } else {
      showCustomToast("Please select at least one syllabus type.");
    }
  }

  void _handleSyllabusTypesOptionTap(
      bool isDisabled, bool isSelected, String syllabusType) {
    setState(() {
      if (isDisabled) {
        return;
      }

      if (isSelected) {
        selectedNewSyllabusTypes.remove(syllabusType);
      } else {
        selectedNewSyllabusTypes.add(syllabusType);
      }
    });
  }

  void _handlePanelTap(int index) {
    setState(() {
      expandedPanel = expandedPanel == index ? null : index;
    });
  }
}
