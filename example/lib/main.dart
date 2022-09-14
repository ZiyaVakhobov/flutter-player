import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:udevs_video_player/models/movie.dart';
import 'package:udevs_video_player/models/player_configuration.dart';
import 'package:udevs_video_player/models/programs_info.dart';
import 'package:udevs_video_player/models/season.dart';
import 'package:udevs_video_player/models/tv_program.dart';
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
      title: 'Женщина-Халк: Адвокат',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/ec80c248-ddb8-4b68-98b1-0d59e9a1acdd.jpg',
      duration: 2122,
      resolutions: {
        'Auto':
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
      title: 'Женщина-Халк: Адвокат',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/ec80c248-ddb8-4b68-98b1-0d59e9a1acdd.jpg',
      duration: 1669,
      resolutions: {
        'Auto':
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
    movies1.add(Movie(
      title: 'Женщина-Халк: Адвокат',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/ec80c248-ddb8-4b68-98b1-0d59e9a1acdd.jpg',
      duration: 1669,
      resolutions: {
        'Auto':
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
    movies1.add(Movie(
      title: 'Женщина-Халк: Адвокат',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/ec80c248-ddb8-4b68-98b1-0d59e9a1acdd.jpg',
      duration: 1669,
      resolutions: {
        'Auto':
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
    movies1.add(Movie(
      title: 'Женщина-Халк: Адвокат',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/ec80c248-ddb8-4b68-98b1-0d59e9a1acdd.jpg',
      duration: 1669,
      resolutions: {
        'Auto':
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
    seasons.add(Season(title: '2 Season', movies: movies1));
    List<TvProgram> tvPrograms = [];
    tvPrograms.add(TvProgram(programTitle: 'Program1', scheduledTime: '16:52'));
    tvPrograms.add(TvProgram(programTitle: 'Program1', scheduledTime: '16:52'));
    tvPrograms.add(TvProgram(programTitle: 'Program1', scheduledTime: '16:52'));
    tvPrograms.add(TvProgram(programTitle: 'Program1', scheduledTime: '16:52'));
    tvPrograms.add(TvProgram(programTitle: 'Program1', scheduledTime: '16:52'));
    tvPrograms.add(TvProgram(programTitle: 'Program1', scheduledTime: '16:52'));
    tvPrograms.add(TvProgram(programTitle: 'Program1', scheduledTime: '16:52'));
    tvPrograms.add(TvProgram(programTitle: 'Program1', scheduledTime: '16:52'));
    tvPrograms.add(TvProgram(programTitle: 'Program1', scheduledTime: '16:52'));
    tvPrograms.add(TvProgram(programTitle: 'Program1', scheduledTime: '16:52'));
    tvPrograms.add(TvProgram(programTitle: 'Program1', scheduledTime: '16:52'));
    tvPrograms.add(TvProgram(programTitle: 'Program1', scheduledTime: '16:52'));
    List<ProgramsInfo> programsInfoList = [];
    programsInfoList
        .add(ProgramsInfo(day: 'Yesterday', tvPrograms: tvPrograms));
    programsInfoList.add(ProgramsInfo(day: 'Today', tvPrograms: tvPrograms));
    programsInfoList.add(ProgramsInfo(day: 'Tomorrow', tvPrograms: tvPrograms));
    try {
      var s = await _udevsVideoPlayerPlugin.playVideo(
              playerConfig: PlayerConfiguration(
            initialResolution: {
              'Auto':
                  'https://st1.uzdigital.tv/Discovery_Channel/video.m3u8?token=cdb9ce039992b0a00c1976a82f3e6b422c31257e-6a736b52496173564f7348487167535a-1663160536-1663149736&remote=89.236.205.221'
            },
            resolutions: {
              'Auto':
                  'https://st1.uzdigital.tv/Discovery_Channel/video.m3u8?token=cdb9ce039992b0a00c1976a82f3e6b422c31257e-6a736b52496173564f7348487167535a-1663160536-1663149736&remote=89.236.205.221',
              '576p':
                  'http://st1.uzdigital.tv/Discovery_Channel/tracks-v1a1a2/mono.m3u8?token=cdb9ce039992b0a00c1976a82f3e6b422c31257e-6a736b52496173564f7348487167535a-1663160536-1663149736&remote=89.236.205.221',
              '480p':
                  'http://st1.uzdigital.tv/Discovery_Channel/tracks-v2a1a2/mono.m3u8?token=cdb9ce039992b0a00c1976a82f3e6b422c31257e-6a736b52496173564f7348487167535a-1663160536-1663149736&remote=89.236.205.221',
              '360p':
                  'http://st1.uzdigital.tv/Discovery_Channel/tracks-v3a1a2/mono.m3u8?token=cdb9ce039992b0a00c1976a82f3e6b422c31257e-6a736b52496173564f7348487167535a-1663160536-1663149736&remote=89.236.205.221',
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
          )) ??
          'nothing';
      print('result: $s');
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
