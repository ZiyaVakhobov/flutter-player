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
  final _url ='https://st1.uzdigital.tv/Discovery_Channel/video.m3u8?token=aeed03b389781a03231bc4b20cf97007c0ef7404-5150454f666e76614a74566f49486245-1661951863-1661941063&remote=89.236.205.221';
      // 'https://cdn.uzd.udevs.io/uzdigital/videos/9fd7dce75a9e80f8da032930ea0032cb/master.m3u8';
  final _udevsVideoPlayerPlugin = UdevsVideoPlayer();

  playVideo() async {
    try {
      await _udevsVideoPlayerPlugin.playVideo(_url, 100000, 'Shan-Chi', false, 'Episodes', 'Next', true, 'TV Programs');
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
