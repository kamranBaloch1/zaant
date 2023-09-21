import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
  AudioPlayer audioPlayer = AudioPlayer();
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
    audioPlayer.onDurationChanged.listen(_updateDuration);
    positionTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if (isPlaying) {
        _updatePosition();

        // Check if audio playback is complete by comparing position and duration
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
    return widget.type == MessageEnum.text
        ? Text(
            widget.message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : widget.type == MessageEnum.audio
            ? Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                        ),
                        onPressed: () async {
                          if (!isPlaying) {
                            await audioPlayer.play(
                             UrlSource( widget.message),
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
                              style: TextStyle(fontSize: 16),
                            )
                          : Text(
                              '${audioPosition.inSeconds} sec / ${audioDuration.inSeconds} sec',
                              style: TextStyle(fontSize: 16),
                            ),
                    ],
                  ),
                  if (isPlaying && !audioDurationVisible)
                    LinearProgressIndicator(
                      value: audioPosition.inSeconds / audioDuration.inSeconds,
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                    ),
                ],
              )
            : widget.type == MessageEnum.video
                ? VideoPlayerItem(
                    videoUrl: widget.message,
                  )
                : widget.type == MessageEnum.image // Check for image type
                    ?  Container(
                        width: double.infinity, // Make width full
                        child: CachedNetworkImage(
                          imageUrl: widget.message,
                        ),
                      )
                 : Container(
                        width: double.infinity, // Make width full
                        child: CachedNetworkImage(
                          imageUrl: widget.message,
                        ),
                      );
  }
}
