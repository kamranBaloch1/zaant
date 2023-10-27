import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zant/frontend/providers/home/instructor_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/custom_shimmer_loader.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';

class ShowInstructorReviewsScreen extends StatefulWidget {
  final String instructorId;

  const ShowInstructorReviewsScreen({
    Key? key,
    required this.instructorId,
  }) : super(key: key);

  @override
  State<ShowInstructorReviewsScreen> createState() =>
      _ShowInstructorReviewsScreenState();
}

class _ShowInstructorReviewsScreenState
    extends State<ShowInstructorReviewsScreen> {
  final Map<String, TextEditingController> _replyTextControllers = {};

  void _sendReply(String reviewId) async {
    String replyText = _replyTextControllers[reviewId]!.text.trim();

    final instructorProviders =
        Provider.of<InstructorProviders>(context, listen: false);

    if (replyText.isEmpty) {
      showCustomToast("Please write something");
      return;
    }

    setState(() {});

    await instructorProviders
        .addInstructorReviewReplyProvider(
            instructorUid: widget.instructorId,
            reviewId: reviewId,
            replyText: replyText)
        .then((value) {
      _replyTextControllers[reviewId]!.clear();
    });
  }

  void _deleteReply({required String reviewId, required replyId}) async {
    setState(() {});

    final instructorProviders =
        Provider.of<InstructorProviders>(context, listen: false);
    await instructorProviders.deleteReviewReplyProvider(
        instructorUid: widget.instructorId,
        reviewId: reviewId,
        replyId: replyId);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildStarRating(double rating) {
      List<Widget> stars = [];
      for (int i = 0; i < rating; i++) {
        stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
      }
      return Row(children: stars);
    }

    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(backgroundColor: appBarColor, title: "Reviews"),
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: Provider.of<InstructorProviders>(context, listen: false)
                .fetchReviewsOfInstructorProvider(
                    instructorUid: widget.instructorId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No reviews yet.',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              } else {
                final reviewsData = snapshot.data;

                // Initialize reply text controllers for each review
                _initializeReplyControllers(reviewsData!);

                // Sort reviews to show the current user's review on top
                reviewsData.sort((a, b) {
                  final currentUserID = FirebaseAuth.instance.currentUser!.uid;
                  final userIdA = a['userId'] as String;
                  final userIdB = b['userId'] as String;

                  if (userIdA == currentUserID) {
                    return -1;
                  } else if (userIdB == currentUserID) {
                    return 1;
                  } else {
                    // You can customize the sorting logic further if needed
                    return 0;
                  }
                });

                return ListView.builder(
                  itemCount: reviewsData.length,
                  itemBuilder: (context, index) {
                    final reviewData = reviewsData[index];
                    final userName = reviewData['name'] as String;
                    final userProfilePicUrl =
                        reviewData['profilePicUrl'] as String;
                    final reviewDate = reviewData['date'] as Timestamp;
                    final content = reviewData['content'] as String;
                    final ratings = reviewData['ratings'] as double;
                    final userId = reviewData['userId'] as String;
                    final reviewId = reviewData['reviewId'] as String;
                    final currentUserID =
                        FirebaseAuth.instance.currentUser!.uid;
                    final isCurrentUserReview = currentUserID == userId;
                    final isCurrentUserInstructor =
                        currentUserID == widget.instructorId;

                    final formattedDate =
                        DateFormat.yMMMd().format(reviewDate.toDate());

                    return Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Card(
                        elevation: 2,
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userProfilePicUrl),
                              ),
                              title: Text(
                                userName,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    content,
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.black),
                                  ),
                                  buildStarRating(ratings),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                        fontSize: 12.sp, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            // Add a text field for the reply using the corresponding controller
                            Visibility(
                              visible: isCurrentUserInstructor ||
                                  isCurrentUserReview,
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller:
                                            _replyTextControllers[reviewId],
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: const InputDecoration(
                                          hintText: 'Write a reply...',
                                        ),
                                        // Handle text input and reply logic here
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: () {
                                        _sendReply(reviewId);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Add a section to display replies
                     const Divider(
                        thickness: 2,
                        
                      ),
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: Provider.of<InstructorProviders>(context,
                                      listen: false)
                                  .fetchReviewsRepliesProvider(
                                      instructorUid: widget.instructorId,
                                      reviewId: reviewId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[
                                        300]!, // Customize the base and highlight colors
                                    highlightColor: Colors.grey[100]!,
                                    child:
                                        const CustomShimmerLoadingBar(), // Replace 'YourShimmeringUI' with your UI for loading state
                                  );
                                } else if (snapshot.hasError) {
                                  return const Center(
                                    child: Text(
                                      'Error: accoured',
                                      style:
                                           TextStyle(color: Colors.black),
                                    ),
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      'No replies yet.',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                } else {
                                  final repliesData = snapshot.data;

                                  return Column(
                                    children: repliesData!.map((reply) {
                                      final replyUserName =
                                          reply['name'] as String;
                                      final replyContent =
                                          reply['replyText'] as String;
                                      final replyDate =
                                          reply['date'] as Timestamp;
                                      final replyUserProfilePicUrl =
                                          reply['profilePicUrl'] as String;
                                      final replayUserId =
                                          reply['userId'] as String;
                                      final replyId =
                                          reply['replyId'] as String;

                                      final formattedReplyDate =
                                          DateFormat.yMMMd()
                                              .format(replyDate.toDate());

                                      return ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                replyUserProfilePicUrl),
                                          ),
                                          title: Text(
                                            replyUserName,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                replyContent,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                formattedReplyDate,
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          trailing: currentUserID ==
                                                  replayUserId
                                              ? PopupMenuButton<String>(
                                                  onSelected: (value) {
                                                    if (value == 'delete') {
                                                      _deleteReply(
                                                          reviewId: reviewId,
                                                          replyId: replyId);
                                                    }
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context) {
                                                    return <PopupMenuEntry<
                                                        String>>[
                                                      const PopupMenuItem<
                                                          String>(
                                                        value: 'delete',
                                                        child: Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ];
                                                  },
                                                )
                                              : null);
                                    }).toList(),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  // Method to initialize controllers for reply text fields
  void _initializeReplyControllers(List<Map<String, dynamic>> reviewsData) {
    for (final reviewData in reviewsData) {
      final reviewId = reviewData['reviewId'] as String;
      // Initialize a controller for each review
      _replyTextControllers[reviewId] = TextEditingController();
    }
  }

  @override
  void dispose() {
    // Dispose of the reply text field controllers to prevent memory leaks
    // ignore: avoid_function_literals_in_foreach_calls
    _replyTextControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
