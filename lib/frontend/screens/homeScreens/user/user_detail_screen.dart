import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:zant/frontend/models/auth/user_model.dart';
import 'package:zant/frontend/providers/home/enrollmens_provider.dart';
import 'package:zant/frontend/screens/homeScreens/chat/chat_screen.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/details/widgets/build_info_card_widget.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/show_full_image_dilog.dart'; // Corrected spelling here
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/global/colors.dart';

class UserDetailScreen extends StatefulWidget {
  final UserModel userModel;

  const UserDetailScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  bool isLoading = false;


  Future<void> unenrollTheUser() async {
    setState(() {
      isLoading = true;
    });
    final enrollmnetsProvider =
        Provider.of<EnrollmentsProvider>(context, listen: false);
    await enrollmnetsProvider.unenrollUserForInstructorProvider(
        userId: widget.userModel.uid!);

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
            title: 'User Details', // Updated the title
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
                        return FullImageDialog(imageUrl: widget.userModel.profilePicUrl!);
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 80.r,
                    backgroundImage: NetworkImage(
                      widget.userModel.profilePicUrl!,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  widget.userModel.name!,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: Icons.email,
                  title: "Email",
                  content: widget.userModel.email!,
                ),
                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: Icons.cake,
                  title: "Date of Birth",
                  content: DateFormat('yyyy-MM-dd').format(widget.userModel.dob!),
                ),
                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: Icons.location_on,
                  title: "Location",
                  content: widget.userModel.location!,
                ),
                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: Icons.location_city,
                  title: "City",
                  content: widget.userModel.city!,
                ),
                SizedBox(height: 16.h),
                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: Icons.phone,
                  title: "Phone Number",
                  content: widget.userModel.phoneNumber!,
                ),
                SizedBox(height: 16.h),
                BuildInfoCardWidget(
                  icon: widget.userModel.isPhoneNumberVerified!
                      ? Icons.verified
                      : Icons.info_outline,
                  title: "Phone Number Verification",
                  content: widget.userModel.isPhoneNumberVerified!
                      ? "Verified"
                      : "Not Verified",
                ),
                BuildInfoCardWidget(
                  icon: widget.userModel.gender == "male"
                      ? Icons.boy
                      : Icons.girl,
                  title: "Gender",
                  content: widget.userModel.gender!,
                ),
                SizedBox(height: 20.h),

                 Align(
                        alignment: Alignment.bottomLeft,
                        child: CustomButton(
                            onTap: unenrollTheUser,
                            width: 180,
                            height: 40,
                            text: "Remove",
                            bgColor: Colors.red))


              ],
            ),
          ),
          floatingActionButton: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: () async {
                Get.to(() => ChatScreen(
                  receiverId: widget.userModel.uid!,
                  senderId: FirebaseAuth.instance.currentUser!.uid,
                  receiverName: widget.userModel.name!,
                  receiverProfilePicUrl: widget.userModel.profilePicUrl!,
                ));
              },
              label: const Text('Chat'),
              icon: const Icon(Icons.chat),
              backgroundColor: Colors.green,
            ),
          ),
        ),
        if (isLoading) const CustomLoadingOverlay(),
      ],
    );
  }
}
