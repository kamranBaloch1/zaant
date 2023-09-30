import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/models/home/instructor_model.dart';
import 'package:zant/frontend/providers/home/enrollmens_provider.dart';
import 'package:zant/frontend/screens/homeScreens/chat/chat_screen.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/show_full_image_dilog.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/details/widgets/build_info_card_widget.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/details/widgets/rating_card_widget.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/details/widgets/show_days_widget.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/details/widgets/show_timings_widget.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/global/colors.dart';

class InstructorDetailScreen extends StatefulWidget {
  final InstructorModel instructorModel;

  const InstructorDetailScreen({Key? key, required this.instructorModel})
      : super(key: key);

  @override
  State<InstructorDetailScreen> createState() => _InstructorDetailScreenState();
}

class _InstructorDetailScreenState extends State<InstructorDetailScreen> {
  bool isEnrolled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Check the enrollment status when the screen is initialized
    checkEnrollmentStatus();
  }

  Future<void> checkEnrollmentStatus() async {
     final enrollmnetsProvider =
        Provider.of<EnrollmentsProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    bool userEnrolled = await enrollmnetsProvider.checkEnrollmentStatusProvider(
        instructorId: widget.instructorModel.uid);
    setState(() {
      isEnrolled = userEnrolled;
      isLoading = false;
    });
  }

  Future<void> enrollUser() async {
    setState(() {
      isLoading = true;
    });
   final enrollmnetsProvider =
        Provider.of<EnrollmentsProvider>(context, listen: false);
    await enrollmnetsProvider.enrollUserToInstructorProvider(
        instructorId: widget.instructorModel.uid);
    setState(() {
      isEnrolled = true;
      isLoading = false;
    });
  }

  Future<void> unenrollTheUser() async {
    setState(() {
      isLoading = true;
    });
    final enrollmnetsProvider =
        Provider.of<EnrollmentsProvider>(context, listen: false);
    await enrollmnetsProvider.unenrollInstructorForUserProvider(
        instructorId: widget.instructorModel.uid);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: 'Instructor Details',
            backgroundColor: appBarColor,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FullImageDialog(
                            imageUrl: widget.instructorModel.profilePicUrl);
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 80.r,
                    backgroundImage: NetworkImage(
                      widget.instructorModel.profilePicUrl,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  widget.instructorModel.name,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: Icons.school,
                  title: "Qualification",
                  content: widget.instructorModel.qualification,
                ),
                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: Icons.location_on,
                  title: "Address",
                  content: widget.instructorModel.address,
                ),
                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: Icons.location_city,
                  title: "City",
                  content: widget.instructorModel.city,
                ),
                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: Icons.attach_money,
                  title: "Fees per Hour",
                  content: "\$${widget.instructorModel.feesPerHour.toString()}",
                ),
                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: Icons.phone,
                  title: "Phone Number",
                  content: widget.instructorModel.phoneNumber,
                ),
                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: widget.instructorModel.isPhoneNumberVerified
                      ? Icons.verified
                      : Icons.info_outline,
                  title: "Phone Number Verification",
                  content: widget.instructorModel.isPhoneNumberVerified
                      ? "Verified"
                      : "Not Verified",
                ),
                BuildInfoCardWidget(
                  icon: widget.instructorModel.gender == "male"
                      ? Icons.male
                      : Icons.female,
                  title: "Gender",
                  content: widget.instructorModel.gender,
                ),
               
                SizedBox(height: 20.h),
                BuildInfoCardWidget(
                  icon: Icons.subject,
                  title: "Subjects",
                  content: widget.instructorModel.subjects.isNotEmpty
                      ? widget.instructorModel.subjects.join(", ")
                      : "No subjects specified",
                ),
                SizedBox(height: 20.h),
                ShowDaysWidget(
                  daysForSubjects:
                      widget.instructorModel.selectedDaysForSubjects,
                ),
                 SizedBox(height: 20.h),
                ShowTimingWidget(
                  selectedTimings:
                      widget.instructorModel.selectedTimingsForSubjects,
                ),
                SizedBox(height: 20.h),
                RatingCardWidget(
                  rating: widget.instructorModel.ratings.toDouble(),
                ),
                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: Icons.chat_bubble,
                  title: "Reviews",
                  content: widget.instructorModel.reviews.isEmpty
                      ? "No reviews yet."
                      : widget.instructorModel.reviews.join("\n"),
                ),
                SizedBox(height: 30.h),
                isEnrolled
                    ? Align(
                        alignment: Alignment.bottomLeft,
                        child: CustomButton(
                            onTap: unenrollTheUser,
                            width: 180,
                            height: 40,
                            text: "Remove",
                            bgColor: Colors.red))
                    : Container()
              ],
            ),
          ),
          floatingActionButton: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: () async {
                if (!isEnrolled) {
                  enrollUser();
                } else {
                  Get.to(() => ChatScreen(
                        receiverId: widget.instructorModel.uid,
                        senderId: FirebaseAuth.instance.currentUser!.uid,
                        receiverName: widget.instructorModel.name,
                        receiverProfilePicUrl:
                            widget.instructorModel.profilePicUrl,
                      ));
                }
              },
              label: Text(isEnrolled ? 'Chat' : 'Enroll'),
              icon: Icon(isEnrolled ? Icons.chat : Icons.book),
              backgroundColor: isEnrolled ? Colors.green : Colors.blue,
            ),
          ),
        ),
        if (isLoading) const CustomLoadingOverlay(),
      ],
    );
  }
}
