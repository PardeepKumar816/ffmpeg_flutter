import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'package:ffmpeg_kit_flutter_full/session.dart';

// import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class VideoProcessingScreen extends StatefulWidget {
  const VideoProcessingScreen(
      {Key? key, required this.videoPaths, required this.videoText})
      : super(key: key);
  final List<String> videoPaths;
  final List<String> videoText;

  @override
  State<VideoProcessingScreen> createState() => _VideoProcessingScreenState();
}

class _VideoProcessingScreenState extends State<VideoProcessingScreen> {
  List<String> videosWithText = [
    '/storage/emulated/0/Download/videoText1.mp4',
    '/storage/emulated/0/Download/videoText2.mp4',
    '/storage/emulated/0/Download/videoText3.mp4',
    '/storage/emulated/0/Download/videoText4.mp4',
    '/storage/emulated/0/Download/videoText5.mp4',
    '/storage/emulated/0/Download/videoText6.mp4',
    '/storage/emulated/0/Download/videoText7.mp4',
    '/storage/emulated/0/Download/videoText8.mp4',
    '/storage/emulated/0/Download/videoText9.mp4',
    '/storage/emulated/0/Download/videoText10.mp4',
    '/storage/emulated/0/Download/videoText11.mp4',
    '/storage/emulated/0/Download/videoText12.mp4',
    '/storage/emulated/0/Download/videoText13.mp4',
    '/storage/emulated/0/Download/videoText14.mp4',
    '/storage/emulated/0/Download/videoText15.mp4',
    '/storage/emulated/0/Download/videoText16.mp4',
    '/storage/emulated/0/Download/videoText17.mp4',
    '/storage/emulated/0/Download/videoText18.mp4',
    '/storage/emulated/0/Download/videoText19.mp4',
    '/storage/emulated/0/Download/videoText20.mp4',
    '/storage/emulated/0/Download/videoText21.mp4',
    '/storage/emulated/0/Download/videoText22.mp4',
    '/storage/emulated/0/Download/videoText23.mp4',
    '/storage/emulated/0/Download/videoText24.mp4',
    '/storage/emulated/0/Download/videoText25.mp4',
    '/storage/emulated/0/Download/videoText26.mp4',
    '/storage/emulated/0/Download/videoText27.mp4',
    '/storage/emulated/0/Download/videoText28.mp4',
    '/storage/emulated/0/Download/videoText29.mp4',
    '/storage/emulated/0/Download/videoText30.mp4',
    '/storage/emulated/0/Download/videoText31.mp4',
    '/storage/emulated/0/Download/videoText32.mp4',
  ];
  List<String> videosWithDoubleText = [
    '/storage/emulated/0/Download/videoDoubleText1.mp4',
    '/storage/emulated/0/Download/videoDoubleText2.mp4',
    '/storage/emulated/0/Download/videoDoubleText3.mp4',
    '/storage/emulated/0/Download/videoDoubleText4.mp4',
    '/storage/emulated/0/Download/videoDoubleText5.mp4',
    '/storage/emulated/0/Download/videoDoubleText6.mp4',
    '/storage/emulated/0/Download/videoDoubleText7.mp4',
    '/storage/emulated/0/Download/videoDoubleText8.mp4',
    '/storage/emulated/0/Download/videoDoubleText9.mp4',
    '/storage/emulated/0/Download/videoDoubleText10.mp4',
    '/storage/emulated/0/Download/videoDoubleText11.mp4',
    '/storage/emulated/0/Download/videoDoubleText12.mp4',
  ];
  List<String> vstackPath = [
    '/storage/emulated/0/Download/vstack1.mp4',
    '/storage/emulated/0/Download/vstack2.mp4',
    '/storage/emulated/0/Download/vstack3.mp4',
    '/storage/emulated/0/Download/vstack4.mp4',
    '/storage/emulated/0/Download/vstack5.mp4',
    '/storage/emulated/0/Download/vstack6.mp4',
    '/storage/emulated/0/Download/vstack7.mp4',
    '/storage/emulated/0/Download/vstack8.mp4',
    '/storage/emulated/0/Download/vstack9.mp4',
    '/storage/emulated/0/Download/vstack10.mp4',
    '/storage/emulated/0/Download/vstack11.mp4',
    '/storage/emulated/0/Download/vstack12.mp4',
  ];
  List<String> videoPaths = [
    '/storage/emulated/0/Download/v1.mp4',
    '/storage/emulated/0/Download/v2.mp4',
    '/storage/emulated/0/Download/v3.mp4',
    '/storage/emulated/0/Download/v4.mp4',
    '/storage/emulated/0/Download/v5.mp4',
    '/storage/emulated/0/Download/v6.mp4',
    '/storage/emulated/0/Download/v7.mp4',
    '/storage/emulated/0/Download/v8.mp4',
    '/storage/emulated/0/Download/v9.mp4',
    '/storage/emulated/0/Download/v10.mp4',
    '/storage/emulated/0/Download/v11.mp4',
    '/storage/emulated/0/Download/v12.mp4',
    '/storage/emulated/0/Download/v13.mp4',
    '/storage/emulated/0/Download/v14.mp4',
    '/storage/emulated/0/Download/v15.mp4',
    '/storage/emulated/0/Download/v16.mp4',
    '/storage/emulated/0/Download/v17.mp4',
    '/storage/emulated/0/Download/v18.mp4',
    '/storage/emulated/0/Download/v19.mp4',
    '/storage/emulated/0/Download/v20.mp4',
    '/storage/emulated/0/Download/v21.mp4',
    '/storage/emulated/0/Download/v22.mp4',
    '/storage/emulated/0/Download/v23.mp4',
    '/storage/emulated/0/Download/v24.mp4',
    '/storage/emulated/0/Download/v25.mp4',
    '/storage/emulated/0/Download/v26.mp4',
    '/storage/emulated/0/Download/v27.mp4',
    '/storage/emulated/0/Download/v28.mp4',
    '/storage/emulated/0/Download/v29.mp4',
    '/storage/emulated/0/Download/v30.mp4',
    '/storage/emulated/0/Download/v31.mp4',
    '/storage/emulated/0/Download/v32.mp4',
  ];
  List<String> daysText = [
    'day 1',
    'day 2',
    'day 3',
    'day 4',
    'day 4',
    'day 5',
    'day 6',
    'day 7',
    'day 9',
    'day 9',
    'day 10',
    'day 11',
  ];
  List<String> sameFormatVideosPath = [
    '/storage/emulated/0/Download/sameFormatVideo1.mp4',
    '/storage/emulated/0/Download/sameFormatVideo2.mp4',
    '/storage/emulated/0/Download/sameFormatVideo3.mp4',
    '/storage/emulated/0/Download/sameFormatVideo4.mp4',
    '/storage/emulated/0/Download/sameFormatVideo5.mp4',
    '/storage/emulated/0/Download/sameFormatVideo6.mp4',
    '/storage/emulated/0/Download/sameFormatVideo7.mp4',
    '/storage/emulated/0/Download/sameFormatVideo8.mp4',
    '/storage/emulated/0/Download/sameFormatVideo9.mp4',
    '/storage/emulated/0/Download/sameFormatVideo10.mp4',
    '/storage/emulated/0/Download/sameFormatVideo11.mp4',
    '/storage/emulated/0/Download/sameFormatVideo12.mp4',
  ];
  List<String> sameFormatVideosSinglePath = [
    '/storage/emulated/0/Download/same0.mp4',
    '/storage/emulated/0/Download/same3.mp4',
    '/storage/emulated/0/Download/same8.mp4',
    '/storage/emulated/0/Download/same9.mp4',
    '/storage/emulated/0/Download/same12.mp4',
  ];
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Process Video'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isProcessing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                        SizedBox(width: 15),
                        Text('Processing...',
                            style: TextStyle(color: Colors.black))
                      ],
                    )
                  : Container(),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  await addingTextToVideos();
                  print('ehllo');
                    await verticallyStackingVideos();
                  print('ok');




                  Timer(const Duration(seconds: 20), () async {
                    await addDoubleTextToVideos();
                  });



                 print('print');

                  Timer(const Duration(minutes: 1), () async {
                    await makingVideosOfSameResolution();
                  });

                  Timer(const Duration(minutes: 1,seconds: 30), () async {
                    await makingVideosOfSameResolution2();
                  });

                  Timer(const Duration(minutes: 2,seconds: 30), () async {
                    await mergingVideos();
                  });

                  Timer(const Duration(minutes: 2,seconds: 60), () async {
                    await _deleteVideo(videosWithText);
                    await _deleteVideo(vstackPath);
                    await _deleteVideo(videosWithDoubleText);
                    await _deleteVideo(sameFormatVideosPath);
                    await _deleteVideo(sameFormatVideosSinglePath);

                  });



                  print('hmmm');
               //   await mergingVideos();
                  //  Navigatawaior.pushReplacement(context, MaterialPageRoute(builder: (context)=> VideoProcessingScreen()));
                },
                child: const Text("Process Video"),
              ),
            ],
          ),
        ));
  }

  Future<void> addingTextToVideos() async {
    final fontFile = await rootBundle.load("assets/Raleway-Regular.ttf");
    final fontFilePath =
        "${(await getTemporaryDirectory()).path}/Raleway-Regular.ttf";
    File fontFileTmp = File(fontFilePath);
    await fontFileTmp.writeAsBytes(fontFile.buffer
        .asUint8List(fontFile.offsetInBytes, fontFile.lengthInBytes));

    String textVideoOutputPath = '/storage/emulated/0/Download/o2.mp4';
    String textVideoInputPath = '';
    String inputText = '';
    String dayInputText = '';
    String xAxis = '';
    String yAxis = '';
    String newCommand = '';

    for (int j = 0; j < videoPaths.length; j++) {
      if (videoPaths.indexOf(videoPaths[j]) == 0) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        dayInputText = '12 days';
        xAxis = '30';
        yAxis = '100';

        newCommand = '-i $textVideoInputPath '
            '-vf "drawtext=text=\'$dayInputText\':fontfile=$fontFilePath:fontcolor=black:fontsize=65:box=1:boxcolor=white:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2,'
            'drawtext=text=\'$inputText\':fontfile=$fontFilePath:fontcolor=black:fontsize=50:box=1:boxcolor=white:boxborderw=5:x=$xAxis:y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 1) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        xAxis = '(w-text_w)/2';
        yAxis = '60';

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 2) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '350';
        yAxis = '60';

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 3) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '60';
        yAxis = '200';

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 4) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '60';
        yAxis = '30';

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 5) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 6) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '60';
        yAxis = '30';

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 7) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '60';
        yAxis = '30';

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 8) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        dayInputText = 'Day 3';
        xAxis = '60';
        yAxis = '30';
        newCommand = '-i $textVideoInputPath '
            '-vf "drawtext=text=\'$dayInputText\':fontfile=$fontFilePath:fontcolor=black:fontsize=65:box=1:boxcolor=white:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2,'
            'drawtext=text=\'$inputText\':fontfile=$fontFilePath:fontcolor=black:fontsize=50:box=1:boxcolor=white:boxborderw=5:x=$xAxis:y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 9) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '50';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 10) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '30';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 11) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '150';
        yAxis = '20';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 12) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 13) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 14) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 15) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 16) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 17) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 18) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 19) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 20) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 21) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        dayInputText = 'day 8';
        xAxis = '60';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf "drawtext=text=\'$dayInputText\':fontfile=$fontFilePath:fontcolor=black:fontsize=65:box=1:boxcolor=white:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2,'
            'drawtext=text=\'$inputText\':fontfile=$fontFilePath:fontcolor=black:fontsize=50:box=1:boxcolor=white:boxborderw=5:x=$xAxis:y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 22) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        dayInputText = 'day 9';
        xAxis = '60';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf "drawtext=text=\'$dayInputText\':fontfile=$fontFilePath:fontcolor=black:fontsize=65:box=1:boxcolor=white:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2,'
            'drawtext=text=\'$inputText\':fontfile=$fontFilePath:fontcolor=black:fontsize=50:box=1:boxcolor=white:boxborderw=5:x=$xAxis:y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 23) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 24) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 25) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 26) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 27) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 28) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 29) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 30) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        // dayInputText = '12 days';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5: x=$xAxis: y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      } else if (videoPaths.indexOf(videoPaths[j]) == 31) {
        textVideoOutputPath = videosWithText[j];
        textVideoInputPath = videoPaths[j];
        inputText = widget.videoText[j];
        dayInputText = 'day 12';
        xAxis = '300';
        yAxis = '60';
        newCommand = '-i $textVideoInputPath '
            '-vf "drawtext=text=\'$dayInputText\':fontfile=$fontFilePath:fontcolor=black:fontsize=65:box=1:boxcolor=white:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2,'
            'drawtext=text=\'$inputText\':fontfile=$fontFilePath:fontcolor=black:fontsize=50:box=1:boxcolor=white:boxborderw=5:x=$xAxis:y=$yAxis" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        //  await ffmpegCommand(newCommand);
        //     final session = FFmpegKit.executeAsync(newCommand, (session) {
        //       handleCompletion(session);
        //     });
        // await FFmpegKit.executeWithArgumentsAsync(
        //   FFmpegKitConfig.parseArguments(newCommand),
        //       (session) => print('1'),
        //       (log) => print(''),
        //       (statistics) => print(""),
        // );
        await ffmpegExecute(newCommand);
      }
    }

    //  return completer.future;

