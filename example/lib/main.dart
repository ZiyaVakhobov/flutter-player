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
      title: '1 cерия',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/5c41ce25-ed03-4980-9dbf-14b8ea2b8bbe.jpg',
      duration: 1761,
      resolutions: {
        'Автонастройка':
            'https://cdn.uzd.udevs.io/uzdigital/videos/6fae7fb5e4ad1b34392d0b691441a1ed/master.m3u8',
        '1080p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/6fae7fb5e4ad1b34392d0b691441a1ed/1080p/index.m3u8',
        '720p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/6fae7fb5e4ad1b34392d0b691441a1ed/720p/index.m3u8',
        '480p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/6fae7fb5e4ad1b34392d0b691441a1ed/480p/index.m3u8',
        '360p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/6fae7fb5e4ad1b34392d0b691441a1ed/360p/index.m3u8',
        '240p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/6fae7fb5e4ad1b34392d0b691441a1ed/240p/index.m3u8',
      },
    ));
    movies1.add(Movie(
      title: '2 серия',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/7e0503a3-2182-45c5-a41e-b78868b155b0.jpg',
      duration: 1707,
      resolutions: {
        'Автонастройка':
            'https://cdn.uzd.udevs.io/uzdigital/videos/6a27a5be8b3eea93bf65fa3d08d46df9/master.m3u8',
        '1080p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/6a27a5be8b3eea93bf65fa3d08d46df9/1080p/index.m3u8',
        '720p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/6a27a5be8b3eea93bf65fa3d08d46df9/720p/index.m3u8',
        '480p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/6a27a5be8b3eea93bf65fa3d08d46df9/480p/index.m3u8',
        '360p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/6a27a5be8b3eea93bf65fa3d08d46df9/360p/index.m3u8',
        '240p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/6a27a5be8b3eea93bf65fa3d08d46df9/240p/index.m3u8',
      },
    ));
    movies1.add(Movie(
      title: '3 серия',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/f109948c-8cb4-4985-b164-c7791231ac16.jpg',
      duration: 1741,
      resolutions: {
        'Автонастройка':
            'https://cdn.uzd.udevs.io/uzdigital/videos/04ef0760e132715f8a2c2dc5bdaf46aa/master.m3u8',
        '1080p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/04ef0760e132715f8a2c2dc5bdaf46aa/1080p/index.m3u8',
        '720p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/04ef0760e132715f8a2c2dc5bdaf46aa/720p/index.m3u8',
        '480p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/04ef0760e132715f8a2c2dc5bdaf46aa/480p/index.m3u8',
        '360p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/04ef0760e132715f8a2c2dc5bdaf46aa/360p/index.m3u8',
        '240p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/04ef0760e132715f8a2c2dc5bdaf46aa/240p/index.m3u8',
      },
    ));
    movies1.add(Movie(
      title: '4 серия',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/4f005b6d-d2ad-497a-b784-aaceddf9e96d.jpg',
      duration: 7641,
      resolutions: {
        'Автонастройка':
            'https://cdn.uzd.udevs.io/uzdigital/videos/040a6baed96ee6c727dd017e65c71047/master.m3u8',
        '1080p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/040a6baed96ee6c727dd017e65c71047/1080p/index.m3u8',
        '720p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/040a6baed96ee6c727dd017e65c71047/720p/index.m3u8',
        '480p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/040a6baed96ee6c727dd017e65c71047/480p/index.m3u8',
        '360p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/040a6baed96ee6c727dd017e65c71047/360p/index.m3u8',
        '240p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/040a6baed96ee6c727dd017e65c71047/240p/index.m3u8',
      },
    ));
    movies1.add(Movie(
      title: '5 серия',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/09d064bd-6491-457d-97c7-969d393b26a0.jpg',
      duration: 1744,
      resolutions: {
        'Автонастройка':
            'https://cdn.uzd.udevs.io/uzdigital/videos/588182b7ba9497331b3746da11767c8f/master.m3u8',
        '1080p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/588182b7ba9497331b3746da11767c8f/1080p/index.m3u8',
        '720p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/588182b7ba9497331b3746da11767c8f/720p/index.m3u8',
        '480p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/588182b7ba9497331b3746da11767c8f/480p/index.m3u8',
        '360p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/588182b7ba9497331b3746da11767c8f/360p/index.m3u8',
        '240p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/588182b7ba9497331b3746da11767c8f/240p/index.m3u8',
      },
    ));
    movies1.add(Movie(
      title: '7 серия',
      description: '',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/8e80605b-9669-45f1-ab58-be57f89ed69c.jpg',
      duration: 1741,
      resolutions: {
        'Автонастройка':
            'https://cdn.uzd.udevs.io/uzdigital/videos/bc52ae02fa9651b0cf2fcf58b0f611aa/master.m3u8',
        '1080p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/bc52ae02fa9651b0cf2fcf58b0f611aa/1080p/index.m3u8',
        '720p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/bc52ae02fa9651b0cf2fcf58b0f611aa/720p/index.m3u8',
        '480p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/bc52ae02fa9651b0cf2fcf58b0f611aa/480p/index.m3u8',
        '360p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/bc52ae02fa9651b0cf2fcf58b0f611aa/360p/index.m3u8',
        '240p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/bc52ae02fa9651b0cf2fcf58b0f611aa/240p/index.m3u8',
      },
    ));
    List<Movie> movies2 = [];
    movies2.add(Movie(
      title: '1 cерия',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/867ed288-88cc-410c-aacb-ca66f1f24d66.jpg',
      duration: 1734,
      resolutions: {
        'Автонастройка':
            'https://cdn.uzd.udevs.io/uzdigital/videos/2e12615dea89f8fbecae388660d1823a/master.m3u8',
        '1080p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/2e12615dea89f8fbecae388660d1823a/1080p/index.m3u8',
        '720p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/2e12615dea89f8fbecae388660d1823a/720p/index.m3u8',
        '480p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/2e12615dea89f8fbecae388660d1823a/480p/index.m3u8',
        '360p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/2e12615dea89f8fbecae388660d1823a/360p/index.m3u8',
        '240p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/2e12615dea89f8fbecae388660d1823a/240p/index.m3u8',
      },
    ));
    seasons.add(Season(title: '1 Сезон', movies: movies1));
    seasons.add(Season(title: '2 Сезон', movies: movies2));
    List<ProgramsInfo> programsInfoList = [];
    List<TvProgram> tvPrograms = [];
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(scheduledTime: '09:00', programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    programsInfoList.add(ProgramsInfo(day: 'Yesterday', tvPrograms: tvPrograms));
    programsInfoList.add(ProgramsInfo(day: 'Today', tvPrograms: tvPrograms));
    programsInfoList.add(ProgramsInfo(day: 'Tomorrov', tvPrograms: tvPrograms));
    try {
      var s = await _udevsVideoPlayerPlugin.playVideo(
              playerConfig: PlayerConfiguration(
            initialResolution: {
              'Автонастройка':
                  'https://st1.uzdigital.tv/Discovery_Channel/video.m3u8?token=dd71667ee2d6b7a8f1d86603641b26ac919287de-6463504e434c5245757965616e78766c-1663767735-1663756935&remote=89.236.205.221'
            },
            resolutions: {
              'Автонастройка':
                  'https://cdn.uzd.udevs.io/uzdigital/videos/a9585c2a26ae5d17d5ddc2d4e7ecf9d6/master.m3u8',
              '1080p':
                  'https://cdn.uzd.udevs.io/uzdigital/videos/a9585c2a26ae5d17d5ddc2d4e7ecf9d6/1080p/index.m3u8',
              '720p':
                  'https://cdn.uzd.udevs.io/uzdigital/videos/a9585c2a26ae5d17d5ddc2d4e7ecf9d6/720p/index.m3u8',
              '480p':
                  'https://cdn.uzd.udevs.io/uzdigital/videos/a9585c2a26ae5d17d5ddc2d4e7ecf9d6/480p/index.m3u8',
              '360p':
                  'https://cdn.uzd.udevs.io/uzdigital/videos/a9585c2a26ae5d17d5ddc2d4e7ecf9d6/360p/index.m3u8',
              '240p':
                  'https://cdn.uzd.udevs.io/uzdigital/videos/a9585c2a26ae5d17d5ddc2d4e7ecf9d6/240p/index.m3u8',
            },
            qualityText: 'Качество',
            speedText: 'Скорость',
            lastPosition: 1000,
            title: 'Женщина-Халк: Адвокат',
            isSerial: false,
            episodeButtonText: 'Эпизоды',
            nextButtonText: 'След.эпизод',
            seasons: [],
            isLive: true,
            tvProgramsText: 'Телеканалы',
            programsInfoList: programsInfoList,
            showController: true,
            playVideoFromAsset: false,
            assetPath: 'assets/splash.mp4',
            seasonIndex: 1,
            episodeIndex: 2,
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
          child: ElevatedButton(
            onPressed: playVideo,
            child: const Text('Play'),
          ),
        ),
      ),
    );
  }
}
