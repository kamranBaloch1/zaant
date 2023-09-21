import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:zant/frontend/models/home/message_model.dart';
import 'package:zant/frontend/providers/home/chat_providers.dart';
import 'package:zant/frontend/screens/homeScreens/chat/widgets/my_message_card.dart';
import 'package:zant/frontend/screens/homeScreens/chat/widgets/sender_message_card.dart';
import 'package:zant/server/home/chat_methods.dart';

class ChatList extends StatefulWidget {
  final String receiverId;

  const ChatList({
    Key? key,
    required this.receiverId,
  }) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream: ChatMethods()
          .getChatStream(receiverId: widget.receiverId), // Use receiverId here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Handle the case where snapshot.data is null or empty
          return const Center(
            child: Text(
              "Start a Chat",
              style: TextStyle(color: Colors.black),
            ),
          );
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: _scrollController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            String timeSent = DateFormat.Hm().format(messageData.timeSent);

            if (!messageData.isSeen &&
                messageData.receiverId ==
                    FirebaseAuth.instance.currentUser!.uid) {
              final chatProvider =
                  Provider.of<ChatProviders>(context, listen: false);

              chatProvider.updateMessageIsSeeenProvider(
                  receiverId: widget.receiverId,
                  messageId: messageData.messageId);
            }

            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              // Display user's own messages
              return MyMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                isSeen: messageData.isSeen,
              );
            } else {
              // Display messages from other senders
              return SenderMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
              );
            }
          },
        );
      },
    );
  }
}
