import 'dart:io';

import 'package:ffmpeg_understanding/screen/video_processing_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../common/audio_cutter.dart';

class AudioTrimmerScreen extends StatefulWidget {
  const AudioTrimmerScreen(
      {Key? key, required this.videosPath, required this.videosText})
      : super(key: key);

  final List<String> videosPath;
  final List<String> videosText;

  @override
  State<AudioTrimmerScreen> createState() => _AudioTrimmerScreenState();
}

class _AudioTrimmerScreenState extends State<AudioTrimmerScreen> {
  String outputPath = '';
  String inputFileView = 'Input File Path';
  File inputFile = File('');
  File outputFile = File('');
  RangeValues cutValues = const RangeValues(0, 5);
  int timeFile = 10;
  final player = AudioPlayer();
  final outputPlayer = AudioPlayer();
  bool previewPlay = false;
  bool outputPlay = false;
  bool isCutting = false;
  bool isCut = false;
  bool isTrimmed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Trimmer'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'INPUT',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  // const SizedBox(
                  //   height: 4,
                  // ),
                  // Text(
                  //   inputFileView,
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: _onPickFile,
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(128, 32))),
                    child: const Text('Pick audio file'),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 32,
                  ),
                  Text('Trimmer', style: Theme.of(context).textTheme.headline6),
                  RangeSlider(
                      values: cutValues,
                      max: timeFile.toDouble(),
                      divisions: timeFile,
                      labels: RangeLabels(
                          _getViewTimeFromCut(cutValues.start.toInt()).toString(),
                          _getViewTimeFromCut(cutValues.end.toInt()).toString()),
                      onChanged: (values) {
                        setState(() => cutValues = values);
                        player.seek(Duration(seconds: cutValues.start.toInt()));
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                          'Start: ${_getViewTimeFromCut(cutValues.start.toInt())}'),
                      Text('End: ${_getViewTimeFromCut(cutValues.end.toInt())}'),
                    ],
                  ),
                  IconButton(
                      onPressed: _onPlayPreview,
                      icon:
                          Icon(previewPlay ? Icons.stop_circle : Icons.play_arrow)),
                  const SizedBox(
                    height: 24,
                  ),
                  Text('Total time after trim: ${getTotalTimeAfterTrim()}'),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    onPressed: _onCut,
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(128, 32))),
                    child: const Text('Trim'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 16,
                  ),
                  Text('OUTPUT', style: Theme.of(context).textTheme.headline6),
                  const SizedBox(
                    height: 4,
                  ),
                  isCutting
                      ? Column(
                          children: const [
                            CircularProgressIndicator(),
                            Text('Waiting...')
                          ],
                        )
                      : Column(
                          children: [
                            Text(isCut ? 'Done!' : ''),
                            const SizedBox(
                              height: 4,
                            ),
                            // Text(
                            //   isCut ? outputFile.path : 'Output file path',
                            //   textAlign: TextAlign.center,
                            // ),
                            // const SizedBox(
                            //   height: 4,
                            // ),
                            Text(
                                'Time: ${outputPlayer.duration?.inMinutes ?? 0}:${outputPlayer.duration?.inSeconds ?? 0}'),
                            const SizedBox(
                              height: 4,
                            ),
                            IconButton(
                                onPressed: _onOutputPlayPreview,
                                icon: Icon(outputPlay
                                    ? Icons.stop_circle
                                    : Icons.play_arrow)),
                          ],
                        ),

                ],
              ),
            ),
          ),
          if(isTrimmed)
          ElevatedButton(
            onPressed:
                 ()  {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> VideoProcessingScreen(videoPaths: widget.videosPath,videoText: widget.videosText,audioPath: outputPath,)));
            },
            child: const Text("Process Video"),
          ),
        ],
      ),
    );
  }

  Future<void> _onPickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );
    if (result != null) {
      inputFile = File(result.files.single.path!);
      await player.setFilePath(inputFile.path);
      setState(() {
        timeFile = player.duration!.inSeconds;
        cutValues = RangeValues(0, timeFile.toDouble());
        inputFileView = inputFile.path;
        print('end value ${cutValues.end}');
      });
    }
  }

  _getViewTimeFromCut(int index) {
    int minute = index ~/ 60;
    int second = index - minute * 60;
    return "$minute:$second";
  }

  void _onPlayPreview() {
    if (inputFile.path != '') {
      setState(() => previewPlay = !previewPlay);
      if (player.playing) {
        player.stop();
      } else {
        player.seek(Duration(seconds: cutValues.start.toInt()));
        player.play();
      }
    }
  }

  Future<void> _onCut() async {
    if (cutValues.end - cutValues.start < 41.0 &&
        cutValues.end - cutValues.start > 35.0) {
      if (inputFile.path != '') {
        setState(() => isCutting = true);
        var result = await AudioCutter.cutAudio(
            inputFile.path, cutValues.start, cutValues.end);
        print("result $result");
        outputPath = result;
        outputFile = File(result);
        print(outputPath);
        await outputPlayer.setFilePath(result);
        setState(() {
          isCut = true;
          isCutting = false;
          isTrimmed = true;
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text(
                'Warning',
                style: TextStyle(color: Colors.redAccent),
              ),
              content: Text('Audio length should be 40 seconds'),
            );
          });
    }
  }

  void _onOutputPlayPreview() {
    if (outputFile.path != '') {
      setState(() => outputPlay = !outputPlay);
      if (outputPlayer.playing) {
        print("stop");
        outputPlayer.stop();
      } else {
        print("play");
        outputPlayer.play();
      }
    }
  }

  String getTotalTimeAfterTrim() {
    final start = _getViewTimeFromCut(cutValues.start.toInt());
    final end = _getViewTimeFromCut(cutValues.end.toInt());

    int seconds1 =
        int.parse(start.split(':')[0]) * 60 + int.parse(start.split(':')[1]);
    int seconds2 =
        int.parse(end.split(':')[0]) * 60 + int.parse(end.split(':')[1]);

    // Get the difference between the two time values in seconds
    int differenceInSeconds = seconds2 - seconds1;

    // Calculate the number of minutes and remaining seconds
    int minutes = differenceInSeconds ~/ 60;
    int remainingSeconds = differenceInSeconds % 60;

    // Format the result as a string
    String result = "$minutes:${remainingSeconds.toString().padLeft(2, '0')}";

    // Print the result
    print("The result is $result.");

    return result;
  }
}
