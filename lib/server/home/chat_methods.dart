import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:zant/frontend/enum/messgae_enum.dart';
import 'package:zant/frontend/models/auth/user_model.dart';
import 'package:zant/frontend/models/home/last_message_model.dart';
import 'package:zant/frontend/models/home/message_model.dart';
import 'package:zant/global/firebase_collection_names.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:zant/sharedprefences/userPref.dart';

class ChatMethods {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(userCollection);

  final CollectionReference instructorsCollection =
      FirebaseFirestore.instance.collection(instructorsCollections);

  String messageId = const Uuid().v4();

  final Reference _storageReference = FirebaseStorage.instance.ref();

  Future<String> uploadFile({
    required String path,
    required File? file,
    required String fileExtension,
  }) async {
    try {
      final String uniqueId = Uuid().v4();
      final String fileName = '$uniqueId.$fileExtension';
      final Reference storageReference =
          _storageReference.child(path).child(fileName);

      final UploadTask uploadTask = storageReference.putFile(file!);

      await uploadTask;
      final String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading file: $e');
      return '';
    }
  }

  void sendTextMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    UserModel? recieverUserData;

    var userDataMap = await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(receiverId)
        .get();
    recieverUserData = UserModel.fromMap(userDataMap.data()!);

    final message = MessageModel(
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      type: MessageEnum.text,
      timeSent: Timestamp.fromDate(DateTime.now()),
      messageId: messageId, // Generate a unique message ID
      isSeen: false,
    );

    // Store the message in Firestore

    await _saveDataToContactSubCollection(
        receiverUserData: recieverUserData, lastMessage: text);

    await _storeMessage(senderId, receiverId, message.toMap(), messageId);
  }

  void sendImageMessage({
    required String senderId,
    required String receiverId,
    required File imageFile,
  }) async {
    // Upload the image to Firebase Storage
    final imageDownloadedUrl = await uploadFile(
      path: 'chat_images',
      file: imageFile,
      fileExtension: 'jpg',
    );
    final message = MessageModel(
      senderId: senderId,
      receiverId: receiverId,
      text: imageDownloadedUrl, // Store the image URL in the text field
      type: MessageEnum.image,
      timeSent: Timestamp.fromDate(DateTime.now()),
      messageId: messageId, // Generate a unique message ID
      isSeen: false,
    );

    UserModel? recieverUserData;

    var userDataMap = await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(receiverId)
        .get();
    recieverUserData = UserModel.fromMap(userDataMap.data()!);

    await _saveDataToContactSubCollection(
        receiverUserData: recieverUserData, lastMessage: "📷");

    await _storeMessage(senderId, receiverId, message.toMap(), messageId);
  }

  void sendVideoMessage({
    required String senderId,
    required String receiverId,
    required File videoFile,
  }) async {
    // Upload the video to Firebase Storage
    final videoDownloadUrl = await uploadFile(
      path: 'chat_videos',
      file: videoFile,
      fileExtension: 'mp4',
    );
    final message = MessageModel(
      senderId: senderId,
      receiverId: receiverId,
      text: videoDownloadUrl, // Store the video URL in the text field
      type: MessageEnum.video,
      timeSent: Timestamp.fromDate(DateTime.now()),
      messageId: messageId, // Generate a unique message ID
      isSeen: false,
    );

    UserModel? recieverUserData;

    var userDataMap = await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(receiverId)
        .get();
    recieverUserData = UserModel.fromMap(userDataMap.data()!);

    await _saveDataToContactSubCollection(
        receiverUserData: recieverUserData, lastMessage: "📷");

    await _storeMessage(senderId, receiverId, message.toMap(), messageId);
  }

  void sendVoiceMessage({
    required String senderId,
    required String receiverId,
    required String audioUrl,
  }) async {
    final message = MessageModel(
      senderId: senderId,
      receiverId: receiverId,
      text: audioUrl, // Store the audio URL in the text field
      type: MessageEnum.audio,
      timeSent: Timestamp.fromDate(DateTime.now()),
      messageId: messageId, // Generate a unique message ID
      isSeen: false,
    );

    UserModel? recieverUserData;

    var userDataMap = await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(receiverId)
        .get();
    recieverUserData = UserModel.fromMap(userDataMap.data()!);

    await _saveDataToContactSubCollection(
        receiverUserData: recieverUserData, lastMessage: "🎵");

    await _storeMessage(senderId, receiverId, message.toMap(), messageId);
  }

  _saveDataToContactSubCollection(
      {required UserModel receiverUserData,
      required String lastMessage}) async {
    //  name id profile

    String? senderName = UserPreferences.getName().toString();
    String? profilePicUrl = UserPreferences.getProfileUrl().toString();
    String? senderId = FirebaseAuth.instance.currentUser!.uid;

    var receiverLastMessageModel = LastMessageModel(
        name: senderName,
        profilePicUrl: profilePicUrl,
        contactId: senderId,
        timeSent: Timestamp.fromDate(DateTime.now()),
        lastMessage: lastMessage);

    await usersCollection
        .doc(receiverUserData.uid)
        .collection(chatsCollection)
        .doc(senderId)
        .set(receiverLastMessageModel.toMap());

    var senderLastMessageModel = LastMessageModel(
        name: receiverUserData.name!,
        profilePicUrl: receiverUserData.profileUrl!,
        contactId: receiverUserData.uid!,
        timeSent: Timestamp.fromDate(DateTime.now()),
        lastMessage: lastMessage);

    await usersCollection
        .doc(senderId)
        .collection(chatsCollection)
        .doc(receiverUserData.uid)
        .set(senderLastMessageModel.toMap());
  }

  Future<void> _storeMessage(String senderId, String receiverId,
      Map<String, dynamic> messageData, String messageId) async {
    await usersCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(chatsCollection)
        .doc(receiverId)
        .collection(messageCollection)
        .doc(messageId)
        .set(messageData);

    await usersCollection
        .doc(receiverId)
        .collection(chatsCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(messageCollection)
        .doc(messageId)
        .set(messageData);
  }

  // get stream of chats

  Stream<List<MessageModel>> getChatStream({required String resicverId}) {
    return usersCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(chatsCollection)
        .doc(resicverId)
        .collection(messageCollection)
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var documnet in event.docs) {
        messages.add(MessageModel.fromMap(documnet.data()));
      }
      return messages;
    });
  }
}
