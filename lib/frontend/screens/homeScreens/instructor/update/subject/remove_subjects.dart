import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zant/frontend/providers/home/instructor_provider.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';


class RemoveSubjects extends StatefulWidget {
  final List<String> subjectList;

  const RemoveSubjects({
    Key? key,
    required this.subjectList,
  }) : super(key: key);

  @override
  State<RemoveSubjects> createState() => _RemoveSubjectsState();
}

class _RemoveSubjectsState extends State<RemoveSubjects> {
  List<String> selectedSubjects = []; // To store selected subjects
  bool _isLoading = false;

  void _removeSubjects() async {
    if (selectedSubjects.isEmpty) {
      // Show an error message if no subjects are selected
      showCustomToast("Select at least one subject to remove.");
    } else {
      setState(() {
        _isLoading = true;
      });
      // Remove the selected subjects
        final instructorProvider =
          Provider.of<InstructorProviders>(context, listen: false);
      await instructorProvider.removeSubjectsProvider(subjectsToRemove: selectedSubjects);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            backgroundColor: appBarColor,
            title: "Remove Subjects",
          ),
          body: widget.subjectList.isEmpty
              ? Center(
                  child: Text(
                    "You don't have any subjects ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: widget.subjectList.length,
                  itemBuilder: (context, index) {
                    final subject = widget.subjectList[index];
                    final isSelected = selectedSubjects.contains(subject);

                    return ListTile(
                      title: Text(
                        subject,
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (bool? newValue) {
                          setState(() {
                            if (newValue != null) {
                              if (newValue) {
                                selectedSubjects.add(subject);
                              } else {
                                selectedSubjects.remove(subject);
                              }
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
          floatingActionButton: widget.subjectList.isEmpty
              ? null // Hide the button when the list is empty
              : ElevatedButton(
                  onPressed: () {
                    _removeSubjects();
                  },
                  child: const Text("Remove"),
                ),
        ),
        // Show loading overlay if _isLoading is true
        if (_isLoading) const CustomLoadingOverlay(),
      ],
    );
  }
}
