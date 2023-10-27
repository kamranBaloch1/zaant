import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:zant/frontend/enum/messgae_enum.dart';
import 'package:zant/frontend/models/auth/user_model.dart';
import 'package:zant/frontend/models/home/chat_contact_model.dart';
import 'package:zant/frontend/models/home/message_model.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/firebase_collection_names.dart';
import 'package:zant/server/notifications/notification_method.dart';
import 'package:zant/server/notifications/send_notifications.dart';
import 'package:zant/sharedprefences/userPref.dart';

class ChatMethods {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(userCollection);

  final Reference _storageReference = FirebaseStorage.instance.ref();

  // Upload a file to Firebase Storage and return its download URL.
  Future<String> uploadFile({
    required String path,
    required File? file,
    required String fileExtension,
  }) async {
    try {
      final String uniqueId = const Uuid().v4();
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

  // Send a text message.
  Future<void> sendTextMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    try {
      UserModel? receiverUserData;
      String? currentUserName = UserPreferences.getName();
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      var userDataMap = await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(receiverId)
          .get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      String messageId = const Uuid().v4();

      final message = MessageModel(
        senderId: senderId,
        receiverId: receiverId,
        text: text,
        type: MessageEnum.text,
        timeSent: DateTime.now(),
        messageId: messageId,
        isSeen: false,
      );

      await _saveDataToContactSubCollection(
          receiverUserData: receiverUserData, lastMessage: text);

      await _storeMessage(senderId, receiverId, message.toMap(), messageId);

      await SendNotificationsMethod().sendNotificationsToUsersForNewMessage(
          userName: currentUserName!,
          userId: receiverId,
          messageTypeText: "message");

          //Saving the notification to firestore

     await NotificationMethod().saveNotificationToFireStore(
          notificationText: "sent message",
          receiverUserId: receiverId,
          senderUserId: currentUserId);
    } catch (e) {
      showCustomToast('Error sending the message');
    }
  }

  // Send an image message.
  void sendImageMessage({
    required String senderId,
    required String receiverId,
    required File imageFile,
  }) async {
    try {
      String? currentUserName = UserPreferences.getName();
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      final imageDownloadedUrl = await uploadFile(
        path: 'chat_images',
        file: imageFile,
        fileExtension: 'jpg',
      );
      String messageId = const Uuid().v4();
      final message = MessageModel(
        senderId: senderId,
        receiverId: receiverId,
        text: imageDownloadedUrl,
        type: MessageEnum.image,
        timeSent: DateTime.now(),
        messageId: messageId,
        isSeen: false,
      );

      UserModel? receiverUserData;

      var userDataMap = await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(receiverId)
          .get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      await _saveDataToContactSubCollection(
          receiverUserData: receiverUserData, lastMessage: "📷");

      await _storeMessage(senderId, receiverId, message.toMap(), messageId);

      await SendNotificationsMethod().sendNotificationsToUsersForNewMessage(
          userName: currentUserName!,
          userId: receiverId,
          messageTypeText: "photo 📷");

            //Saving the notification to firestore

     await NotificationMethod().saveNotificationToFireStore(
          notificationText: "sent photo 📷",
          receiverUserId: receiverId,
          senderUserId: currentUserId);
    } catch (e) {
      showCustomToast('Error sending the message');
    }
  }

  // Send a video message.
  void sendVideoMessage({
    required String senderId,
    required String receiverId,
    required File videoFile,
  }) async {
    try {
      String? currentUserName = UserPreferences.getName();
        String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      final videoDownloadUrl = await uploadFile(
        path: 'chat_videos',
        file: videoFile,
        fileExtension: 'mp4',
      );
      String messageId = const Uuid().v4();
      final message = MessageModel(
        senderId: senderId,
        receiverId: receiverId,
        text: videoDownloadUrl,
        type: MessageEnum.video,
        timeSent: DateTime.now(),
        messageId: messageId,
        isSeen: false,
      );

      UserModel? receiverUserData;

      var userDataMap = await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(receiverId)
          .get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      await _saveDataToContactSubCollection(
          receiverUserData: receiverUserData, lastMessage: "📹");

      await _storeMessage(senderId, receiverId, message.toMap(), messageId);
      await SendNotificationsMethod().sendNotificationsToUsersForNewMessage(
          userName: currentUserName!,
          userId: receiverId,
          messageTypeText: "video 📹");
          
          //Saving the notification to firestore

     await NotificationMethod().saveNotificationToFireStore(
          notificationText: "sent video 📹",
          receiverUserId: receiverId,
          senderUserId: currentUserId);
    } catch (e) {
     showCustomToast('Error sending the message');
    }
  }

  // Send a voice message.
  void sendVoiceMessage({
    required String senderId,
    required String receiverId,
    required File audioFile,
  }) async {
    try {
      String? currentUserName = UserPreferences.getName();
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      final audioUrl = await uploadFile(
        path: 'chat_audio',
        file: audioFile,
        fileExtension: 'mp3',
      );
      String messageId = const Uuid().v4();
      final message = MessageModel(
        senderId: senderId,
        receiverId: receiverId,
        text: audioUrl,
        type: MessageEnum.audio,
        timeSent: DateTime.now(),
        messageId: messageId,
        isSeen: false,
      );

      UserModel? receiverUserData;

      var userDataMap = await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(receiverId)
          .get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      await _saveDataToContactSubCollection(
          receiverUserData: receiverUserData, lastMessage: "🎤");

      await _storeMessage(senderId, receiverId, message.toMap(), messageId);
      await SendNotificationsMethod().sendNotificationsToUsersForNewMessage(
          userName: currentUserName!,
          userId: receiverId,
          messageTypeText: "audio 🎤");
          
          //Saving the notification to firestore

     await NotificationMethod().saveNotificationToFireStore(
          notificationText: "sent voice 🎤",
          receiverUserId: receiverId,
          senderUserId: currentUserId);
    } catch (e) {
  showCustomToast('Error sending the message');
    }
  }

  // Save data to the contact sub-collection.
  Future<void> _saveDataToContactSubCollection(
      {required UserModel receiverUserData,
      required String lastMessage}) async {
    try {
      String? senderName = UserPreferences.getName().toString();
      String? profilePicUrl = UserPreferences.getProfileUrl().toString();
      String? senderId = FirebaseAuth.instance.currentUser!.uid;

      var receiverChatContactModel = ChatContactModel(
        name: senderName,
        profilePicUrl: profilePicUrl,
        contactId: senderId,
        timeSent: DateTime.now(),
        lastMessage: lastMessage,
      );

      await usersCollection
          .doc(receiverUserData.uid)
          .collection(chatsCollection)
          .doc(senderId)
          .set(receiverChatContactModel.toMap());

      var senderChatContactModel = ChatContactModel(
        name: receiverUserData.name!,
        profilePicUrl: receiverUserData.profilePicUrl!,
        contactId: receiverUserData.uid!,
        timeSent: DateTime.now(),
        lastMessage: lastMessage,
      );

      await usersCollection
          .doc(senderId)
          .collection(chatsCollection)
          .doc(receiverUserData.uid)
          .set(senderChatContactModel.toMap());
    } catch (e) {
      print('Error saving data to contact sub-collection: $e');
    }
  }

  // Store a message in Firestore.
  Future<void> _storeMessage(String senderId, String receiverId,
      Map<String, dynamic> messageData, String messageId) async {
    try {
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
    } catch (e) {
      print('Error storing message: $e');
    }
  }

  // Get a stream of chat messages.
  Stream<List<MessageModel>> getChatStream({required String receiverId}) {
    try {
      return usersCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(chatsCollection)
          .doc(receiverId)
          .collection(messageCollection)
          .orderBy("timeSent", descending: false)
          .snapshots()
          .map((event) {
        List<MessageModel> messages = [];
        for (var document in event.docs) {
          messages.add(MessageModel.fromMap(document.data()));
        }
        return messages;
      });
    } catch (e) {
      print('Error getting chat stream: $e');
      return const Stream<List<MessageModel>>.empty();
    }
  }

  // update the isSeen method for chats

  void updateMessageIsSeen(
      {required String receiverId, required String messageId}) async {
    try {
      await usersCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(chatsCollection)
          .doc(receiverId)
          .collection(messageCollection)
          .doc(messageId)
          .update({"isSeen": true});

      await usersCollection
          .doc(receiverId)
          .collection(chatsCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(messageCollection)
          .doc(messageId)
          .update({"isSeen": true});
    } catch (e) {
      print("error updating the isSeen $e");
    }
  }

  // getting the list of contacts for chat Inbox

  Stream<List<ChatContactModel>> getChatsContacts() {
    try {
      return usersCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(chatsCollection)
          .snapshots()
          .asyncMap((event) async {
        List<ChatContactModel> contacts = [];

        for (var document in event.docs) {
          var chatsContacts = ChatContactModel.fromMap(document.data());

          var userData = await FirebaseFirestore.instance
              .collection(userCollection)
              .doc(chatsContacts.contactId)
              .get();
          var user = UserModel.fromMap(userData.data()!);

          contacts.add(ChatContactModel(
            name: user.name!,
            profilePicUrl: user.profilePicUrl!,
            contactId: chatsContacts.contactId,
            timeSent: chatsContacts.timeSent,
            lastMessage: chatsContacts.lastMessage,
          ));
        }
        return contacts;
      });
    } catch (e) {
      // Handle the error here, e.g., print or log it
      print('Error getting chat contacts: $e');
      return const Stream<
          List<
              ChatContactModel>>.empty(); // Return an empty stream or handle the error accordingly
    }
  }

// Function to fetch the count of unread messages for drawer
Future<int> fetchunreadMessagesCount() async {
  final user = FirebaseAuth.instance.currentUser;
  int unreadMessageCount = 0;

  try {
    if (user != null) {
      final userCollectionRef = FirebaseFirestore.instance.collection(userCollection);

      final currentUserDoc = userCollectionRef.doc(user.uid);
      final chatsCollectionRef = currentUserDoc.collection(chatsCollection);

      // Get all chat documents for the current user
      final chatDocuments = await chatsCollectionRef.get();

      for (final chatDocument in chatDocuments.docs) {
        final messagesCollectionRef = chatDocument.reference.collection(messageCollection);

        // Query for unread messages in the current chat where receiverId is the current user's ID
        final querySnapshot = await messagesCollectionRef
            .where('isSeen', isEqualTo: false)
            .where('receiverId', isEqualTo: user.uid)
            .get();

        // Increment the unreadMessageCount with the count of unread messages in this chat
        unreadMessageCount += querySnapshot.size;
      }
    } else {
      // User is not logged in
      unreadMessageCount = 0;
    }
  } catch (e) {
    print('Error fetching unread message count: $e');
    // Handle the error as needed
  }

  return unreadMessageCount;
}


}
