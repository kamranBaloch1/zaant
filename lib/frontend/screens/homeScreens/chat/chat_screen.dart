
import 'package:flutter/material.dart';
import 'package:zant/frontend/screens/homeScreens/chat/widgets/bottom_chat_field.dart';
import 'package:zant/frontend/screens/homeScreens/chat/widgets/chat_list.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String senderId;
  const ChatScreen({
    Key? key,
    required this.receiverId,
    required this.senderId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ChatList(resicverId: widget.receiverId),
          ),
          const Divider(height: 1),
         
          BottomChatField(receiverId: widget.receiverId, senderId: widget.senderId)
        ],
      ),
    );
  }

 


}
