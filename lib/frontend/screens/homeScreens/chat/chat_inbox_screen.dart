import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zant/frontend/models/home/chat_contact_model.dart';
import 'package:zant/frontend/screens/homeScreens/chat/chat_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/server/home/chat_methods.dart';

class ChatInboxScreen extends StatelessWidget {
  const ChatInboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backgroundColor: appBarColor, title: "Inbox"),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: StreamBuilder<List<ChatContactModel>>(
            stream: ChatMethods().getChatsContacts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Handle the case where snapshot.data is null or empty
                return const Center(
                    child:
                        CircularProgressIndicator()); // or any other loading indicator
              }

              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                // Handle the case where snapshot.data is null or empty
                return Center(
                  child: Text(
                    "No chats available", // Your custom message here
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.black,
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var chatContatData = snapshot.data![index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => ChatScreen(
                              receiverId: chatContatData.contactId,
                              senderId: FirebaseAuth.instance.currentUser!.uid,
                              receiverProfilePicUrl:
                                  chatContatData.profilePicUrl,
                              receiverName: chatContatData.name));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: ListTile(
                            title: Text(
                              chatContatData.name,
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.black),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 6.h),
                              child: Text(
                                chatContatData.lastMessage,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(chatContatData.profilePicUrl),
                              radius: 30.r,
                            ),
                            trailing: Text(
                              DateFormat.Hm().format(chatContatData.timeSent),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(color: Colors.black26, indent: 85),
                    ],
                  );
                },
              );
            }),
      ),
    );
  }
}
