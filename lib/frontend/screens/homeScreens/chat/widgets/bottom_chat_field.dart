// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import 'package:zant/frontend/providers/home/chat_providers.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';

class BottomChatField extends StatefulWidget {
  final String receiverId;
  final String senderId;

  const BottomChatField({
    Key? key,
    required this.receiverId,
    required this.senderId,
  }) : super(key: key);

  @override
  _BottomChatFieldState createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isSendingMessage = false;
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();

  FocusNode focusNode = FocusNode();

  void _sendTextMessage() async {
    final chatProvider = Provider.of<ChatProviders>(context, listen: false);
    if (isShowSendButton) {
      String messageText = _messageController.text.trim();
      if (messageText.isNotEmpty) {
        chatProvider.sendTextMessageProvider(
          senderId: widget.senderId,
          receiverId: widget.receiverId,
          text: messageText,
        );
        setState(() {
          _messageController.clear();
        });
      } else {
        showCustomToast("please type something");
      }
    }
  }

  void _sendImageMessage() async {
    if (isSendingMessage) {
      // Don't send another message while one is already being sent
      return;
    }

    setState(() {
      isSendingMessage = true;
    });

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final chatProvider = Provider.of<ChatProviders>(context, listen: false);
      chatProvider.sendImageMessageProvider(
        senderId: widget.senderId,
        receiverId: widget.receiverId,
        imageFile: imageFile,
      );
    }

    setState(() {
      isSendingMessage = false;
    });
  }

  void _sendVideo() async {
    if (isSendingMessage) {
      // Don't send another message while one is already being sent
      return;
    }

    setState(() {
      isSendingMessage = true;
    });

    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      File videoFile = File(pickedFile.path);
      final chatProvider = Provider.of<ChatProviders>(context, listen: false);
      chatProvider.sendVideoMessageProvider(
        senderId: widget.senderId,
        receiverId: widget.receiverId,
        videoFile: videoFile,
      );
    }

    setState(() {
      isSendingMessage = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.image),
              onPressed: isSendingMessage ? null : _sendImageMessage,
            ),
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: isSendingMessage ? null : _sendVideo,
            ),
            Expanded(
              child: TextFormField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Type a message!',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.w,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.w,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10.w),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 8.h,
                right: 2.w,
                left: 2.w,
              ),
              child: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 226, 221, 221),
                radius: 25.r,
                child: GestureDetector(
                  child: Icon(Icons.send),
                  onTap: _sendTextMessage,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
