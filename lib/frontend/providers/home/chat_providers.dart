import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:zant/frontend/models/home/chat_contact_model.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/server/home/chat_methods.dart';
import 'package:zant/frontend/models/home/message_model.dart';

class ChatProviders extends ChangeNotifier {
  final ChatMethods _chatMethods = ChatMethods();
 Stream<List<MessageModel>>? _chatStream;
  Stream<List<ChatContactModel>>? _chatsContactsStream;

  Stream<List<MessageModel>>? get chatStream => _chatStream;
  Stream<List<ChatContactModel>>? get chatsContactsStream => _chatsContactsStream;

  // Send a text message.
  Future<void> sendTextMessageProvider({
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    try {
      await _chatMethods.sendTextMessage(
        senderId: senderId,
        receiverId: receiverId,
        text: text,
      );

      notifyListeners();
    } catch (e) {
      showCustomToast("Error sending text message: $e");
    }
  }

  // Send an image message.
  void sendImageMessageProvider({
    required String senderId,
    required String receiverId,
    required File imageFile,
  }) async {
    try {
       _chatMethods.sendImageMessage(
        senderId: senderId,
        receiverId: receiverId,
        imageFile: imageFile,
      );

      notifyListeners();
    } catch (e) {
      showCustomToast("Error sending image message: $e");
    }
  }

  // Send a video message.
  void sendVideoMessageProvider({
    required String senderId,
    required String receiverId,
    required File videoFile,
  }) async {
    try {
       _chatMethods.sendVideoMessage(
        senderId: senderId,
        receiverId: receiverId,
        videoFile: videoFile,
      );

      notifyListeners();
    } catch (e) {
      showCustomToast("Error sending video message: $e");
    }
  }

  // Send a voice message.
 void sendVoiceMessageProvider({
    required String senderId,
    required String receiverId,
    required File audioFile,
  }) async {
    try {
       _chatMethods.sendVoiceMessage(
        senderId: senderId,
        receiverId: receiverId,
        audioFile: audioFile,
      );

      notifyListeners();
    } catch (e) {
      showCustomToast("Error sending voice message: $e");
    }
  }

  void updateMessageIsSeeenProvider(
      {required String receiverId, required String messageId}) {
    _chatMethods.updateMessageIsSeen(
        receiverId: receiverId, messageId: messageId);

    ChangeNotifier();

    try {} catch (e) {
    print(e.toString());
    }
  }

   // Initialize the chat stream for a specific receiver.
  Future<void> getChatStreamProvider({required String receiverId}) async {
    try {
      _chatStream = _chatMethods.getChatStream(receiverId: receiverId);
      notifyListeners();
    } catch (e) {
      showCustomToast("Error initializing chat stream: $e");
    }
  }

  
  // Initialize the chats contacts stream.
  Future<void> getChatsContactsProvider() async {
    try {
      _chatsContactsStream = _chatMethods.getChatsContacts();
      notifyListeners();
    } catch (e) {
      showCustomToast("Error initializing chats contacts stream: $e");
    }
  }

   // Asynchronously fetch the count of unread messages
  Future<int> fetchUnreadMessagesCountProvider() async {
    return _chatMethods.fetchunreadMessagesCount();
  }

  // Dispose of the chat stream when no longer needed.
  void disposeChatStream() {
    _chatStream = null;
    notifyListeners();
  }





}
