import 'dart:convert';

import 'package:udevs_video_player/models/player_configuration.dart';

import 'udevs_video_player_platform_interface.dart';
export 'package:udevs_video_player/models/player_configuration.dart';
export 'package:udevs_video_player/models/movie.dart';
export 'package:udevs_video_player/models/season.dart';
export 'package:udevs_video_player/models/tv_program.dart';
export 'package:udevs_video_player/models/programs_info.dart';

class UdevsVideoPlayer {
  Future<String?> playVideo({
    required PlayerConfiguration playerConfig,
  }) {
    String jsonStringConfig = jsonEncode({"initialResolution":{"Автонастройка":"https://cdn.uzd.udevs.io/uzdigital/videos/a04c9257216b2f2085c88be31a13e5d7/master.m3u8","1080p":"https://cdn.uzd.udevs.io/uzdigital/videos/a04c9257216b2f2085c88be31a13e5d7/1080p/index.m3u8","720p":"https://cdn.uzd.udevs.io/uzdigital/videos/a04c9257216b2f2085c88be31a13e5d7/720p/index.m3u8","480p":"https://cdn.uzd.udevs.io/uzdigital/videos/a04c9257216b2f2085c88be31a13e5d7/480p/index.m3u8","360p":"https://cdn.uzd.udevs.io/uzdigital/videos/a04c9257216b2f2085c88be31a13e5d7/360p/index.m3u8","240p":"https://cdn.uzd.udevs.io/uzdigital/videos/a04c9257216b2f2085c88be31a13e5d7/240p/index.m3u8"},"resolutions":{"Автонастройка":"https://cdn.uzd.udevs.io/uzdigital/videos/a04c9257216b2f2085c88be31a13e5d7/master.m3u8","1080p":"https://cdn.uzd.udevs.io/uzdigital/videos/a04c9257216b2f2085c88be31a13e5d7/1080p/index.m3u8","720p":"https://cdn.uzd.udevs.io/uzdigital/videos/a04c9257216b2f2085c88be31a13e5d7/720p/index.m3u8","480p":"https://cdn.uzd.udevs.io/uzdigital/videos/a04c9257216b2f2085c88be31a13e5d7/480p/index.m3u8","360p":"https://cdn.uzd.udevs.io/uzdigital/videos/a04c9257216b2f2085c88be31a13e5d7/360p/index.m3u8","240p":"https://cdn.uzd.udevs.io/uzdigital/videos/a04c9257216b2f2085c88be31a13e5d7/240p/index.m3u8"},"qualityText":"Качество","speedText":"Скорость","lastPosition":114,"title":" Миньоны: Грювитация","isSerial":false,"episodeButtonText":"Эпизоды","nextButtonText":"След.эпизод","seasons":[],"isLive":false,"tvProgramsText":"Телеканалы","programsInfoList":[],"showController":true,"playVideoFromAsset":false,"assetPath":"","seasonIndex":0,"episodeIndex":0,"isMegogo":false,"isPremier":false,"videoId":"minony-gryuvitaciya","sessionId":"6378330f186ba07753cdcecb","megogoAccessToken":"MToxMjE4OTEzNzI2OjE2Njg4MjI5MTM6OjIyNGY3ZDFiN2Y5ZDhmZmVhMWU1NzQxYTNmZGI4YzI0","authorization":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NjcyMzAyNzQsImlzcyI6InVzZXIiLCJwaWQiOjEzMDcsInJvbGUiOiJjdXN0b21lciIsInN1YiI6IjNlMmIxOWUxLTczZGQtNDgxOC04ZTJjLTk0YzYzMWEwNWQ5MiJ9.qlX_XMFGPnakwG8gsy_Yu3xGyayT6JXyY_AMS-kTObo","autoText":"Автонастройка","baseUrl":"https://api.spec.uzd.udevs.io/v1/"});
    return UdevsVideoPlayerPlatform.instance.playVideo(
      playerConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> closeVideo() {
    return UdevsVideoPlayerPlatform.instance.closeVideo();
  }

  Future<dynamic> download(String url) {
    return UdevsVideoPlayerPlatform.instance.download(url);
  }

  Stream<int> get percent => UdevsVideoPlayerPlatform.instance.percent();
}
