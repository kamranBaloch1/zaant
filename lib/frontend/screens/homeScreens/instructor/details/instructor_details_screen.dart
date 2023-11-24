import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:zaanth/frontend/models/home/instructor_model.dart';
import 'package:zaanth/frontend/providers/home/enrollmens_provider.dart';
import 'package:zaanth/frontend/providers/home/instructor_provider.dart';
import 'package:zaanth/frontend/screens/homeScreens/chat/chat_screen.dart';
import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/show_full_image_dilog.dart';
import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/calculate_user_age.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/details/widgets/build_info_card_widget.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/details/widgets/rating_card_widget.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/details/widgets/show_days_widget.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/details/widgets/show_instructor_reviews.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/details/widgets/show_timings_widget.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';

class InstructorDetailScreen extends StatefulWidget {
  final InstructorModel instructorModel;

  const InstructorDetailScreen({Key? key, required this.instructorModel})
      : super(key: key);

  @override
  State<InstructorDetailScreen> createState() =>
      _InstructorDetailScreenState();
}

class _InstructorDetailScreenState extends State<InstructorDetailScreen> {
  bool isEnrolled = false;
  bool _isLoading = false;
  double rating = 0;

  final TextEditingController _reviewContent = TextEditingController();

  void _addReview() async {
    String reviewContent = _reviewContent.text.trim();

    if (rating > 0) {
      if (reviewContent.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });
        Navigator.pop(context);

        final instructorProvider =
            Provider.of<InstructorProviders>(context, listen: false);

        await instructorProvider
            .addInstructorReviewProvider(
                instructorUid: widget.instructorModel.uid,
                ratings: rating,
                content: reviewContent)
            .then((value) {
          _reviewContent.clear();
          setState(() {
            _isLoading = false;
            rating = 0;
          });
        });
      } else {
        showCustomToast("please write a review");
      }
    } else {
      showCustomToast("please give a rating");
    }
  }

 


  @override
  void initState() {
    super.initState();
    // Check the enrollment status when the screen is initialized
    checkEnrollmentStatus();
  }

  void checkEnrollmentStatus() async {
    final enrollmentsProvider =
        Provider.of<EnrollmentsProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    bool userEnrolled = await enrollmentsProvider.checkEnrollmentStatusProvider(
        instructorId: widget.instructorModel.uid);
    setState(() {
      isEnrolled = userEnrolled;
      _isLoading = false;
    });
  }

  void enrollUser() async {
    setState(() {
      _isLoading = true;
    });
    final enrollmentsProvider =
        Provider.of<EnrollmentsProvider>(context, listen: false);
    await enrollmentsProvider.enrollUserToInstructorProvider(
        instructorId: widget.instructorModel.uid);
    setState(() {
      isEnrolled = true;
      _isLoading = false;
    });
  }

  void unenrollTheUser() async {
    setState(() {
      _isLoading = true;
    });
    final enrollmentsProvider =
        Provider.of<EnrollmentsProvider>(context, listen: false);
    await enrollmentsProvider.unenrollInstructorForUserProvider(
        instructorId: widget.instructorModel.uid);

    setState(() {
      _isLoading = false;
    });
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Rate Instructor',
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 40.0,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  rating = newRating;
                },
              ),
              TextField(
                style: const TextStyle(color: Colors.black),
                controller: _reviewContent,
                decoration: const InputDecoration(
                  labelText: 'Write your review',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _addReview,
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(
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
                  icon: Icons.money,
                  title: "Fees per Hour",
                  content:
                      "PKR : ${widget.instructorModel.feesPerHour.toString()}",
                ),
                SizedBox(height: 16.h),
                 BuildInfoCardWidget(
          icon: Icons.grade,
          title: "Grade Level",
          content: widget.instructorModel.selectedGradesLevel.isNotEmpty
              ? widget.instructorModel.selectedGradesLevel.join(", ")
              : "No Grade Level specified",
        ),
        SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: Icons.phone,
                  title: "Phone Number",
                  content: widget.instructorModel.phoneNumber,
                ),
                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: widget.instructorModel.gender == "male"
                      ? Icons.boy
                      : Icons.girl,
                  title: "Gender",
                  content: widget.instructorModel.gender,
                ),
                SizedBox(height: 16.h),
               BuildInfoCardWidget(
  icon: Icons.cake,
  title: "Age",
  content:" ${ CalculateUserAge.calculateAge(widget.instructorModel.dob)?.toString()} Years" ,
),

                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: Icons.subject,
                  title: "Subjects",
                  content: widget.instructorModel.subjects.isNotEmpty
                      ? widget.instructorModel.subjects.join(", ")
                      : "No subjects specified",
                ),
                SizedBox(height: 16.h),
                ShowDaysWidget(
                  daysForSubjects:
                      widget.instructorModel.selectedDaysForSubjects,
                ),
                SizedBox(height: 16.h),
                ShowTimingWidget(
                  selectedTimings:
                      widget.instructorModel.selectedTimingsForSubjects,
                ),
                SizedBox(height: 16.h),
                RatingCardWidget(
                  rating: widget.instructorModel.ratings.toDouble(),
                ),
                SizedBox(height: 10.h),
                isEnrolled
                    ? ElevatedButton(
                        onPressed: () {
                          _showRatingDialog();
                        },
                        child: const Text('Rate Instructor'),
                      )
                    : Container(),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => ShowInstructorReviewsScreen(
                          instructorId: widget.instructorModel.uid,
                        ));
                  },
                  child: const Text('Reviews'),
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
        if (_isLoading) const CustomLoadingOverlay(),
      ],
    );
  }
}
