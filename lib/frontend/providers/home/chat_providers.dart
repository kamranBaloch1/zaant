import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:zant/server/home/chat_methods.dart';

class ChatProviders extends ChangeNotifier {
  final ChatMethods _chatMethods = ChatMethods();

  void sendTextMessageProvider({
    required String senderId,
    required String receiverId,
    required String text,
  }) {
    _chatMethods.sendTextMessage(
        senderId: senderId, receiverId: receiverId, text: text);
    notifyListeners();
  }

    void  sendImageMessageProvider({
    required String senderId,
    required String receiverId,
    required File imageFile,
  }){
      _chatMethods.sendImageMessage(senderId: senderId, receiverId: receiverId, imageFile: imageFile);
      notifyListeners();

  }

  void sendVideoMessageProvider({
    required String senderId,
    required String receiverId,
    required File videoFile,
  }){
    _chatMethods.sendVideoMessage(senderId: senderId, receiverId: receiverId, videoFile: videoFile);
    notifyListeners();
  }

  void sendVoiceMessageProvider({
    required String senderId,
    required String receiverId,
    required String audioUrl,
  }){
     _chatMethods.sendVoiceMessage(senderId: senderId, receiverId: receiverId, audioUrl: audioUrl);
     notifyListeners();
  }


}
