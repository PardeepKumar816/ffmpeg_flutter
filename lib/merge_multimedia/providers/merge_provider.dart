// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
//import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'dart:io';

// import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit_config.dart';
// import 'package:ffmpeg_kit_flutter_full/ffprobe_kit.dart';
// import 'package:ffmpeg_kit_flutter_full/ffprobe_session.dart';
// import 'package:ffmpeg_kit_flutter_full/return_code.dart';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';

// import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

//import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/constants.dart';

class MergeProvider with ChangeNotifier {
  bool loading = false, isPlaying = false;
  dynamic limit = 10;
  late double startTime = 0, endTime = 10;

  void setTimeLimit(dynamic value) async {
    limit = value;
    notifyListeners();
  }

  // Future<void> concatenateVideos(
  //     List<String> videoPaths, String outputPath) async {
  //   // Get the video resolutions and find the largest resolution
  //   int largestWidth = 0;
  //   int largestHeight = 0;
  //   final List<String> inputs = [];
  //   final List<String> filters = [];
  //
  //   for (int i = 0; i < videoPaths.length; i++) {
  //     final session = await FFprobeKit.getMediaInformation(videoPaths[i]);
  //     final mediaInformation = session.getMediaInformation();
  //     // final Map<String, dynamic> videoInfo =
  //     //     mediaInformation!.getAllProperties();
  //     final videoWidth = mediaInformation!.getStreams()[0].getWidth();
  //     final videoHeight = mediaInformation.getStreams()[0].getHeight();
  //     // final int videoWidth = videoInfo["streams"][0]["width"];
  //     // final int videoHeight = videoInfo["streams"][0]["height"];
  //
  //     if (videoWidth! > largestWidth || videoHeight! > largestHeight) {
  //       largestWidth = videoWidth;
  //       largestHeight = videoHeight!;
  //     }
  //
  //     inputs.add('-i ${videoPaths[i]}');
  //     filters.add(
  //         '[$i:v]scale=iw*if(gte(iw,${largestWidth}),1,iw/${largestWidth}):ih*if(gte(ih,${largestHeight}),1,ih/${largestHeight})[v$i]');
  //   }
  //
  //   // Concatenate the videos
  //   final String filter = filters.join(';');
  //   final String command =
  //       '${inputs.join(' ')} -filter_complex "$filter;${filters.map((e) => '[v$e]').join()}concat=n=${videoPaths.length}:v=1[outv]" -map "[outv]" -c:v libx264 -crf 23 -preset veryfast $outputPath';
  //
  //   FFmpegKit.execute(command).then((session) async {
  //     final returnCode = await session.getReturnCode();
  //
  //     if (ReturnCode.isSuccess(returnCode)) {
  //       print(returnCode!.getValue());
  //       print('Success');
  //       // SUCCESS
  //
  //     } else if (ReturnCode.isCancel(returnCode)) {
  //       print(returnCode!.getValue());
  //       print('cancel');
  //       // CANCEL
  //
  //     } else {
  //       print(returnCode!.getValue());
  //       print('error');
  //       // ERROR
  //
  //     }
  //     await session.getFailStackTrace().then((value) => print(value));
  //     //  await session.getOutput().then((value) => print(value));
  //     await session
  //         .getLogs()
  //         .then((value) => print(value.map((e) => print(e.getMessage()))));
  //   });
  // }

