// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../common/constants.dart';
//
// class MyClass with ChangeNotifier {
//   bool loading = false, isPlaying = false;
//   dynamic limit = 10;
//   late double startTime = 0, endTime = 10;
//
//   void setTimeLimit(dynamic value) async {
//     limit = value;
//     notifyListeners();
//   }
//
//   Future<void> mergeIntoVideo() async {
//     //  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
//     loading = true;
//     String timeLimit = '00:00:';
//     notifyListeners();
//
//     if (await Permission.storage.request().isGranted) {
//       if (limit.toInt() < 10)
//         timeLimit = timeLimit + '0' + limit.toString();
//       else
//         timeLimit = timeLimit + limit.toString();
//
//       /// To combine audio with video
//       ///
//       /// Merging video and audio, with audio re-encoding
//       /// -c:v copy -c:a aac
//       ///
//       /// Copying the audio without re-encoding
//       /// -c copy
//       ///
//       /// Replacing audio stream
//       /// -c:v copy -c:a aac -map 0:v:0 -map 1:a:0
//       ///
//       String commandToExecute1 =
//           '-i ${Constants.VIDEO_PATH} -i ${Constants.videoPath} -filter_complex \'[0:0][1:0]concat=n=2:v=1:a=0[out]\' -map \'[out]\' ${Constants.OUTPUT_PATH}';
//       String commandToExecute =
//           '-r 15 -f mp4 -i ${Constants.VIDEO_PATH} -f mp3 -i ${Constants.AUDIO_PATH} -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -t $timeLimit -y ${Constants.OUTPUT_PATH}';
//
//       /// To combine audio with image
//       // String commandToExecute =
//       //     '-r 15 -f mp3 -i ${Constants.AUDIO_PATH} -f image2 -i ${Constants.IMAGE_PATH} -pix_fmt yuv420p -t $timeLimit -y ${Constants.OUTPUT_PATH}';
//
//       /// To combine audio with gif
//       // String commandToExecute = '-r 15 -f mp3 -i ${Constants
//       //     .AUDIO_PATH} -f gif -re -stream_loop 5 -i ${Constants.GIF_PATH} -y ${Constants
//       //     .OUTPUT_PATH}';
//
//       /// To combine audio with sequence of images
//       // String commandToExecute = '-r 30 -pattern_type sequence -start_number 01 -f image2 -i ${Constants
//       //     .IMAGES_PATH} -f mp3 -i ${Constants.AUDIO_PATH} -y ${Constants
//       //     .OUTPUT_PATH}';
//
//       List<String> videoPaths = [
//         "/storage/emulated/0/Download/Video.mp4",
//         "/storage/emulated/0/Download/Video2.mp4",
//       ];
//
//       String textPath = "/storage/emulated/0/Download/text.txt";
//       String outputPath = "/storage/emulated/0/Download/Output.mp4";
//
//       String command =
//           "-i concat:${videoPaths.join("|")} -vf \"drawtext=textfile=$textPath:fontsize=24:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2\" $outputPath";
//
//       String command1 =
//           "-y -i concat:${videoPaths.join("|")} -vf \"drawtext=text='Day 01':fontfile='/storage/emulated/0/Download/roboto.ttf':fontsize=24:fontcolor=white:x=10:y=10\" $outputPath";
//
//       String command2 =
//           "-i /storage/emulated/0/Download/Video.mp4 -i /storage/emulated/0/Download/Video2.mp4 -filter_complex '[0:v][1:v]concat=n=2:v=1[outv]' -map '[outv]' /storage/emulated/0/Download/Output.mp4";
//
//       String command3 =
//           "-i /storage/emulated/0/Download/Video.mp4 -i /storage/emulated/0/Download/Video2.mp4 -filter_complex \"[0:v]scale=320x240,setsar=1[v0];[1:v]scale=320x240,setsar=1[v1];[v0][0:a][v1][1:a]concat=n=2:v=1:a=1[out]\" -map \"[out]\" /storage/emulated/0/Download/Output.mp4";
//
//       String command4 = "-y -i concat:${videoPaths.join("|")} -vf $outputPath";
//
//       String command5 =
//           "-i /storage/emulated/0/Download/Video.mp4 -i /storage/emulated/0/Download/Video1.mp4 -filter_complex \"nullsrc=size=1920x1080 [base]; [0:v] setpts=PTS-STARTPTS, scale=1920x1080 [bottom]; [1:v] drawtext=text='Your Text Here':fontsize=24:fontcolor=white:x=10:y=10, setpts=PTS-STARTPTS, scale=1920x1080 [top]; [base][bottom][top] vstack=inputs=3\" -codec:v h264 -codec:a aac /storage/emulated/0/Download/example.mp4";
//
//       String command6 =
//           '-i /storage/emulated/0/Download/Video.mp4 -i /storage/emulated/0/Download/Video1.mp4 -filter_complex vstack=inputs=2 /storage/emulated/0/Download/collage1.mp4';
//
//       String command7 =
//           "-i /storage/emulated/0/Download/Video.mp4 -vf drawtext=text='Your Text Here':fontfile=/storage/emulated/0/Download/roboto.ttf:fontsize=24:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2 /storage/emulated/0/Download/collage2.mp4";
//
//       await FFmpegKit.execute(command7).then((rc) {
//         loading = false;
//         notifyListeners();
//         print('FFmpeg process exited with rc: $rc');
//         // controller = VideoPlayerController.asset(Constants.OUTPUT_PATH)
//         //   ..initialize().then((_) {
//         //     notifyListeners();
//         //   });
//       });
//     } else if (await Permission.storage.isPermanentlyDenied) {
//       loading = false;
//       notifyListeners();
//       openAppSettings();
//     }
//   }
// }
