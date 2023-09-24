// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zant/frontend/enum/messgae_enum.dart';
import 'package:zant/frontend/screens/homeScreens/chat/widgets/display_message_card.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
  }) : super(key: key);

  final String message;
  final String date;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    // Determine the card background color based on the message type
    Color cardBackgroundColor = type == MessageEnum.image || type == MessageEnum.video
        ? Colors.white // Set the card background color to transparent for image and video types
        : Colors.black;

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45.w,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: cardBackgroundColor,
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 30.w,
                  top: 5.h,
                  bottom: 20.h,
                ),
                child: DisplayMessageCard(message: message, type: type),
              ),
              Positioned(
                bottom: 2.h,
                right: 10.w,
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Color.fromARGB(255, 124, 105, 98),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
