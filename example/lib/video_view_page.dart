import 'package:flutter/material.dart';
import 'package:udevs_video_player/video_player_view.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Video Player View')),
        body: VideoPlayerView(onMapViewCreated: _onMapViewCreated),
      );

  // load default assets
  void _onMapViewCreated(VideoPlayerViewController controller) {
    controller.setAssets(
      assets: 'assets/splash.mp4',
      resizeMode: ResizeMode.fill,
    );
    // controller.setUrl(
    //   url:
    //       'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
    // );
  }
}

/// 71 205 84 84
