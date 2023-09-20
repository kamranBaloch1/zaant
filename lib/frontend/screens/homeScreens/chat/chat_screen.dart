import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zant/frontend/providers/home/chat_providers.dart';
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
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];

// Inside your _ChatScreenState class
  Future<void> _sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Now you have the picked image, you can upload it to the server or process it as needed
      // Call your send image method with the pickedFile.path

      File imageFile = File(pickedFile.path);
      final chatProvider = Provider.of<ChatProviders>(context, listen: false);
      chatProvider.sendImageMessageProvider(
          senderId: widget.senderId,
          receiverId: widget.receiverId,
          imageFile: imageFile);
    }
  }

  Future<void> _sendTextMessage() async {
    final chatProvider = Provider.of<ChatProviders>(context, listen: false);
    chatProvider.sendTextMessageProvider(
        senderId: widget.senderId,
        receiverId: widget.receiverId,
        text: _messageController.text.trim());
    _messageController.clear();
  }

  Future<void> _sendVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Now you have the picked video, you can upload it to the server or process it as needed
      // Call your send video method with the pickedFile.path
      File videoFile = File(pickedFile.path);
      final chatProvider = Provider.of<ChatProviders>(context, listen: false);
      chatProvider.sendVideoMessageProvider(
          senderId: widget.senderId,
          receiverId: widget.receiverId,
          videoFile: videoFile);
    }
  }

  void _sendVoiceMessage() {
    // Implement sending voice messages here
  }

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
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    bool isMessageEmpty = _messageController.text.isEmpty;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: _sendImage,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: Icon(
                Icons.videocam,
                color: Colors.blue,
              ),
              onPressed: _sendVideo,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration.collapsed(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
              onChanged: (message) {
                setState(() {
                  // Enable the send button if the message is not empty
                  isMessageEmpty = message.isEmpty;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: _sendVoiceMessage,
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: isMessageEmpty
                ? null // Disable the send button if the message is empty
                : () {
                    _sendTextMessage();
                  },
          ),
        ],
      ),
    );
  }
}
