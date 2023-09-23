import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zant/frontend/enum/messgae_enum.dart';
import 'package:zant/frontend/screens/homeScreens/chat/widgets/display_message_card.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final bool isSeen;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the card background color based on the message type
    Color cardBackgroundColor = type == MessageEnum.image || type == MessageEnum.video
        ? Colors.white // Set the card background color to transparent for image and video types
        : Colors.blue;

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          color: cardBackgroundColor,
          margin:  EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          child: Stack(
            children: [
              Padding(
                padding:  EdgeInsets.only(
                  left: 15.w,
                  right: 40.w,
                  top: 5.h,
                  bottom: 20.h,
                ),
                child: DisplayMessageCard(message: message, type: type),
              ),
              Positioned(
                bottom: 4.h,
                right: 10.w,
                child: Row(
                  children: [
                    Text(
                      date,
                      style:  TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white60,
                      ),
                    ),
                     SizedBox(
                      width: 5.w,
                    ),
                     Icon(
                     isSeen? Icons.done_all : Icons.done,
                      size: 20.sp,
                      color:isSeen? Colors.green: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
