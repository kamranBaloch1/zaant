import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

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
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream: ChatMethods().getChatStream(receiverId: widget.receiverId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "Start a Chat",
              style: TextStyle(color: Colors.black),
            ),
          );
        }

        // Group messages by date
        final groupedMessages = groupMessagesByDate(snapshot.data!);
       SchedulerBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: _scrollController,
          itemCount: groupedMessages.length,
          itemBuilder: (context, index) {
            final date = groupedMessages.keys.elementAt(index);
            final messagesOnDate = groupedMessages[date];

            // Render the date or a separator
            Widget dateWidget = Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                _formatDate(date),
                style: const TextStyle(color: Colors.grey),
              ),
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                dateWidget,
                ...messagesOnDate!.map((messageData) {
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
                    return MyMessageCard(
                      message: messageData.text,
                      date: timeSent,
                      type: messageData.type,
                      isSeen: messageData.isSeen,
                    );
                  } else {
                    return SenderMessageCard(
                      message: messageData.text,
                      date: timeSent,
                      type: messageData.type,
                    );
                  }
                }).toList(),
              ],
            );
          },
        );
      },
    );
  }

  // Group messages by date
  Map<DateTime, List<MessageModel>> groupMessagesByDate(List<MessageModel> messages) {
    final groupedMessages = <DateTime, List<MessageModel>>{};
    for (final message in messages) {
      final date = message.timeSent.toLocal().date; // Get the date without time
      if (groupedMessages.containsKey(date)) {
        groupedMessages[date]!.add(message);
      } else {
        groupedMessages[date] = [message];
      }
    }
    return groupedMessages;
  }

  // Format the date as "Today" or "dd/MM/yyyy"
  String _formatDate(DateTime date) {
    final now = DateTime.now().toLocal().date;
    if (date == now) {
      return 'Today';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}

extension DateTimeExtension on DateTime {
  DateTime get date =>  DateTime(year, month, day);
}
