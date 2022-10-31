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

  playVideo() async {
    List<Season> seasons = [];
    List<Movie> movies1 = [];
    movies1.add(Movie(
      id: '22109',
      title: 'Женщина-Халк: Адвокат',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/ec80c248-ddb8-4b68-98b1-0d59e9a1acdd.jpg',
      duration: 2122,
      resolutions: {
        'Автонастройка':
            'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/master.m3u8',
        '1080p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/1080p/index.m3u8',
        '720p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/720p/index.m3u8',
        '480p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/480p/index.m3u8',
        '360p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/360p/index.m3u8',
        '240p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
      },
    ));
    movies1.add(Movie(
      id: '22110',
      title: 'Женщина-Халк: Адвокат',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/ec80c248-ddb8-4b68-98b1-0d59e9a1acdd.jpg',
      duration: 1669,
      resolutions: {
        'Автонастройка':
            'https://cdn.uzd.udevs.io/uzdigital/videos/a298d71ece9105727c7c2e3bc219ef86/master.m3u8',
        '1080p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/a298d71ece9105727c7c2e3bc219ef86/1080p/index.m3u8',
        '720p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/a298d71ece9105727c7c2e3bc219ef86/720p/index.m3u8',
        '480p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/a298d71ece9105727c7c2e3bc219ef86/480p/index.m3u8',
        '360p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/a298d71ece9105727c7c2e3bc219ef86/360p/index.m3u8',
        '240p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/a298d71ece9105727c7c2e3bc219ef86/240p/index.m3u8',
      },
    ));
    seasons.add(Season(title: '1 Season', movies: movies1));
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
            isSerial: true,
            episodeButtonText: 'Эпизоды',
            nextButtonText: 'След.эпизод',
            seasons: seasons,
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

  playStream() async {
    List<Season> seasons = [];
    List<Movie> movies1 = [];
    movies1.add(Movie(
      id: '16270945',
      title: 'Episode 1',
      description: '',
      image: 'http://s3.vcdn.biz/static/f/3706791051/image.jpg',
      duration: 0,
      resolutions: {},
    ));
    movies1.add(Movie(
      id: '16270955',
      title: 'Episode 2',
      description: '',
      image: 'http://s3.vcdn.biz/static/f/3706791051/image.jpg',
      duration: 0,
      resolutions: {},
    ));
    movies1.add(Movie(
      id: '16270965',
      title: 'Episode 3',
      description: '',
      image: 'http://s3.vcdn.biz/static/f/3706791051/image.jpg',
      duration: 0,
      resolutions: {},
    ));
    movies1.add(Movie(
      id: '16270975',
      title: 'Episode 4',
      description: '',
      image: 'http://s3.vcdn.biz/static/f/3706791051/image.jpg',
      duration: 0,
      resolutions: {},
    ));
    seasons.add(Season(title: '1 Season', movies: movies1));
    seasons.add(Season(title: '2 Season', movies: movies1));
    try {
      var s = await _udevsVideoPlayerPlugin.playVideo(
              playerConfig: PlayerConfiguration(
            initialResolution: {
              "Автонастройка":
                  "https://meta.vcdn.biz/8f589fc229502eba46acdf901fc1d15a_mgg/vod/hls/b/450_900_1350_1500_2000_5000/u_sid/0/o/127719021/rsid/11e074f8-ff60-44d6-97ed-7ceb81f1a873/u_uid/1162445406/u_vod/4/u_device/uzdigital_test/u_devicekey/_uzdigital_test/u_did/MToxMTYyNDQ1NDA2OjE2NjY5NTA4MjE6OmMxM2ZkNGJmNDI2OTAyN2M4Y2E2MzA4ZTUzM2YyZDk3/a/0/type.amlst/playlist.m3u8"
            },
            resolutions: {
              "Автонастройка":
                  "https://meta.vcdn.biz/8f589fc229502eba46acdf901fc1d15a_mgg/vod/hls/b/450_900_1350_1500_2000_5000/u_sid/0/o/127719021/rsid/11e074f8-ff60-44d6-97ed-7ceb81f1a873/u_uid/1162445406/u_vod/4/u_device/uzdigital_test/u_devicekey/_uzdigital_test/u_did/MToxMTYyNDQ1NDA2OjE2NjY5NTA4MjE6OmMxM2ZkNGJmNDI2OTAyN2M4Y2E2MzA4ZTUzM2YyZDk3/a/0/type.amlst/playlist.m3u8",
              "1080p":
                  "https://meta.vcdn.biz/91656219d98b83c933269b94d50113b8_mgg/vod/hls/b/5000/u_sid/0/o/127719021/rsid/10dbec29-4efb-4ace-8562-c724fb4944e9/u_uid/1162445406/u_vod/4/u_device/uzdigital_test/u_devicekey/_uzdigital_test/u_did/MToxMTYyNDQ1NDA2OjE2NjY5NTA4MjE6OmMxM2ZkNGJmNDI2OTAyN2M4Y2E2MzA4ZTUzM2YyZDk3/a/0/type.amlst/playlist.m3u8",
              "720p":
                  "https://meta.vcdn.biz/eb73539e35a7bf6222bd0fda1c86ed5e_mgg/vod/hls/b/2000/u_sid/0/o/127719021/rsid/b8a0970b-f1a8-4fcc-93ab-162370b693e6/u_uid/1162445406/u_vod/4/u_device/uzdigital_test/u_devicekey/_uzdigital_test/u_did/MToxMTYyNDQ1NDA2OjE2NjY5NTA4MjE6OmMxM2ZkNGJmNDI2OTAyN2M4Y2E2MzA4ZTUzM2YyZDk3/a/0/type.amlst/playlist.m3u8",
              "480p":
                  "https://meta.vcdn.biz/709854d27e943d7b8690b3aca818d9c0_mgg/vod/hls/b/1500/u_sid/0/o/127719021/rsid/1d7dc6b6-3b59-41ae-951c-f25eceb38a0c/u_uid/1162445406/u_vod/4/u_device/uzdigital_test/u_devicekey/_uzdigital_test/u_did/MToxMTYyNDQ1NDA2OjE2NjY5NTA4MjE6OmMxM2ZkNGJmNDI2OTAyN2M4Y2E2MzA4ZTUzM2YyZDk3/a/0/type.amlst/playlist.m3u8",
              "360p":
                  "https://meta.vcdn.biz/68878fa53a6d96184ca6004875278eb7_mgg/vod/hls/b/1350/u_sid/0/o/127719021/rsid/68bad4d2-0aa3-4e4a-9b1e-d141501193ea/u_uid/1162445406/u_vod/4/u_device/uzdigital_test/u_devicekey/_uzdigital_test/u_did/MToxMTYyNDQ1NDA2OjE2NjY5NTA4MjE6OmMxM2ZkNGJmNDI2OTAyN2M4Y2E2MzA4ZTUzM2YyZDk3/a/0/type.amlst/playlist.m3u8",
              "320p":
                  "https://meta.vcdn.biz/2459264b6f868c89773bd5bfbbb23286_mgg/vod/hls/b/900/u_sid/0/o/127719021/rsid/74a3380c-5eed-461a-9d69-5b5da3a019f4/u_uid/1162445406/u_vod/4/u_device/uzdigital_test/u_devicekey/_uzdigital_test/u_did/MToxMTYyNDQ1NDA2OjE2NjY5NTA4MjE6OmMxM2ZkNGJmNDI2OTAyN2M4Y2E2MzA4ZTUzM2YyZDk3/a/0/type.amlst/playlist.m3u8",
              "240p":
                  "https://meta.vcdn.biz/5872c011d14d1adb312ddc917bee804f_mgg/vod/hls/b/450/u_sid/0/o/127719021/rsid/2e1d9a08-ac7e-4d17-b72f-ef428df69a95/u_uid/1162445406/u_vod/4/u_device/uzdigital_test/u_devicekey/_uzdigital_test/u_did/MToxMTYyNDQ1NDA2OjE2NjY5NTA4MjE6OmMxM2ZkNGJmNDI2OTAyN2M4Y2E2MzA4ZTUzM2YyZDk3/a/0/type.amlst/playlist.m3u8"
            },
            qualityText: 'Качество',
            speedText: 'Скорость',
            lastPosition: 0,
            title: "S1 E1  \"Episode 3\" ",
            isSerial: true,
            episodeButtonText: 'Эпизоды',
            nextButtonText: 'След.эпизод',
            seasons: seasons,
            isLive: false,
            tvProgramsText: 'Телеканалы',
            programsInfoList: [],
            showController: true,
            playVideoFromAsset: false,
            assetPath: '',
            seasonIndex: 0,
            episodeIndex: 0,
            isMegogo: true,
            isPremier: false,
            videoId: '16270775',
            sessionId: '635ba41840899f8827cf2076',
            megogoAccessToken:
                'MToxMTYyNDQ1NDA2OjE2NjY5NTA4MjE6OmMxM2ZkNGJmNDI2OTAyN2M4Y2E2MzA4ZTUzM2YyZDk3',
            authorization:
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NTg1MDEzNDMsImlzcyI6InVzZXIiLCJwaWQiOjEzMDcsInJvbGUiOiJjdXN0b21lciIsInN1YiI6IjYyMDQzMmZmLTc3ZWItNDc0Mi05MmFhLTZmOGU4NDcyMDI0ZCJ9.6SvUCBT0gb6tIRy1PL-C7WS7xHpJXc1PCZky6aH6HtA',
            autoText: 'Автонастройка',
            baseUrl: "https://api.spec.uzd.udevs.io/v1/",
          )) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  playTV() async {
    List<ProgramsInfo> programsInfoList = [];
    List<TvProgram> tvPrograms = [];
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    programsInfoList
        .add(ProgramsInfo(day: 'Yesterday', tvPrograms: tvPrograms));
    programsInfoList.add(ProgramsInfo(day: 'Today', tvPrograms: tvPrograms));
    programsInfoList.add(ProgramsInfo(day: 'Tomorrow', tvPrograms: tvPrograms));
    try {
      var s = await _udevsVideoPlayerPlugin.playVideo(
              playerConfig: PlayerConfiguration(
            baseUrl: "https://api.spec.uzd.udevs.io/v1/",
            initialResolution: {
              'Auto':
                  'https://flus.st.uz/3017/video.m3u8?token=da6e83609a647029700b8f7cf246e0efc5ee1692-2887490519--'
            },
            resolutions: {
              'Auto':
                  'https://flus.st.uz/3017/video.m3u8?token=da6e83609a647029700b8f7cf246e0efc5ee1692-2887490519--',
              '1080p':
                  'https://flus.st.uz/3017/video.m3u8?token=da6e83609a647029700b8f7cf246e0efc5ee1692-2887490519--',
              '720p':
                  'https://flus.st.uz/3017/video.m3u8?token=da6e83609a647029700b8f7cf246e0efc5ee1692-2887490519--',
              '480p':
                  'https://flus.st.uz/3017/video.m3u8?token=da6e83609a647029700b8f7cf246e0efc5ee1692-2887490519--',
              '360p':
                  'https://flus.st.uz/3017/video.m3u8?token=da6e83609a647029700b8f7cf246e0efc5ee1692-2887490519--',
              '240p':
                  'https://flus.st.uz/3017/video.m3u8?token=da6e83609a647029700b8f7cf246e0efc5ee1692-2887490519--',
            },
            qualityText: 'Quality',
            speedText: 'Speed',
            lastPosition: 1000,
            title: 'Женщина-Халк: Адвокат',
            isSerial: false,
            episodeButtonText: 'Episodes',
            nextButtonText: 'Next',
            seasons: [],
            isLive: true,
            tvProgramsText: 'Programs',
            programsInfoList: programsInfoList,
            showController: true,
            playVideoFromAsset: false,
            assetPath: 'assets/splash.mp4',
            seasonIndex: 0,
            episodeIndex: 0,
            isMegogo: false,
            isPremier: false,
            videoId: '',
            sessionId: '',
            megogoAccessToken: '',
            authorization: '',
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
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
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
                onPressed: playStream,
                child: const Text('Play Stream'),
              ),
              ElevatedButton(
                onPressed: playTV,
                child: const Text('Play TV'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
