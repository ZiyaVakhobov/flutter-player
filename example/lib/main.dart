import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:udevs_video_player/udevs_video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _url =
      'https://bl.uma.media/route/3d905b2773e54aa484818843bed55b12.m3u8?guids=45f02b41-5662-4bf7-b62b-b6b929b46c35_1440x1072_4691968_avc1.640028_mp4a.40.2,3b727e61-74a1-4156-8141-eeff69d57afc_960x720_3128000_avc1.64001f_mp4a.40.2,18c54b08-3c6a-41ef-9456-4c7a30ebf2d6_640x480_1627968_avc1.4d401e_mp4a.40.2,5adfac23-259d-4c05-a47d-64568f07dbe5_480x360_1363968_avc1.42c015_mp4a.40.2&sign=b10ENCm5XVbWlCJz4YdGPA&expire=1662550309';
  final _udevsVideoPlayerPlugin = UdevsVideoPlayer();

  playVideo() async {
    try {
      await _udevsVideoPlayerPlugin.playVideo(_url);
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: playVideo,
            child: const Text('Play'),
          ),
        ),
      ),
    );
  }
}
