import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zant/frontend/models/home/chat_contact_model.dart';
import 'package:zant/frontend/screens/homeScreens/chat/chat_screen.dart';
import 'package:zant/frontend/screens/homeScreens/drawer/drawer.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/global/firebase_collection_names.dart';
import 'package:zant/server/home/chat_methods.dart';

class ChatInboxScreen extends StatefulWidget {
  ChatInboxScreen({Key? key}) : super(key: key);

  @override
  State<ChatInboxScreen> createState() => _ChatInboxScreenState();
}

class _ChatInboxScreenState extends State<ChatInboxScreen> {
  final Map<String, int> unreadMessageCounts = {};

  @override
  void initState() {
    // TODO: implement initState
    initializeUnreadMessageCounts();
    super.initState();
  }

// Initialize unread message counts for all contacts
  Future<void> initializeUnreadMessageCounts() async {
    final chatContacts = await ChatMethods().getChatsContacts().first;
    for (final contact in chatContacts) {
      final unreadCount = await calculateUnreadMessageCount(contact.contactId);
      setState(() {
        unreadMessageCounts[contact.contactId] = unreadCount;
      });
    }
  }

  Future<int> calculateUnreadMessageCount(String contactId) async {
    try {
      int unreadMessageCount = 0;

      var messagesQuery = await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(chatsCollection)
          .doc(contactId)
          .collection(messageCollection)
          .where("recieverid",
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('isSeen', isEqualTo: false)
          .get();

      // Update the unread message count
      unreadMessageCount = messagesQuery.size;

      return unreadMessageCount;
    } catch (e) {
      print('Error calculating unread message count: $e');
      return 0; // Return 0 in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backgroundColor: appBarColor, title: "Inbox"),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: StreamBuilder<List<ChatContactModel>>(
          stream: ChatMethods().getChatsContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
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

            // Calculate and update unread message counts
            snapshot.data!.forEach((chatContatData) async {
              int unreadMessageCount =
                  await calculateUnreadMessageCount(chatContatData.contactId);
              unreadMessageCounts[chatContatData.contactId] =
                  unreadMessageCount;
            });

            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var chatContatData = snapshot.data![index];
                int unreadMessageCount =
                    unreadMessageCounts[chatContatData.contactId] ?? 0;

                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => ChatScreen(
                            receiverId: chatContatData.contactId,
                            senderId: FirebaseAuth.instance.currentUser!.uid,
                            receiverProfilePicUrl: chatContatData.profilePicUrl,
                            receiverName: chatContatData.name));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                chatContatData.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 10..h),
                              if (unreadMessageCount >
                                  0) // Display unread message count if it's greater than 0
                                Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .red, // Customize the color as needed
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    unreadMessageCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 6.h),
                            child: Text(
                              chatContatData.lastMessage,
                              style: unreadMessageCount > 0
                                  ? TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp)
                                  : const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              chatContatData.profilePicUrl,
                            ),
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
          },
        ),
      ),
    );
  }
}
