import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/update_instructor_subjects_widget.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/global/colors.dart';

class UpdateSubjectsScreen extends StatefulWidget {
  final List<String> selectedSubjects;

  const UpdateSubjectsScreen({
    Key? key,
    required this.selectedSubjects,
  }) : super(key: key);

  @override
  _UpdateSubjectsScreenState createState() => _UpdateSubjectsScreenState();
}

class _UpdateSubjectsScreenState extends State<UpdateSubjectsScreen> {
  List<String> _selectedSubjects = [];

  @override
  void initState() {
    super.initState();
    _selectedSubjects.addAll(widget.selectedSubjects);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backgroundColor: appBarColor, title: "Update Subjects"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: UpdateInstructorSubjectsWidgets(
                selectedSubjects: _selectedSubjects,
                onChanged: (selectedSubjects) {
                  setState(() {
                    _selectedSubjects = selectedSubjects;
                  });
                },
              ),
            ),
            SizedBox(height: 100.h,),
            CustomButton(width: 200, height: 40, text:"update", bgColor: Colors.blue)
          ],
        ),
      ),
    );
  }
}
