// class _BottomChatFieldState extends State<BottomChatField> {
//   bool isShowSendButton = false; // Initialize as false

//   // ...

//   void _sendTextMessage() async {
//     // Enable the send button when there is text in the input field
//     setState(() {
//       isShowSendButton = _messageController.text.trim().isNotEmpty;
//     });

//     final chatProvider = Provider.of<ChatProviders>(context, listen: false);
//     if (isShowSendButton) {
//       // Set isSendingText to true before sending
//       widget.onSendingText(true);
//       chatProvider.sendTextMessageProvider(
//         senderId: widget.senderId,
//         receiverId: widget.receiverId,
//         text: _messageController.text.trim(),
//       );
//       setState(() {
//         _messageController.clear();
//         // Reset isSendingText to false after sending
//         widget.onSendingText(false);
//         isShowSendButton = false; // Reset send button state
//       });
//     }
//   }

//   Future<void> _sendImageMessage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       File imageFile = File(pickedFile.path);
//       final chatProvider = Provider.of<ChatProviders>(context, listen: false);
//       // Implement your logic for sending image message here
//       chatProvider.sendImageMessageProvider(
//         senderId: widget.senderId,
//         receiverId: widget.receiverId,
//         imageFile: imageFile,
//       );
//       // Reset send button state
//       setState(() {
//         isShowSendButton = false;
//       });
//     }
//   }

//   void _sendVideo() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       File videoFile = File(pickedFile.path);
//       final chatProvider = Provider.of<ChatProviders>(context, listen: false);
//       // Implement your logic for sending video message here
//       chatProvider.sendVideoMessageProvider(
//         senderId: widget.senderId,
//         receiverId: widget.receiverId,
//         videoFile: videoFile,
//       );
//       // Reset send button state
//       setState(() {
//         isShowSendButton = false;
//       });
//     }
//   }

//   // Add this method for sending voice messages
//   void _sendVoiceMessage() async {
//     var tempDir = await getTemporaryDirectory();
//     var path = '${tempDir.path}/flutter_sound.aac';
//     if (!isRecorderInit) {
//       return;
//     }
//     if (isRecording) {
//       await _soundRecorder!.stopRecorder();
//       final chatProvider = Provider.of<ChatProviders>(context, listen: false);
//       // Implement your logic for sending voice message here
//       chatProvider.sendVoiceMessageProvider(
//         senderId: widget.senderId,
//         receiverId: widget.receiverId,
//         audioFile: File(path),
//       );
//     } else {
//       await _soundRecorder!.startRecorder(
//         toFile: path,
//       );
//     }

//     setState(() {
//       isRecording = !isRecording;
//       // Enable send button when recording is complete
//       isShowSendButton = !isRecording;
//     });
//   }

//   // ...
// }
