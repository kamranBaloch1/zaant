// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zant/frontend/models/home/message_model.dart';
import 'package:zant/frontend/screens/homeScreens/chat/widgets/my_message_card.dart';
import 'package:zant/frontend/screens/homeScreens/chat/widgets/sender_message_card.dart';
import 'package:zant/server/home/chat_methods.dart';

class ChatList extends StatelessWidget {
  final String resicverId;
  const ChatList({
    Key? key,
    required this.resicverId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
        stream: ChatMethods().getChatStream(resicverId: resicverId),
        builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            // Handle the case where snapshot.data is null
            return Container(); // Return an empty container or a loading indicator
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              String timeSent = messageData.timeSent.toDate().toString();
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(message: messageData.text, date: timeSent);
              }
              return SenderMessageCard(
                  message: messageData.text, date: timeSent);
            },
          );
        });
  }
}
