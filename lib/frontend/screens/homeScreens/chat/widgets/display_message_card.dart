import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zant/frontend/enum/messgae_enum.dart';
import 'package:zant/frontend/screens/homeScreens/chat/widgets/video_player.dart';

class DisplayMessageCard extends StatefulWidget {
  final String message;
  final MessageEnum type;

  DisplayMessageCard({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  _DisplayMessageCardState createState() => _DisplayMessageCardState();
}

class _DisplayMessageCardState extends State<DisplayMessageCard> {
  bool isPlaying = false;
  bool audioDurationVisible = true;
  Duration audioDuration = Duration();
  Duration audioPosition = Duration();
  late AudioPlayer audioPlayer;
  late Timer positionTimer;

  void _updateDuration(Duration duration) {
    setState(() {
      audioDuration = duration;
    });
  }

  void _updatePosition() {
    setState(() {
      audioPosition += Duration(seconds: 1);
    });
  }

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onDurationChanged.listen(_updateDuration);
    positionTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if (isPlaying) {
        _updatePosition();
        if (audioPosition >= audioDuration) {
          setState(() {
            isPlaying = false;
            audioDurationVisible = true;
            audioPosition = Duration(); // Reset position
          });
        }
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    positionTimer.cancel();
    super.dispose();
  }

  void _resetPosition() {
    setState(() {
      audioPosition = Duration();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildMessage();
  }

  Widget _buildMessage() {
    switch (widget.type) {
      case MessageEnum.text:
        return _buildTextMessage();
      case MessageEnum.audio:
        return _buildAudioMessage();
      case MessageEnum.video:
        return _buildVideoMessage();
      case MessageEnum.image:
        return _buildImageMessage();
      default:
        return _buildDefaultMessage();
    }
  }

  Widget _buildTextMessage() {
    return Text(
      widget.message,
      style: TextStyle(
        fontSize: 16.sp,
      ),
    );
  }

  Widget _buildAudioMessage() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              constraints: BoxConstraints(
                minWidth: 100.w,
              ),
              onPressed: () async {
                if (!isPlaying) {
                  await audioPlayer.play(
                    UrlSource(widget.message),
                    mode: PlayerMode.mediaPlayer,
                  );
                  _resetPosition();
                  setState(() {
                    isPlaying = true;
                    audioDurationVisible = false;
                  });
                } else {
                  await audioPlayer.pause();
                  setState(() {
                    isPlaying = false;
                    audioDurationVisible = true;
                  });
                }
              },
              icon: Icon(
                isPlaying ? Icons.pause_circle : Icons.play_circle,
              ),
            ),
            audioDurationVisible
                ? Text(
                    '${audioDuration.inSeconds} sec',
                    style: const TextStyle(fontSize: 16),
                  )
                : Text(
                    '${audioPosition.inSeconds} sec / ${audioDuration.inSeconds} sec',
                    style: const TextStyle(fontSize: 16),
                  ),
          ],
        ),
        if (isPlaying && !audioDurationVisible)
          LinearProgressIndicator(
            value: audioPosition.inSeconds / audioDuration.inSeconds,
            minHeight: 8.h,
            backgroundColor: Colors.grey[300],
          ),
      ],
    );
  }

  Widget _buildVideoMessage() {
    return VideoPlayerItem(
      videoUrl: widget.message,
    );
  }

  Widget _buildImageMessage() {
    return Container(
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: widget.message,
      ),
    );
  }

  Widget _buildDefaultMessage() {
    return Container(
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: widget.message,
      ),
    );
  }
}
