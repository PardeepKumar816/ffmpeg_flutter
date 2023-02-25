import 'dart:io';

import 'package:ffmpeg_understanding/screen/video_trim_screen.dart';
import 'package:ffmpeg_understanding/screen/video_upload_screen.dart';
import 'package:ffmpeg_understanding/video_trimmer/trim_editor.dart';
import 'package:ffmpeg_understanding/video_trimmer/trimmer.dart';
import 'package:ffmpeg_understanding/video_trimmer/video_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
// import 'package:video_trimmer/video_trimmer.dart';

import 'common/audio_cutter.dart';
import 'merge_multimedia/home_screen.dart';
import 'merge_multimedia/providers/merge_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ImageAudioApp());
}

class ImageAudioApp extends StatefulWidget {
  const ImageAudioApp({super.key});

  @override
  _ImageAudioAppState createState() => _ImageAudioAppState();
}

class _ImageAudioAppState extends State<ImageAudioApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MergeProvider()),
      ],
      child: const MaterialApp(
        home: VideoUploadScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Trimmer"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("LOAD VIDEO"),
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.video,
              allowCompression: false,
            );
            if (result != null) {
              File file = File(result.files.single.path!);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return VideoTrimmerScreen(file);
                }),
              );
            }
          },
        ),
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final VideoPlayerController _controller = VideoPlayerController.file(
//       File('/storage/emulated/0/Download/Video2.mp4'));
//   double startSelectedPosition = 0;
//   double endSelectedPosition = 0;
//   double selectedDuration = 5000;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller.initialize().then((_) {
//       setState(() {});
//       _controller.addListener(() {
//         setState(() {
//           final currentPosition = _controller.value.position.inMilliseconds;
//           startSelectedPosition = currentPosition as double;
//           endSelectedPosition = currentPosition + selectedDuration;
//           if (endSelectedPosition >
//               _controller.value.duration.inMilliseconds.toDouble()) {
//             endSelectedPosition =
//                 _controller.value.duration.inMilliseconds.toDouble();
//             startSelectedPosition = endSelectedPosition - selectedDuration;
//           }
//         });
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Player Demo'),
//       ),
//       body: Center(
//         child: Stack(
//           children: [
//             VideoPlayer(_controller),
//             Positioned(
//               left: startSelectedPosition,
//               width: endSelectedPosition - startSelectedPosition,
//               child: Container(
//                 height: 5,
//                 color: Colors.red,
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Text('Start Time: ${startSelectedPosition ~/ 1000}s'),
//               Expanded(
//                 child: Slider(
//                   min: 0,
//                   max: _controller.value.duration.inMilliseconds.toDouble(),
//                   onChanged: (value) {
//                     setState(() {
//                       startSelectedPosition = value;
//                       endSelectedPosition = value + selectedDuration;
//                       if (endSelectedPosition >
//                           _controller.value.duration.inMilliseconds
//                               .toDouble()) {
//                         endSelectedPosition = _controller
//                             .value.duration.inMilliseconds
//                             .toDouble();
//                         startSelectedPosition =
//                             endSelectedPosition - selectedDuration;
//                       }
//                     });
//                   },
//                   value: startSelectedPosition,
//                 ),
//               ),
//               Text('End Time: ${endSelectedPosition ~/ 1000}s'),
//               Expanded(
//                 child: Slider(
//                   min: 0,
//                   max: _controller.value.duration.inMilliseconds.toDouble(),
//                   onChanged: (value) {
//                     setState(() {
//                       endSelectedPosition = value;
//                       startSelectedPosition = value - selectedDuration;
//                       if (startSelectedPosition < 0) {
//                         startSelectedPosition = 0;
//                         endSelectedPosition = selectedDuration;
//                       }
//                     });
//                   },
//                   value: endSelectedPosition,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _controller
//               .seekTo(Duration(milliseconds: startSelectedPosition.toInt()));
//           _controller.play();
//         },
//         child: Icon(Icons.play_arrow),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }

// class VideoSelectionScreen extends StatefulWidget {
//   @override
//   _VideoSelectionScreenState createState() => _VideoSelectionScreenState();
// }
//
// class _VideoSelectionScreenState extends State<VideoSelectionScreen> {
//   final VideoPlayerController _controller = VideoPlayerController.file(
//       File('/storage/emulated/0/Download/Video2.mp4'));
//   RangeValues _selectedRange = const RangeValues(0, 0);
//
//   @override
//   void initState() {
//     super.initState();
//     _controller.initialize().then((_) {
//       setState(() {
//         _selectedRange =
//             RangeValues(0, _controller.value.duration.inSeconds.toDouble());
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select video duration'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           ),
//           RangeSlider(
//             min: 0,
//             max: _controller.value.duration.inSeconds.toDouble(),
//             values: _selectedRange,
//             onChanged: (RangeValues newRange) {
//               setState(() {
//                 _controller.value _selectedRange = newRange;
//               });
//             },
//           ),
//           ElevatedButton(
//             child: const Text('Play selected duration'),
//             onPressed: () {
//               _controller
//                   .seekTo(Duration(seconds: _selectedRange.start.toInt()));
//               _controller.setLooping(false);
//               _controller.play();
//               _controller.addListener(() {
//                 if (_controller.value.position.inSeconds >=
//                     _selectedRange.end.toInt()) {
//                   _controller.pause();
//                 }
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Video Trimmer"),
//       ),
//       body: Center(
//         child: Container(
//           child: ElevatedButton(
//             child: Text("LOAD VIDEO"),
//             onPressed: () async {
//               FilePickerResult? result = await FilePicker.platform.pickFiles(
//                 type: FileType.video,
//                 allowCompression: false,
//               );
//               if (result != null) {
//                 File file = File(result.files.single.path!);
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) {
//                     return TrimmerView(file);
//                   }),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class TrimmerView extends StatefulWidget {
//   final File file;
//
//   TrimmerView(this.file);
//
//   @override
//   _TrimmerViewState createState() => _TrimmerViewState();
// }
//
// class _TrimmerViewState extends State<TrimmerView> {
//   final Trimmer _trimmer = Trimmer();
//
//   double _startValue = 0.0;
//   double _endValue = 0.0;
//
//   bool _isPlaying = false;
//   bool _progressVisibility = false;
//
//   Future<String?> _saveVideo() async {
//     setState(() {
//       _progressVisibility = true;
//     });
//
//     String? _value;
//
//     await _trimmer
//         .saveTrimmedVideo(
//             startValue: _startValue,
//             endValue: _endValue,
//             onSave: (String? outputPath) {
//               _value = outputPath;
//             })
//         .then((value) {
//       setState(() {
//         _progressVisibility = false;
//         //_value = value;
//       });
//     });
//
//     return _value;
//   }
//
//   void _loadVideo() {
//     _trimmer.loadVideo(videoFile: widget.file);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _loadVideo();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Video Trimmer"),
//       ),
//       body: Builder(
//         builder: (context) => Center(
//           child: Container(
//             padding: EdgeInsets.only(bottom: 30.0),
//             color: Colors.black,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.max,
//               children: <Widget>[
//                 Visibility(
//                   visible: _progressVisibility,
//                   child: LinearProgressIndicator(
//                     backgroundColor: Colors.red,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _progressVisibility
//                       ? null
//                       : () async {
//                           _saveVideo().then((outputPath) {
//                             print('OUTPUT PATH: $outputPath');
//                             final snackBar = SnackBar(
//                                 content: Text('Video Saved successfully'));
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               snackBar,
//                             );
//                           });
//                         },
//                   child: Text("SAVE"),
//                 ),
//                 Expanded(
//                   child: VideoViewer(trimmer: _trimmer),
//                 ),
//                 Center(
//                   child: TrimViewer(
//                     trimmer: _trimmer,
//                     viewerHeight: 50.0,
//                     viewerWidth: MediaQuery.of(context).size.width,
//                     maxVideoLength: const Duration(seconds: 10),
//                     onChangeStart: (value) => _startValue = value,
//                     onChangeEnd: (value) => _endValue = value,
//                     onChangePlaybackState: (value) =>
//                         setState(() => _isPlaying = value),
//                   ),
//                 ),
//                 TextButton(
//                   child: _isPlaying
//                       ? Icon(
//                           Icons.pause,
//                           size: 80.0,
//                           color: Colors.white,
//                         )
//                       : Icon(
//                           Icons.play_arrow,
//                           size: 80.0,
//                           color: Colors.white,
//                         ),
//                   onPressed: () async {
//                     bool playbackState = await _trimmer.videoPlaybackControl(
//                       startValue: _startValue,
//                       endValue: _endValue,
//                     );
//                     setState(() {
//                       _isPlaying = playbackState;
//                     });
//                   },
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