  Future<void> mergeIntoVideo() async {
    //  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

    loading = true;
    String timeLimit = '00:00:';
    notifyListeners();

    if (await Permission.storage.request().isGranted) {
      if (limit.toInt() < 10) {
        timeLimit = timeLimit + '0' + limit.toString();
      } else {
        timeLimit = timeLimit + limit.toString();
      }

      /// To combine audio with video
      ///
      /// Merging video and audio, with audio re-encoding
      /// -c:v copy -c:a aac
      ///
      /// Copying the audio without re-encoding
      /// -c copy
      ///
      /// Replacing audio stream
      /// -c:v copy -c:a aac -map 0:v:0 -map 1:a:0
      ///
      String commandToExecute1 =
          '-i ${Constants.VIDEO_PATH} -i ${Constants.videoPath} -filter_complex \'[0:0][1:0]concat=n=2:v=1:a=0[out]\' -map \'[out]\' ${Constants.OUTPUT_PATH}';
      String commandToExecute =
          '-r 15 -f mp4 -i ${Constants.VIDEO_PATH} -f mp3 -i ${Constants.AUDIO_PATH} -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -t $timeLimit -y ${Constants.OUTPUT_PATH}';

      /// To combine audio with image
      // String commandToExecute =
      //     '-r 15 -f mp3 -i ${Constants.AUDIO_PATH} -f image2 -i ${Constants.IMAGE_PATH} -pix_fmt yuv420p -t $timeLimit -y ${Constants.OUTPUT_PATH}';

      /// To combine audio with gif
      // String commandToExecute = '-r 15 -f mp3 -i ${Constants
      //     .AUDIO_PATH} -f gif -re -stream_loop 5 -i ${Constants.GIF_PATH} -y ${Constants
      //     .OUTPUT_PATH}';

      /// To combine audio with sequence of images
      // String commandToExecute = '-r 30 -pattern_type sequence -start_number 01 -f image2 -i ${Constants
      //     .IMAGES_PATH} -f mp3 -i ${Constants.AUDIO_PATH} -y ${Constants
      //     .OUTPUT_PATH}';

      List<String> videoPaths = [
        "/storage/emulated/0/Download/Video.mp4",
        "/storage/emulated/0/Download/Video2.mp4",
      ];

      String textPath = "/storage/emulated/0/Download/text.txt";
      String outputPath = "/storage/emulated/0/Download/Output.mp4";

      String command =
          "-i concat:${videoPaths.join("|")} -vf \"drawtext=textfile=$textPath:fontsize=24:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2\" $outputPath";

      String command1 =
          "-y -i concat:${videoPaths.join("|")} -vf \"drawtext=text='Day 01':fontfile='/storage/emulated/0/Download/roboto.ttf':fontsize=24:fontcolor=white:x=10:y=10\" $outputPath";

      String command2 =
          "-i /storage/emulated/0/Download/Video.mp4 -i /storage/emulated/0/Download/Video2.mp4 -filter_complex '[0:v][1:v]concat=n=2:v=1[outv]' -map '[outv]' /storage/emulated/0/Download/Output.mp4";

      String command3 =
          "-i /storage/emulated/0/Download/Video.mp4 -i /storage/emulated/0/Download/Video2.mp4 -filter_complex \"[0:v]scale=320x240,setsar=1[v0];[1:v]scale=320x240,setsar=1[v1];[v0][0:a][v1][1:a]concat=n=2:v=1:a=1[out]\" -map \"[out]\" /storage/emulated/0/Download/Output.mp4";

      String command4 = "-y -i concat:${videoPaths.join("|")} -vf $outputPath";

      String command5 =
          "-i /storage/emulated/0/Download/Video.mp4 -i /storage/emulated/0/Download/Video1.mp4 -filter_complex \"nullsrc=size=1920x1080 [base]; [0:v] setpts=PTS-STARTPTS, scale=1920x1080 [bottom]; [1:v] drawtext=text='Your Text Here':fontsize=24:fontcolor=white:x=10:y=10, setpts=PTS-STARTPTS, scale=1920x1080 [top]; [base][bottom][top] vstack=inputs=3\" -codec:v h264 -codec:a aac /storage/emulated/0/Download/example.mp4";

      String command6 =
          '-i /storage/emulated/0/Download/v3.mp4 -i /storage/emulated/0/Download/v4.mp4 -filter_complex vstack=inputs=2 /storage/emulated/0/Download/o1.mp4';

      String command7 =
          "-i /storage/emulated/0/Download/Video1.mp4 -vf drawtext=text='Your Text Here':fontfile=/storage/emulated/0/Download/roboto.ttf:fontsize=24:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2 /storage/emulated/0/Download/collage2.mp4";

      String command8 =
          '-i /storage/emulated/0/Download/Video1.mp4 -vf "drawtext=fontfile=/storage/emulated/0/Download/roboto.ttf:text=\'Stack Overflow\':fontcolor=white:fontsize=24:box=1:boxcolor=black@0.5:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" -codec:a copy /storage/emulated/0/Download/output.mp4';

      String command9 =
          '-i /storage/emulated/0/Download/Video1.mp4 -vf "drawtext=text=\'Hello, World!\':fontfile=/storage/emulated/0/Download/roboto.ttf:font=Roboto:fontcolor=white:fontsize=24:box=1:boxcolor=black@0.5:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" -codec:a copy /storage/emulated/0/Download/output7.mp4';
      String command10 =
          '-i /storage/emulated/0/Download/v1.mp4 -i /storage/emulated/0/Download/v3.mp4 \-filter_complex "[0:v] [0:a] [1:v] [1:a] \concat=n=2:v=1:a=1 [v] [a]" \-map "[v]" -map "[a]" /storage/emulated/0/Download/o10.mp4';
      // final fontFile = await rootBundle.load("assets/Raleway-Regular.ttf");
      // final fontFilePath =
      //     "${(await getTemporaryDirectory()).path}/Raleway-Regular.ttf";
      // File fontFileTmp = File(fontFilePath);
      // await fontFileTmp.writeAsBytes(fontFile.buffer
      //     .asUint8List(fontFile.offsetInBytes, fontFile.lengthInBytes));
      //
      // String addTextToVideoCommand =
      //     '-i /storage/emulated/0/Download/Video1.mp4 '
      //     '-vf drawtext="text=\'text\':fontfile=$fontFilePath: fontcolor=white: fontsize=50: box=1: boxcolor=black@0.5: boxborderw=5: x=(w-text_w)/2: y=(h-text_h)/2" '
      //     '-c:v mpeg4 -c:a copy /storage/emulated/0/Download/output10.mp4';

      // final drawTextFilter = DrawTextFilter(
      //   enable: true,
      //   text: "Hello world",
      //   fontfile: fontFilePath,
      //   fontsize: "24",
      //   fontcolor: "white",
      //   x: "(w-text_w)/2",
      //   y: "(h-text_h)/2",
      //   box: 1,
      //   boxcolor: "black@0.5",
      //   boxborderw: 5,
      // );

      // await _flutterFFmpeg.execute(command7).then((rc) {
      //   loading = false;
      //   notifyListeners();
      //   print('FFmpeg process exited with rc: $rc');
      //   // controller = VideoPlayerController.asset(Constants.OUTPUT_PATH)
      //   //   ..initialize().then((_) {
      //   //     notifyListeners();
      //   //   });
      // });

      // await FFmpegKit.execute(command7).then((rc) async {
      //   loading = false;
      //   notifyListeners();
      //   FFmpegKitConfig.enableLogs();
      //   final state = FFmpegKitConfig.sessionStateToString(await rc.getState());
      //   print('state $state');
      //   final returnCode = await rc.getReturnCode();
      //   final failStackTrace = await rc
      //       .getFailStackTrace()
      //       .then((value) => print('failStackTrace $value'));
      //   //  rc.getOutput().then((output) => print('output $output'));
      //   print('FFmpeg process exited with rc: $returnCode.');
      //   // controller = VideoPlayerController.asset(Constants.OUTPUT_PATH)
      //   //   ..initialize().then((_) {
      //   //     notifyListeners();
      //   //   });
      // });

      // final returnSession = await FFmpegKit.execute(
      //     '-v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 /storage/emulated/0/Download/Video1.mp4');

      // FFprobeKit.getMediaInformation('/storage/emulated/0/Download/Video1.mp4')
      //     .then((session) async {
      //   final information = session.getMediaInformation();
      //   final width = information!.getStreams()[0].getWidth();
      //   final height = information!.getStreams()[0].getHeight();
      // });

      // String cmd =
      //     '-i /storage/emulated/0/Download/v4.mp4 -vf scale=640:352 -c:a copy /storage/emulated/0/Download/Video5.mp4';
      // final outerSession = await FFmpegKit.execute(
      //     '-i /storage/emulated/0/Download/v4.mp4 -vf scale=640:352 -preset slow -crf 18 /storage/emulated/0/Download/v6.mp4');
      // await outerSession
      //     .getLogs()
      //     .then((value) => print(value.map((e) => print(e.getMessage()))));

      String command11 =
          '-i /storage/emulated/0/Download/v2.mp4 -i /storage/emulated/0/Download/collage1.mp4 -filter_complex "[0]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1[v0];[1]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1[v1];[v0][0:a:0][v1][1:a:0]concat=n=2:v=1:a=1[v][a]" -map "[v]" -map "[a]" /storage/emulated/0/Download/o13.mp4';
      String mergeVideos =
          '-i /storage/emulated/0/Download/v1mpeg2.mp4 -i /storage/emulated/0/Download/o21.mp4 -filter_complex "[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,setsar=1[v0];[1:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,setsar=1[v1];[0:a]aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=stereo[a0];[1:a]aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=stereo[a1];[v0][a0][v1][a1]concat=n=2:v=1:a=1[v][a]" -map "[v]" -map "[a]" -c:v mpeg4 -q:v 2 -c:a aac -b:a 192k -f mp4 /storage/emulated/0/Download/o23.mp4';
      String toMpeg4 =
          '-i /storage/emulated/0/Download/v1.mp4 -c:v mpeg4 -q:v 2 -c:a copy /storage/emulated/0/Download/v1mpeg.mp4';

      String toMpeg4Full =
          '-i /storage/emulated/0/Download/v1.mp4 -c:v mpeg4 -pix_fmt yuv420p -s 848x960 -aspect 53:60 -b:v 9704k -c:a copy /storage/emulated/0/Download/v1mpeg2.mp4';
      String to =
          '-i /storage/emulated/0/Download/v1.mp4 -i /storage/emulated/0/Download/o21.mp4 -filter_complex "[0:v]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2[v0];[1:v]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2[v1];[v0][0:a][v1][1:a]concat=n=2:v=1:a=1" -c:v mpeg4 -crf 23 -preset medium -r 30 /storage/emulated/0/Download/o101.mp4';

      String command6_2 =
          '-i /storage/emulated/0/Download/v3.mp4 -i /storage/emulated/0/Download/v4.mp4 -filter_complex vstack=inputs=2 -c:v mpeg4 -c:a aac -f mp4 /storage/emulated/0/Download/o100.mp4';

      String videoConversion =
          '-i /storage/emulated/0/Download/p1.mp4 -acodec libshine -b:a 128k -vcodec mpeg4 -b:v 4000k -maxrate 4000k -bufsize 8000k -s 480x600 -r 30 -aspect 53:80 -vf "setsar=1/1" -strict experimental /storage/emulated/0/Download/o18.mp4';

      String videoConversionWithoutChangingHeight =
          '-i /storage/emulated/0/Download/o1.mp4 -acodec libshine -vcodec libx264 -vf "scale=480:-2" -r 30 -strict experimental /storage/emulated/0/Download/o7.mp4';

      String mergeVideoUseful =
          '-i /storage/emulated/0/Download/o15.mp4 -i /storage/emulated/0/Download/o17.mp4 -i /storage/emulated/0/Download/o18.mp4 \-filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0]concat=n=3:v=1:a=1[outv][outa]" \-map "[outv]" -map "[outa]" /storage/emulated/0/Download/o4.mp4';

      String removingAudio = '-i input.mp4 -c:v copy -an output.mp4';

      String replacingAudioWithAnotherAudio =
          '-i /storage/emulated/0/Download/o13.mp4 -i /storage/emulated/0/Download/audio.mp3 -map 0:v:0 -map 1:a:0 -c:v copy -c:a libshine -b:a 256k /storage/emulated/0/Download/o14.mp4';

      String cuttingVideo =
          '-ss 00:00:05 -to 00:00:15 -i /storage/emulated/0/Download/o14.mp4 -c copy /storage/emulated/0/Download/o15.mp4';

      //   final fontFile = await rootBundle.load("assets/Raleway-Regular.ttf");
      //   final fontFilePath =
      //       "${(await getTemporaryDirectory()).path}/Raleway-Regular.ttf";
      //   File fontFileTmp = File(fontFilePath);
      //   await fontFileTmp.writeAsBytes(fontFile.buffer
      //       .asUint8List(fontFile.offsetInBytes, fontFile.lengthInBytes));
      //
      //   String addTextToVideoCommand =
      //       '-i /storage/emulated/0/Download/v3.mp4 '
      //       '-vf drawtext="text=\'goa beach india\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=50: y=300" '
      //       '-c:v mpeg4 -c:a copy /storage/emulated/0/Download/o6.mp4';
      //
      //   String textCommand2 = '-i /storage/emulated/0/Download/o1.mp4 '
      //  '-vf "drawtext=text=\'center text\':fontfile=$fontFilePath:fontcolor=white:fontsize=50:box=1:boxcolor=black@0.5:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2,'
      //  'drawtext=text=\'top-left text\':fontfile=$fontFilePath:fontcolor=white:fontsize=50:box=1:boxcolor=black@0.5:boxborderw=5:x=10:y=10" '
      //  '-c:v mpeg4 -c:a copy /storage/emulated/0/Download/o2.mp4';
      //
      //   String input = '/storage/emulated/0/Download/v3.mp4';
      //   String output = '/storage/emulated/0/Download/o6.mp4';
      //   String xAxis = '20';
      //   String yAxis = '20';
      //   String days = '12 days';
      //   String text = 'hello';
      //
      // String  newCommand = '-i $input '
      //       '-vf "drawtext=text=\'$days\':fontfile=$fontFilePath:fontcolor=black:fontsize=65:box=1:boxcolor=white:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2,'
      //       'drawtext=text=\'$text\':fontfile=$fontFilePath:fontcolor=black:fontsize=50:box=1:boxcolor=white:boxborderw=5:x=$xAxis:y=$yAxis" '
      //       '-c:v mpeg4 -c:a copy $output';
      //
      //   String vStackCommand2 ='-i /storage/emulated/0/Download/videoText1.mp4 -i /storage/emulated/0/Download/videoText2.mp4 -i /storage/emulated/0/Download/videoText3.mp4 -filter_complex vstack=inputs=3 /storage/emulated/0/Download/vstack1.mp4';

      String x =
          '-i /storage/emulated/0/Download/o12.mp4 -i /storage/emulated/0/Download/o12.mp4 \-filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0]concat=n=2:v=1:a=1[outv][outa]" \-map "[outv]" -map "[outa]" /storage/emulated/0/Download/o1.mp4';
      String y =
          '-i /storage/emulated/0/Download/videoDoubleText1.mp4 -acodec libshine -vcodec libkvazaar -b:v 1000k -s 480x600 -r 30 -strict experimental /storage/emulated/0/Download/o3.mp4';

      String ok = '-i /storage/emulated/0/Download/sameFormatVideo1.mp4 '
          '-i /storage/emulated/0/Download/sameFormatVideo2.mp4 '
          '-i /storage/emulated/0/Download/sameFormatVideo3.mp4 '
          '-i /storage/emulated/0/Download/sameFormatVideo4.mp4 '
          '-i /storage/emulated/0/Download/sameFormatVideo5.mp4 '
          '-i /storage/emulated/0/Download/sameFormatVideo6.mp4 '
          '-i /storage/emulated/0/Download/sameFormatVideo7.mp4 '
          '-i /storage/emulated/0/Download/sameFormatVideo8.mp4 '
          '-i /storage/emulated/0/Download/sameFormatVideo9.mp4 '
          '-i /storage/emulated/0/Download/sameFormatVideo10.mp4 '
          '-i /storage/emulated/0/Download/sameFormatVideo11.mp4 '
          '-i /storage/emulated/0/Download/sameFormatVideo12.mp4 '
          '-filter_complex '
          '"[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0]'
          '[4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0]'
          '[8:v:0][8:a:0][9:v:0][9:a:0][10:v:0][10:a:0][11:v:0][11:a:0]'
          'concat=n=12:v=1:a=1[outv][outa]" '
          '-map "[outv]" '
          '-map "[outa]" '
          '/storage/emulated/0/Download/output.mp4';

      FFmpegKit.execute(ok).then((session) async {
        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          print(returnCode!.getValue());
          print('Success');
          // SUCCESS

        } else if (ReturnCode.isCancel(returnCode)) {
          print(returnCode!.getValue());
          print('cancel');
          // CANCEL

        } else {
          print(returnCode!.getValue());
          print('error');
          // ERROR

        }
        await session.getFailStackTrace().then((value) => print(value));
        //  await session.getOutput().then((value) => print(value));
        // await session
        //     .getAllLogs()
        //     .then((value) => print(value.map((e) => print(e.getMessage()))));

        await session
            .getLogs()
            .then((value) => print(value.map((e) => print(e.getMessage()))));
      });
    } else if (await Permission.storage.isPermanentlyDenied) {
      loading = false;
      notifyListeners();
      openAppSettings();
    }
  }
}
