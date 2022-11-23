import 'dart:io';

import 'package:flutter/foundation.dart';
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
  final _udevsVideoPlayerPlugin = UdevsVideoPlayer();
  int _progress = 0;

  download() async {
    try {
      var s = await _udevsVideoPlayerPlugin.downloadVideo(
              downloadConfig: DownloadConfiguration(
            url:
                'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
          )) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  pauseDownload() async {
    try {
      var s = await _udevsVideoPlayerPlugin.pauseDownload(
              downloadConfig: DownloadConfiguration(
            url:
                'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
          )) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  resumeDownload() async {
    try {
      var s = await _udevsVideoPlayerPlugin.resumeDownload(
              downloadConfig: DownloadConfiguration(
            url:
                'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
          )) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  Future<bool> checkIsDownloaded() async {
    bool isDownloaded = false;
    try {
      isDownloaded = await _udevsVideoPlayerPlugin.isDownloadVideo(
          downloadConfig: DownloadConfiguration(
        url:
            'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
      ));
      if (kDebugMode) {
        print('result: $isDownloaded');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
    return isDownloaded;
  }

  getCurrentProgressDownload() async {
    int progress = 0;
    try {
      progress = await _udevsVideoPlayerPlugin.getCurrentProgressDownload(
              downloadConfig: DownloadConfiguration(
            url:
                'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
          )) ??
          0;
      if (kDebugMode) {
        print('result: $progress');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
    setState(() {
      _progress = progress;
    });
  }

  Stream<int?> getCurrentProgressDownloadAsStream() {
    return _udevsVideoPlayerPlugin.getCurrentProgressDownloadAsStream(
        downloadConfig: DownloadConfiguration(
      url:
          'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
    ));
  }

  Stream<int> currentProgressDownloadAsStream() =>
      _udevsVideoPlayerPlugin.currentProgressDownloadAsStream;

  playVideo() async {
    try {
      var s = await _udevsVideoPlayerPlugin.playVideo(
              playerConfig: PlayerConfiguration(
            baseUrl: "https://api.spec.uzd.udevs.io/v1/",
            initialResolution: {
              "Автонастройка":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/master.m3u8"
            },
            resolutions: {
              "Автонастройка":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/master.m3u8",
              "1080p":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/1080p/index.m3u8",
              "720p":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/720p/index.m3u8",
              "480p":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/480p/index.m3u8",
              "360p":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/360p/index.m3u8",
              "240p":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8"
            },
            qualityText: 'Качество',
            speedText: 'Скорость',
            lastPosition: 0,
            title: "S1 E1  \"Женщина-Халк: Адвокат\" ",
            isSerial: false,
            episodeButtonText: 'Эпизоды',
            nextButtonText: 'След.эпизод',
            seasons: [],
            isLive: false,
            tvProgramsText: 'Телеканалы',
            programsInfoList: [],
            showController: true,
            playVideoFromAsset: false,
            assetPath: '',
            seasonIndex: 0,
            episodeIndex: 0,
            isMegogo: false,
            isPremier: false,
            videoId: '5178',
            sessionId: '633fad58c2c2e7a4241ab508',
            megogoAccessToken:
                'MToxMTYyNDQ1NDA2OjE2NjUxMTc1NTY6OjY3ZTI2MzVkYzY0Mzk2N2UwMjZhOGVjNWQ5MDA3OGFm',
            authorization:
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NTg1MDEzNDMsImlzcyI6InVzZXIiLCJwaWQiOjEzMDcsInJvbGUiOiJjdXN0b21lciIsInN1YiI6IjYyMDQzMmZmLTc3ZWItNDc0Mi05MmFhLTZmOGU4NDcyMDI0ZCJ9.6SvUCBT0gb6tIRy1PL-C7WS7xHpJXc1PCZky6aH6HtA',
            autoText: 'Автонастройка',
          )) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: playVideo,
                child: const Text('Play Video'),
              ),
              ElevatedButton(
                onPressed: download,
                child: const Text('Download'),
              ),
              ElevatedButton(
                onPressed: pauseDownload,
                child: const Text('Pause Download'),
              ),
              ElevatedButton(
                onPressed: resumeDownload,
                child: const Text('Resume Download'),
              ),
              ElevatedButton(
                onPressed: getCurrentProgressDownload,
                child: const Text('Get Current Progress'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text('Update UI'),
              ),
              // FutureBuilder(
              //   initialData: false,
              //   future: checkIsDownloaded(),
              //   builder: (context, snapshot) {
              //     var res = snapshot.data as bool;
              //     return Text(res ? 'Downloaded' : 'Not Downloaded');
              //   },
              // ),
              StreamBuilder(
                stream: Platform.isIOS
                    ? currentProgressDownloadAsStream()
                    : getCurrentProgressDownloadAsStream(),
                builder: (context, snapshot) {
                  return Text(snapshot.data == null
                      ? 'Not downloading'
                      : snapshot.data.toString());
                },
              ),
              Text(_progress.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
