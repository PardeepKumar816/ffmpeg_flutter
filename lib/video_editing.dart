// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
//
// class VideoCollageScreen extends StatefulWidget {
//   const VideoCollageScreen({super.key});
//
//   @override
//   _VideoCollageScreenState createState() => _VideoCollageScreenState();
// }
//
// class _VideoCollageScreenState extends State<VideoCollageScreen> {
//   late VideoPlayerController _controller;
//   final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
//   late String _collagePath;
//
//   @override
//   void initState() {
//     super.initState();
//     createCollage();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Collage'),
//       ),
//       body: _controller.value.isInitialized
//           ? AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             )
//           : Container(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _controller.value.isPlaying
//                 ? _controller.pause()
//                 : _controller.play();
//           });
//         },
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     );
//   }
//
//   void createCollage() async {
//     List<String> videoPaths = [
//       "/storage/emulated/0/Download/Video.mp4",
//       "/storage/emulated/0/Download/Video2.mp4",
//     ];
//     String collagePath = await getCollagePath();
//     await _flutterFFmpeg
//         .execute(
//           '-i concat:${videoPaths.join('|')} -c copy $collagePath',
//         )
//         .then((value) => print(value));
//     setState(() {
//       _collagePath = collagePath;
//       _controller = VideoPlayerController.file(File(_collagePath))
//         ..initialize().then((_) {
//           setState(() {});
//         });
//     });
//   }
//
//   Future<String> getCollagePath() async {
//     Directory tempDir = await getTemporaryDirectory();
//     return '${tempDir.path}/collage.mp4';
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }
