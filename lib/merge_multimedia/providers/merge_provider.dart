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
      final fontFile = await rootBundle.load("assets/Raleway-Regular.ttf");
      final fontFilePath =
          "${(await getTemporaryDirectory()).path}/Raleway-Regular.ttf";
      File fontFileTmp = File(fontFilePath);
      await fontFileTmp.writeAsBytes(fontFile.buffer
          .asUint8List(fontFile.offsetInBytes, fontFile.lengthInBytes));
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

      String c = '-i /storage/emulated/0/Download/6.mp4 '
          '-vf "drawtext=text=\'day 1\':fontfile=$fontFilePath:fontcolor=black:fontsize=65:box=1:boxcolor=white:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2,'
          'drawtext=text=\'hello world\':fontfile=$fontFilePath:fontcolor=black:fontsize=50:box=1:boxcolor=white:boxborderw=5:x=40:y=50" '
          '-c:v mpeg4 -c:a copy /storage/emulated/0/Download/a.mp4';
      //libvpx-vp9 -crf 30 -b:v 0 -pix_fmt yuv420p

      String d =
      '-i /storage/emulated/0/Download/o.mp4 -acodec libshine -b:a 128k -vcodec libvpx-vp9 -crf 30 -b:v 4000k -pix_fmt yuv420p -maxrate 4000k -bufsize 8000k -s 480x600 -r 30 -aspect 53:80 -vf "setsar=1/1" -strict experimental /storage/emulated/0/Download/d.mp4';

      String filter1 = '-i /storage/emulated/0/Download/1.mp4 -vf lutrgb=r=\'0.393*val+0.769*val+0.189*val\':g=\'0.349*val+0.686*val+0.168*val\':b=\'0.272*val+0.534*val+0.131*val\' -pix_fmt yuv420p -c:a copy /storage/emulated/0/Download/o1.mp4';

      String filter2 = '-i /storage/emulated/0/Download/1.mp4 -vf colorchannelmixer=rr=0.33:gg=0.33:bb=0.33 -pix_fmt yuv420p -c:a copy /storage/emulated/0/Download/o1.mp4';

      String filter3 = '-i /storage/emulated/0/Download/1.mp4 -vf hue=s=0 -pix_fmt yuv420p -c:a copy /storage/emulated/0/Download/o1.mp4';

      String filter4 = '-i /storage/emulated/0/Download/1.mp4 -vf format=green /storage/emulated/0/Download/o1.mp4';

      String filter5 = ' -i /storage/emulated/0/Download/1.mp4 -vf curves=vintage /storage/emulated/0/Download/o.mp4';

      String filter6 = '-i /storage/emulated/0/Download/6.mp4 -i /storage/emulated/0/Download/movie.png -filter_complex "[0:v]scale=1280:-2[bg];[1:v]scale=1280:-2[movie];[bg][movie]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2,format=yuv420p[v]" -map "[v]" -map 0:a? -c:a copy /storage/emulated/0/Download/o.mp4';

      String filter7 = '-y -f rawvideo -pix_fmt rgb32 -s 1920x1080 -i /storage/emulated/0/Download/1.mp4 -r 30 -i -filter_complex "[0:v]chromakey=0x008000:blend=0:similarity=0.15, movie=/storage/emulated/0/Download/movie.png [sqr];[sqr]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2[canvas];[canvas][0:v]overlay=shortest=1[mix1];[mix1]movie=1.mp4,scale=1920:1080[i1];[i1]overlay=\'if(gt(random(0), 0.2), 1, 4)\':\'if(gt(random(0), 0.1), 1, 2)\',colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131[i2];[grit_i1]chromakey=0x16FF0A:blend=0.2:similarity=0.3,colorchannelmixer=.3:.4:.3:0:.3:.4:.3:0:.3:.4:.3[grit1];[grit1][i2]overlay=shortest=1[o1];[o1][0:v]overlay=shortest=1[o]" -map "[o]" -c:v mpeg4 -crf 31 -frames:v 300 /storage/emulated/0/Download/o.mp4';

      String filter8 = '-i /storage/emulated/0/Download/6.mp4 -i /storage/emulated/0/Download/movie.png -filter_complex "[0:v]scale=1280:-2[bg];[1:v]scale=1280:-2[movie];[bg][movie]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2,format=yuv420p,hue=h=0.5: s=1.5,colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131[v]" -map "[v]" -map 0:a? -c:a copy /storage/emulated/0/Download/o.mp4';

      String filter9 = '-i /storage/emulated/0/Download/6.mp4 -i /storage/emulated/0/Download/movie.png -filter_complex "[0:v]scale=1280:-2[bg];[1:v]scale=1280:-2[movie];[bg][movie]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2,format=yuv420p,hue=h=0.5: s=1.5,colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131[bg_with_overlay_and_color];[bg_with_overlay_and_color][0:a?]overlay=format=yuv420[v]" -map "[v]" -c:a copy /storage/emulated/0/Download/o.mp4';


      String filter10 = '-i /storage/emulated/0/Download/6.mp4 -i /storage/emulated/0/Download/movie.png -filter_complex "[0:v]scale=1280:-2[bg];[1:v]scale=1280:-2[movie];[bg][movie]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2,format=yuv420p,hue=h=0.5:s=1.5,colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131[v];[v]scale=1280:-2,format=yuv420p,geq=\'if(gt(random(0), 0.2), 1, 4)\',geq=\'if(gt(random(0), 0.1), 1, 2)\'[shaken]" -map "[shaken]" -map 0:a? -c:a copy /storage/emulated/0/Download/o.mp4';

      String filter11 = '-i /storage/emulated/0/Download/6.mp4 -i /storage/emulated/0/Download/movie.jpg -filter_complex "[0:v]curves=preset=vintage[old_movie];[1:v]lut3d=file=/storage/emulated/0/Download/movie.jpg:interp=trilinear[scratch_lut];[old_movie][scratch_lut]overlay,noise=alls=30:allf=t+u,vignette=PI/4,format=yuv420p" -c:a copy -pix_fmt yuv420p /storage/emulated/0/Download/o.mp4';
      String filter12 = "-i /storage/emulated/0/Download/6.mp4 -filter_complex \"[0:v]format=yuva420p,split[v1][v2];[v1]colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131[v3];[v2][v3]overlay[v]\" -map \"[v]\" -map 0:a -c:a copy /storage/emulated/0/Download/o.mp4";
      String filter13 = "-i /storage/emulated/0/Download/6.mp4 -filter_complex "
          "\"[0:v]curves=all='0/0.1 0.4/0.5 0.6/0.7 1/1':green='0/0.1 0.5/0.5 1/1':blue='0/0.5 1/0.5',noise=alls=50:allf=t+u,split[v1][v2]; "
          "[v1]palettegen=reserve_transparent=off:stats_mode=single[maxp]; "
          "[v2][maxp]paletteuse=new=1\" /storage/emulated/0/Download/o.mp4";
      String filter14 = "-i /storage/emulated/0/Download/6.mp4 -i /storage/emulated/0/Download/movie.png -i /storage/emulated/0/Download/movie.png -filter_complex \"[0:v]format=rgba[in];[1:v]format=rgba,geq='if(lt(random(1)*1.3\\,30)\\,255\\,0)',hue=s=0[grain];[2:v]format=rgba,geq='if(lt(random(1)*1.5\\,30)\\,255\\,0)',hue=s=0[dust];[in][grain]overlay=format=auto:shortest=1[ovr1];[ovr1][dust]overlay=format=auto:shortest=1:x='if(eq(mod(n,2)\\,0)\\,W/8\\,0)':y='if(eq(mod(n,2)\\,0)\\,H/8\\,0)'\" /storage/emulated/0/Download/o.mp4";
      String filter15 = "-i /storage/emulated/0/Download/6.mp4 -i /storage/emulated/0/Download/overlay.mp4 -filter_complex \"[0:v]curves=preset=vintage[a];[1:v]colorkey=0x000000:0.1:0.2[ckout];[a][ckout]overlay=0:0\" -c:a copy -c:v libvpx-vp9 -b:v 2M /storage/emulated/0/Download/o.mp4";
      String filter16 = '-i /storage/emulated/0/Download/6.mp4 -vf "colorbalance=bs=0.3" -c:a copy /storage/emulated/0/Download/o.mp4';
      String filter17 = "-i /storage/emulated/0/Download/fair.mp4 -vf \"curves=all='0/0 0.5/0.7 1/1'\" -c:a copy -c:v libvpx-vp9 -crf 28 -b:v 0 -pix_fmt yuv420p -threads 4 /storage/emulated/0/Download/o.mp4";
      String filter18 = "-i /storage/emulated/0/Download/fair.mp4 -vf \"curves=all='0/0 0.5/0.7 1/1', colorchannelmixer=rr=0.7686:rb=0.0:gr=0.3055:gg=0.6902:gb=0.1226:br=0.1176:bg=0.0588:bb=0.0\" -c:a copy -c:v libvpx-vp9 -crf 28 -b:v 0 -pix_fmt yuv420p -threads 4 /storage/emulated/0/Download/o.mp4";
      String filter19 = '-i /storage/emulated/0/Download/fair.mp4 -vf "colorbalance=rs=0.5:gs=0.5:bs=0.5, colorchannelmixer=rr=1.05:rb=-0.02:gr=-0.06:gg=1.05:gb=-0.02:br=-0.06:bg=-0.02:bb=1.05, colorchannelmixer=rr=1.02:rb=0:gr=0:gg=1.02:gb=0:br=0:bg=0:bb=1.02, colorbalance=rs=0.5:gs=0.5:bs=0.5" -c:a copy /storage/emulated/0/Download/p.mp4';
      String animation1  = " -i /storage/emulated/0/Download/fair.mp4  -i /storage/emulated/0/Download/fair.mp4 -filter_complex \"[0:v]format=argb,rotate='min(0,3.75-t)*2*PI:ow=hypot(iw,ih):oh=ow:c=black@0',setpts=PTS-STARTPTS[0v];[1:v]format=argb,rotate='max(0,0.25-t)*2*PI:ow=hypot(iw,ih):oh=ow:c=black@0',setpts=PTS-STARTPTS+3.75/TB[1v];[v0][v1]concat=n=2:v=1:a=0\" -c:v mpeg4 -c:a copy /storage/emulated/0/Download/o.mp4";
      String animation2 = "-i /storage/emulated/0/Download/fair.mp4 -i /storage/emulated/0/Download/fair.mp4 -filter_complex \"[0:v]zoompan=z='min(zoom+0.002,1.5)':d=125[v0];[1:v]zoompan=z='1.5-max(1.5/125*t,0.001)':d=125[s1];[v0][s1]overlay\" -c:v copy -c:a copy /storage/emulated/0/Download/o.mp4";
      String animation3 = "-y -i /storage/emulated/0/Download/fair.mp4 -i /storage/emulated/0/Download/fair.mp4 -filter_complex \"color=c=black:size=640x360[background]; [0:v]format=argb,rotate='min(0,3.75-t)*2*PI:ow=hypot(iw,ih):oh=ow:c=black@0',setpts=PTS-STARTPTS[0v]; [1:v]format=argb,rotate='max(0,0.25-t)*2*PI:ow=hypot(iw,ih):oh=ow:c=black@0',setpts=PTS-STARTPTS+3.75/TB[1v]; [background][0v]overlay= x='-W/2*cos(min(0,3.75-t)*2*PI)+H/2*sin(min(0,3.75-t)*2*PI)+W-w/2': y='-W/2*sin(min(0,3.75-t)*2*PI)-H/2*cos(min(0,3.75-t)*2*PI)+H-h/2': shortest=1[0vv]; [0vv][1v]overlay= x='-W/2*cos(max(0,4-t)*2*PI)+H/2*sin(max(0,4-t)*2*PI)+W-w/2': y='-W/2*sin(max(0,4-t)*2*PI)-H/2*cos(max(0,4-t)*2*PI)+H-h/2'[v] \" -map [v] /storage/emulated/0/Download/p.mp4";
     // String animation4 = "-y -i /storage/emulated/0/Download/fair.mp4 -i /storage/emulated/0/Download/fair.mp4 -filter_complex \"color=c=black:size=640x360[background]; [0:v]format=argb,rotate='min(0,3.75-t)*2*PI:ow=hypot(iw,ih):oh=ow:c=black@0',setpts=PTS-STARTPTS[0v]; [1:v]format=argb,rotate='max(0,0.25-t)*2*PI:ow=hypot(iw,ih):oh=ow:c=black@0',setpts=PTS-STARTPTS+3.75/TB[1v]; [background][0v]overlay= x='-W/2*cos(min(0,3.75-t)*2*PI)+H/2*sin(min(0,3.75-t)*2*PI)+W-w/2': y='-W/2*sin(min(0,3.75-t)*2*PI)-H/2*cos(min(0,3.75-t)*2*PI)+H-h/2': shortest=1[0vv]; [0vv][1v]overlay= x='-W/2*cos(max(0,4-t)*2*PI)+H/2*sin(max(0,4-t)*2*PI)+W-w/2': y='-W/2*sin(max(0,4-t)*2*PI)-H/2*cos(max(0,4-t)*2*PI)+H-h/2'[v] \" -map [v] /storage/emulated/0/Download/p.mp4";
      String animation4 = "-y -i /storage/emulated/0/Download/fair.mp4 -i /storage/emulated/0/Download/fair.mp4 -filter_complex \"[0:v]format=argb,rotate='max(0,T-2)*2*PI:ow=hypot(iw,ih):oh=ow:c=black@0',setpts=PTS-STARTPTS[0v]; [1:v]format=argb,rotate='min(0,2-T)*2*PI:ow=hypot(iw,ih):oh=ow:c=black@0',setpts=PTS-STARTPTS+2/TB[1v]; [0v][1v]concat=n=2:v=1:a=0,spin=t=in:st=0:d=2:spin=2:0.5*PI,spin=t=out:st=4:d=2:spin=2:0.5*PI[s]; color=c=black:size=640x360[background]; [background][s]overlay=x=(W-w)/2:y=(H-h)/2[v] \" -map [v] /storage/emulated/0/Download/o.mp4";
     // String animation5 = "-i /storage/emulated/0/Download/fair.mp4 -i /storage/emulated/0/Download/fair.mp4 -filter_complex xfade=transition=circleopen:duration=5:offset=0 /storage/emulated/0/Download/o.mp4";
     // String animation6 = '-i /storage/emulated/0/Download/fair.mp4 -i /storage/emulated/0/Download/fair.mp4 -filter_complex "[0:v]xfade=transition=wipeleft:duration=2:offset=0[video1]; [1:v]xfade=transition=wiperight:duration=2:offset=0[video2]; [video1][video2]concat=n=2:v=1:a=0,format=yuv420p[v]" -map "[v]" -c:v libvpx-vp9 -crf 23 -preset veryfast /storage/emulated/0/Download/p.mp4';
     // String animation5 = '-i /storage/emulated/0/Download/fair.mp4 -i /storage/emulated/0/Download/fair.mp4 -filter_complex "[0:v]scale=1280x720,fps=30,format=yuv420p,settb=1/1000[clip1]; [1:v]scale=1280x720,fps=30,format=yuv420p,settb=1/1000[clip2]; [clip1]xfade=transition=wipeleft:duration=2:offset=0[video1]; [clip2]xfade=transition=wiperight:duration=2:offset=0[video2]; [video1][video2]concat=n=2:v=1:a=0,format=yuv420p[v]" -map "[v]" -c:v libvpx-vp9 -crf 23 -preset veryfast /storage/emulated/0/Download/fair.mp4';
    //  String animation5 = "-i /storage/emulated/0/Download/fair.mp4 -i /storage/emulated/0/Download/fair.mp4 -filter_complex xfade=transition=radial:duration=5:offset=0 /storage/emulated/0/Download/o.mp4";
      String animation5 = "-i /storage/emulated/0/Download/fair.mp4 -i /storage/emulated/0/Download/fair.mp4 -filter_complex \"[0:v]settb=AVTB,fps=30/1[v0];[1:v]settb=AVTB,fps=30/1[v1];[v0][v1]xfade=transition=hlslice:duration=1:offset=11,format=yuv420p\" -c:v libvpx-vp9 -y /storage/emulated/0/Download/o.mp4";
      String animation6 = '-i /storage/emulated/0/Download/fair.mp4 -i /storage/emulated/0/Download/fair.mp4 -i /storage/emulated/0/Download/fair.mp4 -i /storage/emulated/0/Download/fair.mp4 -filter_complex "[0:v]settb=AVTB,fps=30/1[v0];[1:v]settb=AVTB,fps=30/1[v1];[2:v]settb=AVTB,fps=30/1[v2];[3:v]settb=AVTB,fps=30/1[v3];[v0][v1]xfade=transition=hlslice:duration=1:offset=11,format=yuv420p[f01];[f01][v2]xfade=transition=hlslice:duration=1:offset=22,format=yuv420p[f02];[f02][v3]xfade=transition=hlslice:duration=1:offset=33,format=yuv420p[f03]" -map "[f03]"  -c:v libvpx-vp9 -y /storage/emulated/0/Download/o.mp4';







      FFmpegKit.execute(animation6).then((session) async {
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
