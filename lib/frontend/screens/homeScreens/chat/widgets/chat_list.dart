import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:zant/frontend/models/home/message_model.dart';
import 'package:zant/frontend/screens/homeScreens/chat/widgets/my_message_card.dart';
import 'package:zant/frontend/screens/homeScreens/chat/widgets/sender_message_card.dart';
import 'package:zant/server/home/chat_methods.dart';

class ChatList extends StatefulWidget {
  final String resicverId;
  const ChatList({
    Key? key,
    required this.resicverId,
  }) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream: ChatMethods().getChatStream(resicverId: widget.resicverId), // Use resicverId here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData) {
          // Handle the case where snapshot.data is null
        
          return Center(
            child: Text(
              "no data",
              style: TextStyle(color: Colors.black),
            ),
          );
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
           _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller:_scrollController ,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            String timeSent = DateFormat.Hm().format(messageData.timeSent);
            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(message: messageData.text, date: timeSent,type:messageData.type ,);
            }
            return SenderMessageCard(
              message: messageData.text,
              date: timeSent,
              type:messageData.type ,
            );
          },
        );
      },
    );
  }
}
