import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zant/frontend/enum/messgae_enum.dart';
import 'package:zant/frontend/screens/homeScreens/chat/widgets/video_player.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';

// Import your project-specific dependencies and enums here

class DisplayMessageCard extends StatefulWidget {
  final String message;
  final MessageEnum type;

  const DisplayMessageCard({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DisplayMessageCardState createState() => _DisplayMessageCardState();
}

class _DisplayMessageCardState extends State<DisplayMessageCard> {
  @override
  Widget build(BuildContext context) {
    return _buildMessage();
  }

  Widget _buildMessage() {
    switch (widget.type) {
      case MessageEnum.text:
        return _buildTextMessage();

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

  Widget _buildVideoMessage() {
    return GestureDetector(
      onLongPress: () {
        showSaveMediaDialog(widget.message, isImage: false);
      },
      child: VideoPlayerItem(
        videoUrl: widget.message,
      ),
    );
  }

  Widget _buildImageMessage() {
    return GestureDetector(
      onLongPress: () {
        showSaveMediaDialog(widget.message, isImage: true);
      },
      // ignore: sized_box_for_whitespace
      child: Container(
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: widget.message,
        ),
      ),
    );
  }

  void showSaveMediaDialog(String mediaUrl, {bool isImage = false}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save ${isImage ? 'Image' : 'Video'}?',
              style: const TextStyle(color: Colors.black)),
          content: Text(
            'Do you want to save this ${isImage ? 'image' : 'video'} to your gallery?',
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _requestPermissionAndSaveMedia(mediaUrl, isImage);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _requestPermissionAndSaveMedia(String mediaUrl, bool isImage) async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isGranted) {
      _saveMediaToGallery(mediaUrl, isImage);
    } else if (status.isDenied || status.isRestricted) {
      status = await Permission.storage.request();
      if (status.isGranted) {
        _saveMediaToGallery(mediaUrl, isImage);
      } else {
        showCustomToast(
            "Permission to save the ${isImage ? 'image' : 'video'} to the gallery was not granted.");
      }
    }
  }

  void _saveMediaToGallery(String mediaUrl, bool isImage) async {
    try {
      var response = await http.get(Uri.parse(mediaUrl));
      final uint8List = Uint8List.fromList(response.bodyBytes);

      if (isImage) {
        final result = await ImageGallerySaver.saveImage(uint8List);

        if (result != null &&
            result.containsKey('isSuccess') &&
            result['isSuccess']) {
          showCustomToast(
            'Image saved successfully',
          );
        } else {
          showCustomToast(
            'Failed to save image',
          );
        }
      } else {
        // Save the video to a temporary file
        final tempVideoFile =
            File('${(await getTemporaryDirectory()).path}/video.mp4');
        await tempVideoFile.writeAsBytes(uint8List);

        // Generate a thumbnail for the video
        final thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: tempVideoFile.path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 64, // Adjust thumbnail size as needed
          quality: 25, // Adjust thumbnail quality as needed
        );

        // Save the video and its thumbnail to the gallery
        final result = await ImageGallerySaver.saveFile(tempVideoFile.path);
        final resultThumbnail =
            await ImageGallerySaver.saveFile(thumbnailPath!);

        if (result != null && resultThumbnail != null) {
          showCustomToast(
            'Video saved successfully',
          );
        } else {
          showCustomToast(
            'Failed to save video',
          );
        }
      }
    } catch (e) {
      showCustomToast(
        'Failed to save ${isImage ? 'image' : 'video'}',
      );
    }
  }

  Widget _buildDefaultMessage() {
    // ignore: sized_box_for_whitespace
    return Container(
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: widget.message,
      ),
    );
  }
}
