import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaanth/frontend/screens/homeScreens/chat/widgets/bottom_chat_field.dart';
import 'package:zaanth/frontend/screens/homeScreens/chat/widgets/chat_list.dart';

import 'package:zaanth/global/colors.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String senderId;
  final String receiverName;
  final String receiverProfilePicUrl;

  const ChatScreen({
    Key? key,
    required this.receiverId,
    required this.senderId,
    required this.receiverProfilePicUrl,
    required this.receiverName,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: appBarColor,
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                widget
                    .receiverProfilePicUrl, // Use the actual profile picture URL from your data
              ),
              radius: 18.r,
            ),
            SizedBox(width: 10.w),
            Text(
              widget.receiverName,
              style: TextStyle(color: Colors.black, fontSize: 18.sp),
            ), // Display the receiver's name here
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                // Get.to(() => AudioCallScreen(
                //     callID: widget.senderId,
                //     userName: widget.receiverName,
                //     userID: widget.senderId));
              },
              icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call))
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ChatList(
                receiverId: widget.receiverId), // Fixed spelling issue here.
          ),
          Divider(height: 1.h),
          BottomChatField(
            receiverId: widget.receiverId,
            senderId: widget.senderId,
          ),
        ],
      ),
    );
  }
}
