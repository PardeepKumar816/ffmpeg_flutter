import 'dart:io';

import 'package:ffmpeg_understanding/screen/audio_trimmer_screen.dart';
import 'package:ffmpeg_understanding/screen/video_trim_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({Key? key}) : super(key: key);

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  late List<String> videosText;
  late List<String> videosPath;
  // late List<TextEditingController> controllers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videosText = List.generate(32, (index) => 'Hello');
    videosPath = List.generate(32, (index) => '/storage/emulated/0/Download/v3.mp4');
    //  controllers = List.generate(32, (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Videos, Text & Audio'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: 32,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextField(
                          //  controller: controllers[index],
                          decoration: InputDecoration(
                              hintText: 'add text for video ${index + 1}'),
                          onChanged: (value) {
                            videosText[index] = value;
                          },
                          onSubmitted: (value) {
                            videosText[index] = value;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.video,
                              allowCompression: false,
                            );
                            if (result != null) {
                              File file = File(result.files.single.path!);

                              // final path = await Navigator.of(context).push(
                              //   MaterialPageRoute(builder: (context) {
                              //     return TrimmerView(file);
                              //   }),
                              // );

                              final path = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VideoTrimmerScreen(file)));
                              videosPath[index] = path[0];

                              videosPath = List.generate(32, (index) => path[0]);
                              // setState(() {
                              //   controllers[index].text = videosPath[index];
                              // });
                            }
                          },
                          child: Text('Add Video${index + 1}'),
                      ),
                      // InkWell(
                      //   onTap: () {},
                      //   child: Container(
                      //     width: 96,
                      //     height: 48,
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: Colors.grey.shade300,
                      //     ),
                      //     child: const Icon(Icons.add),
                      //   ),
                      // ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 18,
                  );
                },
              ),
            ),
            // if (videosPath.every((element) => element.isNotEmpty) &&
            //     videosText.every((element) => element.isNotEmpty))
            Container(
              width: MediaQuery.of(context).size.width - 48,
              height: 56,
              padding: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
              child: ElevatedButton(
                onPressed: () {
                  print(videosText.length);
                  print(videosPath.length);
                  // videosPath[0] = '/storage/emulated/0/Download/v1.mp4';
                  // videosPath[8] = '/storage/emulated/0/Download/v1.mp4';
                  // videosPath[21] = '/storage/emulated/0/Download/v1.mp4';
                  // videosPath[21] = '/storage/emulated/0/Download/v1.mp4';
                  // videosPath[31] = '/storage/emulated/0/Download/v1.mp4';
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AudioTrimmerScreen(
                              videosPath: videosPath, videosText: videosText)));
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.pinkAccent),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))))),
                child: const Text('Add Audio'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
