// // ignore_for_file: public_member_api_docs, sort_constructors_first

// import 'package:flutter/material.dart';
// import 'package:zant/global/utils.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class AudioCallScreen extends StatelessWidget {
//   final String callID;
//   final String userName;
//   final String userID;

//   const AudioCallScreen({
//     Key? key,
//     required this.callID,
//     required this.userName,
//     required this.userID,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: ZegoUIKitPrebuiltCall(
//       appID: appID,
//       appSign: appSign,
//       callID: callID,
//       userID: userID,
//       userName: userName,
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
//         ..onOnlySelfInRoom = (context) {
//           Navigator.pop(context);
//         },
//     ));
//   }
// }
