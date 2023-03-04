import 'package:ffmpeg_understanding/merge_multimedia/providers/merge_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../common/color_palette.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Learning'),
          centerTitle: true,
          backgroundColor: Palette.primary,
        ),
        body: Consumer<MergeProvider>(
          builder: (context, prov, _) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prov.loading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(color: Palette.primary),
                            SizedBox(width: 15),
                            Text('Processing...',
                                style: TextStyle(color: Colors.black))
                          ],
                        )
                      : Container(),
                  SizedBox(height: 15),
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        await prov.mergeIntoVideo();
                        // await prov.concatenateVideos([
                        //   '/storage/emulated/0/Download/v1.mp4',
                        //   '/storage/emulated/0/Download/v3.mp4'
                        // ], '/storage/emulated/0/Download/o11.mp4');
                        // if (!prov.loading) _showAlertDialog(context, prov);
                      },
                      child: Text('Merge',
                          style: TextStyle(color: Palette.tertiary)),
                      color: Palette.primary,
                      splashColor: Palette.secondary,
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: SfSlider(
                      min: 5,
                      max: 15,
                      stepSize: 5,
                      activeColor: Palette.primary,
                      inactiveColor: Palette.secondary,
                      value: prov.limit,
                      interval: 5,
                      showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      minorTicksPerInterval: 1,
                      onChanged: (dynamic value) {
                        prov.setTimeLimit(value);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
