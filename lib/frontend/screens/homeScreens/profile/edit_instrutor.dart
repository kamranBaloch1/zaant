// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:zant/frontend/screens/homeScreens/homeWidgets/custom_home_text_field.dart';
// import 'package:zant/frontend/screens/homeScreens/profile/widgets/select_subject_widgets.dart';
// import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
// import 'package:zant/frontend/screens/widgets/custom_dropdown.dart';
// import 'package:zant/global/colors.dart';

// class EditInstructor extends StatefulWidget {
//   final String? selectedQualification;
//   final String? feesPerHour;
//   final List<String> selectedSubjects;

//   const EditInstructor({
//     Key? key,
//     required this.selectedQualification,
//     required this.feesPerHour,
//     required this.selectedSubjects,
//   }) : super(key: key);

//   @override
//   State<EditInstructor> createState() => _EditInstructorState();
// }

// class _EditInstructorState extends State<EditInstructor> {
//   late final TextEditingController _feesPerHour;
//   String? selectedQualification;
//   List<String> _selectedSubjects = [];
//   List<String> qualificationList = [
//     "Matric",
//     "PhD",
//     "Bachelor",
//     "School Student",
//     "Master"
//   ];

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _feesPerHour.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     // TODO: implement initState

//     _feesPerHour = TextEditingController(text: widget.feesPerHour);
//     selectedQualification = widget.selectedQualification;
//     _selectedSubjects = widget.selectedSubjects;


//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(backgroundColor: appBarColor, title: "Details"),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 20.h,
//           ),
//           homeCustomTextField(
//             controller: _feesPerHour,
//             labelText: "update per hour",
//             icon: Icons.money,
//             keyBoardType: TextInputType.number,
//           ),
//           SizedBox(
//             height: 20.h,
//           ),
//           CustomDropdown(
//               items: qualificationList,
//               value: selectedQualification,
//               onChanged: (value) {
//                 setState(() {
//                   selectedQualification = value; // Store the selected value
//                 });
//               },
//               labelText: "update Qualification",
//               icon: Icons.book),
//           SizedBox(
//             height: 20.h,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: SelectSubjectWidget(
//               selectedSubjects: _selectedSubjects,
//               onChanged: (selectedSubjects) {
//                 setState(() {
//                   _selectedSubjects = selectedSubjects;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