//////////////////////////////////////////////////////////////////////////////////////////////////
  }

  Future<void> verticallyStackingVideos() async {
    String vstackInputPath1 = '';
    String vstackInputPath2 = '';
    String vstackInputPath3 = '';
    String vstackOutputPath = '';
    String newCommand = '';
    int counter = 0;

    String vStackCommand1 =
        '-i $vstackInputPath1 -i $vstackInputPath2 -filter_complex vstack=inputs=2 $vstackOutputPath';
    String vStackCommand2 =
        '-i $vstackInputPath1 -i $vstackInputPath2 -i $vstackInputPath3 -filter_complex vstack=inputs=3 $vstackOutputPath';

    for (int i = 0; i < vstackPath.length; i++) {
      print('break');
      counter++;
      for (int j = 0; j < videosWithText.length; j++) {
        if (j == 1 && counter == 1) {
          vstackInputPath1 = videosWithText[1];
          vstackInputPath2 = videosWithText[2];
          vstackInputPath3 = videosWithText[3];
          print('i $i j $j');
          vstackOutputPath = vstackPath[i];
          newCommand =
              '-i $vstackInputPath1 -i $vstackInputPath2 -i $vstackInputPath3 -filter_complex vstack=inputs=3 $vstackOutputPath';
          await ffmpegExecute(newCommand);
          // print('completed $i');
          break;
        } else if (j == 4 && counter == 2) {
          vstackInputPath1 = videosWithText[4];
          vstackInputPath2 = videosWithText[5];
          vstackOutputPath = vstackPath[i];
          print('i $i j $j');
          newCommand =
              '-i $vstackInputPath1 -i $vstackInputPath2 -filter_complex vstack=inputs=2 $vstackOutputPath';
          await ffmpegExecute(newCommand);
          break;
        } else if (j == 6 && counter == 3) {
          vstackInputPath1 = videosWithText[6];
          vstackInputPath2 = videosWithText[7];
          vstackOutputPath = vstackPath[i];
          print('i $i j $j');
          newCommand =
              '-i $vstackInputPath1 -i $vstackInputPath2 -filter_complex vstack=inputs=2 $vstackOutputPath';
          await ffmpegExecute(newCommand);
          break;
        } else if (j == 9 && counter == 4) {
          vstackInputPath1 = videosWithText[9];
          vstackInputPath2 = videosWithText[10];
          vstackOutputPath = vstackPath[i];
          print('i $i j $j');
          newCommand =
              '-i $vstackInputPath1 -i $vstackInputPath2 -filter_complex vstack=inputs=2 $vstackOutputPath';
          await ffmpegExecute(newCommand);
          break;
        } else if (j == 11 && counter == 5) {
          vstackInputPath1 = videosWithText[11];
          vstackInputPath2 = videosWithText[12];
          vstackOutputPath = vstackPath[i];
          print('i $i j $j');
          newCommand =
              '-i $vstackInputPath1 -i $vstackInputPath2 -filter_complex vstack=inputs=2 $vstackOutputPath';
          await ffmpegExecute(newCommand);
          break;
        } else if (j == 13 && counter == 6) {
          vstackInputPath1 = videosWithText[13];
          vstackInputPath2 = videosWithText[14];
          vstackInputPath3 = videosWithText[15];
          vstackOutputPath = vstackPath[i];
          print('i $i j $j');
          newCommand =
              '-i $vstackInputPath1 -i $vstackInputPath2 -i $vstackInputPath3 -filter_complex vstack=inputs=3 $vstackOutputPath';
          await ffmpegExecute(newCommand);
          break;
        } else if (j == 16 && counter == 7) {
          vstackInputPath1 = videosWithText[16];
          vstackInputPath2 = videosWithText[17];
          vstackInputPath3 = videosWithText[18];
          vstackOutputPath = vstackPath[i];
          print('i $i j $j');
          newCommand =
              '-i $vstackInputPath1 -i $vstackInputPath2 -i $vstackInputPath3 -filter_complex vstack=inputs=3 $vstackOutputPath';
          await ffmpegExecute(newCommand);
          break;
        } else if (j == 19 && counter == 8) {
          vstackInputPath1 = videosWithText[19];
          vstackInputPath2 = videosWithText[20];
          vstackOutputPath = vstackPath[i];
          print('i $i j $j');
          newCommand =
              '-i $vstackInputPath1 -i $vstackInputPath2 -filter_complex vstack=inputs=2 $vstackOutputPath';
          await ffmpegExecute(newCommand);
          break;
        } else if (j == 23 && counter == 9) {
          vstackInputPath1 = videosWithText[23];
          vstackInputPath2 = videosWithText[24];
          vstackOutputPath = vstackPath[i];
          print('i $i j $j');
          newCommand =
              '-i $vstackInputPath1 -i $vstackInputPath2 -filter_complex vstack=inputs=2 $vstackOutputPath';
          await ffmpegExecute(newCommand);
          break;
        } else if (j == 25 && counter == 10) {
          vstackInputPath1 = videosWithText[25];
          vstackInputPath2 = videosWithText[26];
          vstackOutputPath = vstackPath[i];
          print('i $i j $j');
          newCommand =
              '-i $vstackInputPath1 -i $vstackInputPath2 -filter_complex vstack=inputs=2 $vstackOutputPath';
          await ffmpegExecute(newCommand);
          break;
        } else if (j == 27 && counter == 11) {
          vstackInputPath1 = videosWithText[27];
          vstackInputPath2 = videosWithText[28];
          vstackOutputPath = vstackPath[i];
          print('i $i j $j');
          newCommand =
              '-i $vstackInputPath1 -i $vstackInputPath2 -filter_complex vstack=inputs=2 $vstackOutputPath';
          await ffmpegExecute(newCommand);
          break;
        } else if (j == 29 && counter == 12) {
          vstackInputPath1 = videosWithText[29];
          vstackInputPath2 = videosWithText[30];
          vstackOutputPath = vstackPath[i];
          print('i $i j $j');
          newCommand =
              '-i $vstackInputPath1 -i $vstackInputPath2 -filter_complex vstack=inputs=2 $vstackOutputPath';
          await ffmpegExecute(newCommand);
          break;
        }
      }
    }
//////////////////////////////////////////////////////////////////////////////////////////////////
  }

  Future<void> _deleteVideo(List paths) async {
    File? _videoFile;

    for (int i = 0; i < paths.length; i++) {
      _videoFile = File(paths[i]);
      if (_videoFile == null) {
        // Video file is not selected
        print('null');
        return;
      }
      try {
        // Delete the video file
        await _videoFile.delete();
        // Show a success message
        print('deleted');
      } catch (e) {
        // Show an error message if deleting the file fails
        print(e);
      }
    }
  }

  Future<void> addDoubleTextToVideos() async {
    final fontFile = await rootBundle.load("assets/Raleway-Regular.ttf");
    final fontFilePath =
        "${(await getTemporaryDirectory()).path}/Raleway-Regular.ttf";
    File fontFileTmp = File(fontFilePath);
    await fontFileTmp.writeAsBytes(fontFile.buffer
        .asUint8List(fontFile.offsetInBytes, fontFile.lengthInBytes));

    String textVideoOutputPath = '';
    String textVideoInputPath = '';
    String inputText = '';
    String newCommand = '';

    for (int j = 0; j < vstackPath.length; j++) {
      if (vstackPath.indexOf(vstackPath[j]) == 0) {
        textVideoOutputPath = videosWithDoubleText[j];
        textVideoInputPath = vstackPath[j];
        inputText = daysText[j];

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (vstackPath.indexOf(vstackPath[j]) == 1) {
        textVideoOutputPath = videosWithDoubleText[j];
        textVideoInputPath = vstackPath[j];
        inputText = daysText[j];

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (vstackPath.indexOf(vstackPath[j]) == 2) {
        textVideoOutputPath = videosWithDoubleText[j];
        textVideoInputPath = vstackPath[j];
        inputText = daysText[j];

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (vstackPath.indexOf(vstackPath[j]) == 3) {
        textVideoOutputPath = videosWithDoubleText[j];
        textVideoInputPath = vstackPath[j];
        inputText = daysText[j];

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (vstackPath.indexOf(vstackPath[j]) == 4) {
        textVideoOutputPath = videosWithDoubleText[j];
        textVideoInputPath = vstackPath[j];
        inputText = daysText[j];

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (vstackPath.indexOf(vstackPath[j]) == 5) {
        textVideoOutputPath = videosWithDoubleText[j];
        textVideoInputPath = vstackPath[j];
        inputText = daysText[j];

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (vstackPath.indexOf(vstackPath[j]) == 6) {
        textVideoOutputPath = videosWithDoubleText[j];
        textVideoInputPath = vstackPath[j];
        inputText = daysText[j];

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (vstackPath.indexOf(vstackPath[j]) == 7) {
        textVideoOutputPath = videosWithDoubleText[j];
        textVideoInputPath = vstackPath[j];
        inputText = daysText[j];

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (vstackPath.indexOf(vstackPath[j]) == 8) {
        textVideoOutputPath = videosWithDoubleText[j];
        textVideoInputPath = vstackPath[j];
        inputText = daysText[j];

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (vstackPath.indexOf(vstackPath[j]) == 9) {
        textVideoOutputPath = videosWithDoubleText[j];
        textVideoInputPath = vstackPath[j];
        inputText = daysText[j];

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (vstackPath.indexOf(vstackPath[j]) == 10) {
        textVideoOutputPath = videosWithDoubleText[j];
        textVideoInputPath = vstackPath[j];
        inputText = daysText[j];

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      } else if (vstackPath.indexOf(vstackPath[j]) == 11) {
        textVideoOutputPath = videosWithDoubleText[j];
        textVideoInputPath = vstackPath[j];
        inputText = daysText[j];

        newCommand = '-i $textVideoInputPath '
            '-vf drawtext="text=\'$inputText\':fontfile=$fontFilePath: fontcolor=black: fontsize=50: box=1: boxcolor=white: boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" '
            '-c:v mpeg4 -c:a copy $textVideoOutputPath';

        await ffmpegExecute(newCommand);
      }
    }
  }

  Future<void> makingVideosOfSameResolution() async {
    String newCommand = '';
    String inputPath = '';
    String outputPath = '';

    for(int i=0; i<videosWithDoubleText.length; i++){
     inputPath = videosWithDoubleText[i];
     outputPath = sameFormatVideosPath[i];
     newCommand = '-i $inputPath -acodec libshine -b:a 128k -vcodec mpeg4 -b:v 4000k -maxrate 4000k -bufsize 8000k -s 480x600 -r 30 -aspect 53:80 -vf "setsar=1/1" -strict experimental $outputPath';
     await ffmpegExecute(newCommand);
    }
  }

  Future<void> makingVideosOfSameResolution2() async {
    String newCommand = '';
    String inputPath = '';
    String outputPath = '';

    for(int i=0; i<sameFormatVideosSinglePath.length; i++){
      if(sameFormatVideosSinglePath.indexOf(sameFormatVideosSinglePath[i]) == 0){
        inputPath = videosWithText[0];
        outputPath = sameFormatVideosSinglePath[i];
        newCommand = '-i $inputPath -acodec libshine -b:a 128k -vcodec mpeg4 -b:v 4000k -maxrate 4000k -bufsize 8000k -s 480x600 -r 30 -aspect 53:80 -vf "setsar=1/1" -strict experimental $outputPath';
        await ffmpegExecute(newCommand);
      }else if(sameFormatVideosSinglePath.indexOf(sameFormatVideosSinglePath[i]) == 1){
        inputPath = videosWithText[8];
        outputPath = sameFormatVideosSinglePath[i];
        newCommand = '-i $inputPath -acodec libshine -b:a 128k -vcodec mpeg4 -b:v 4000k -maxrate 4000k -bufsize 8000k -s 480x600 -r 30 -aspect 53:80 -vf "setsar=1/1" -strict experimental $outputPath';
        await ffmpegExecute(newCommand);
      }else if(sameFormatVideosSinglePath.indexOf(sameFormatVideosSinglePath[i]) == 2){
        inputPath = videosWithText[21];
        outputPath = sameFormatVideosSinglePath[i];
        newCommand = '-i $inputPath -acodec libshine -b:a 128k -vcodec mpeg4 -b:v 4000k -maxrate 4000k -bufsize 8000k -s 480x600 -r 30 -aspect 53:80 -vf "setsar=1/1" -strict experimental $outputPath';
        await ffmpegExecute(newCommand);
      }else if(sameFormatVideosSinglePath.indexOf(sameFormatVideosSinglePath[i]) == 3){
        inputPath = videosWithText[22];
        outputPath = sameFormatVideosSinglePath[i];
        newCommand = '-i $inputPath -acodec libshine -b:a 128k -vcodec mpeg4 -b:v 4000k -maxrate 4000k -bufsize 8000k -s 480x600 -r 30 -aspect 53:80 -vf "setsar=1/1" -strict experimental $outputPath';
        await ffmpegExecute(newCommand);
      }else if(sameFormatVideosSinglePath.indexOf(sameFormatVideosSinglePath[i]) == 4){
        inputPath = videosWithText[31];
        outputPath = sameFormatVideosSinglePath[i];
        newCommand = '-i $inputPath -acodec libshine -b:a 128k -vcodec mpeg4 -b:v 4000k -maxrate 4000k -bufsize 8000k -s 480x600 -r 30 -aspect 53:80 -vf "setsar=1/1" -strict experimental $outputPath';
        await ffmpegExecute(newCommand);
      }

    }
  }

  Future<void> mergingVideos() async {
    // String mergeVideoUseful =
    //     '-i /storage/emulated/0/Download/o15.mp4 -i /storage/emulated/0/Download/o17.mp4 -i /storage/emulated/0/Download/o18.mp4 \-filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0]concat=n=3:v=1:a=1[outv][outa]" \-map "[outv]" -map "[outa]" /storage/emulated/0/Download/o4.mp4';

    String command =
        '-i ${sameFormatVideosSinglePath[0]} '
        '-i ${sameFormatVideosPath[0]} '
        '-i ${sameFormatVideosPath[1]} '
        '-i ${sameFormatVideosPath[2]} '
        '-i ${sameFormatVideosSinglePath[1]} '
        '-i ${sameFormatVideosPath[3]} '
        '-i ${sameFormatVideosPath[4]} '
        '-i ${sameFormatVideosPath[5]} '
        '-i ${sameFormatVideosPath[6]} '
        '-i ${sameFormatVideosPath[7]} '
        '-i ${sameFormatVideosSinglePath[2]} '
        '-i ${sameFormatVideosSinglePath[3]} '
        '-i ${sameFormatVideosPath[8]} '
        '-i ${sameFormatVideosPath[9]} '
        '-i ${sameFormatVideosPath[10]} '
        '-i ${sameFormatVideosPath[11]} '
        '-i ${sameFormatVideosSinglePath[4]} '
        '-filter_complex '
        '"[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0]'
        '[4:v:0][4:a:0][5:v:0][5:a:0][6:v:0][6:a:0][7:v:0][7:a:0]'
        '[8:v:0][8:a:0][9:v:0][9:a:0][10:v:0][10:a:0][11:v:0][11:a:0]'
        '[12:v:0][12:a:0][13:v:0][13:a:0][14:v:0][14:a:0][15:v:0][15:a:0]'
        'concat=n=17:v=1:a=1[outv][outa]" '
        '-map "[outv]" '
        '-map "[outa]" '
        '/storage/emulated/0/Download/output.mp4';

    await ffmpegExecute(command);

  }

  Future<void> ffmpegExecute(String command) async {
    await FFmpegKit.executeWithArgumentsAsync(
      FFmpegKitConfig.parseArguments(command),
      (session) => session.getReturnCode().then((value) => print(value)),
      (log) => print(log.getMessage()),
      (statistics) => print(""),
    );
  }

// Future<void> ffmpegCommand(String command) async {
//   FFmpegKit.executeAsync(command).then((session) async {
//     final returnCode = await session.getReturnCode();
//
//     if (ReturnCode.isSuccess(returnCode)) {
//       print(returnCode!.getValue());
//       print('Success');
//       FFmpegKit.cancel(session.getSessionId());
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
//     // await session.getFailStackTrace().then((value) => print(value));
//     // //  await session.getOutput().then((value) => print(value));
//     // // await session
//     // //     .getAllLogs()
//     // //     .then((value) => print(value.map((e) => print(e.getMessage()))));
//     //
//     // await session
//     //     .getLogs()
//     //     .then((value) => print(value.map((e) => print(e.getMessage()))));
//   });
// }
}
