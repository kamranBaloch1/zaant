import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:zant/frontend/providers/home/chat_providers.dart';

class BottomChatField extends StatefulWidget {
  final String receiverId;
  final String senderId;
  const BottomChatField({
    Key? key,
    required this.receiverId,
    required this.senderId,
  }) : super(key: key);

  @override
  _BottomChatFieldState createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void _sendTextMessage() async {
    final chatProvider = Provider.of<ChatProviders>(context, listen: false);
    if (isShowSendButton) {
      chatProvider.sendTextMessageProvider(
          senderId: widget.senderId,
          receiverId: widget.receiverId,
          text: _messageController.text.trim());
      setState(() {
        _messageController.clear();
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        // Implement your sendFileMessage logic here
        chatProvider.sendVoiceMessageProvider(
            senderId: widget.senderId,
            receiverId: widget.receiverId,
            audioFile: File(path));
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

// Inside your _ChatScreenState class
  Future<void> _sendImageMessage() async {
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

  void _sendVideo() async {
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

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add your other widgets here
     Row(
  children: [
    // Add an IconButton for sending images
    IconButton(
      icon: const Icon(Icons.image),
      onPressed: _sendImageMessage,
    ),
    // Add an IconButton for sending videos
    IconButton(
      icon: const Icon(Icons.videocam),
      onPressed: _sendVideo,
    ),
    Expanded(
      child: TextFormField(
        style: const TextStyle(
          color: Colors.black
        ),
        focusNode: focusNode,
        controller: _messageController,
        onChanged: (val) {
          if (val.isNotEmpty) {
            setState(() {
              isShowSendButton = true;
            });
          } else {
            setState(() {
              isShowSendButton = false;
            });
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white, // Set the background color to white
          hintText: 'Type a message!',
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: Colors.grey, // Set the border color to grey
              width: 1.0, // Set the border width
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: Colors.grey, // Set the border color to grey
              width: 1.0, // Set the border width
            ),
          ),
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
        right: 2,
        left: 2,
      ),
      child: CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 226, 221, 221),
        radius: 25,
        child: GestureDetector(
          child: Icon(
            isShowSendButton
                ?  Icons.send
                : isRecording
                    ? Icons.close
                    : Icons.mic,
            color: Colors.black,
          ),
          onTap: _sendTextMessage,
        ),
      ),
    ),
  ],
),

      
      ],
    );
  }
}
