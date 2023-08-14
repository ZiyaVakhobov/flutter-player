import 'dart:async';
import 'dart:convert';

import 'package:udevs_video_player/models/download_configuration.dart';
import 'package:udevs_video_player/models/media_item_download.dart';
import 'package:udevs_video_player/models/player_configuration.dart';

import 'udevs_video_player_platform_interface.dart';
export 'package:udevs_video_player/models/player_configuration.dart';
export 'package:udevs_video_player/models/movie.dart';
export 'package:udevs_video_player/models/season.dart';
export 'package:udevs_video_player/models/tv_program.dart';
export 'package:udevs_video_player/models/programs_info.dart';
export 'package:udevs_video_player/models/download_configuration.dart';
export 'package:udevs_video_player/models/media_item_download.dart';

class UdevsVideoPlayer {
  UdevsVideoPlayer._();

  static final UdevsVideoPlayer _instance = UdevsVideoPlayer._();

  factory UdevsVideoPlayer() => _instance;

  Future<int?> playVideo({required PlayerConfiguration playerConfig}) {
    // String jsonStringConfig = jsonEncode(playerConfig.toJson());
    String jsonStringConfig = jsonEncode({
      "initialResolution": {
        "Auto":
            "https://st1.uzdigital.tv/ViP_Premiere/index.m3u8?token=c3fd50c0113fcc0feee98198d0eddf731e010c75-4c76486247555052656d7a4355647044-1690878387-1690867587&remote=94.232.24.122"
      },
      "resolutions": {
        "Auto":
            "https://st1.uzdigital.tv/ViP_Premiere/index.m3u8?token=c3fd50c0113fcc0feee98198d0eddf731e010c75-4c76486247555052656d7a4355647044-1690878387-1690867587&remote=94.232.24.122",
        "480p":
            "http://st1.uzdigital.tv/Animal_Planet/tracks-v1a1a2/mono.m3u8?remote=94.232.24.122&token=20c4ea3df0ba43ac0feebbe1bb3fdff82d2971ed-78717a74766e586e6f50644f69724747-1681455918-1681445118&remote=94.232.24.122"
      },
      "qualityText": "Качество",
      "speedText": "Скорость",
      "lastPosition": 0,
      "title": "ViP Premiere",
      "isSerial": false,
      "seasons": [],
      "isLive": true,
      "tvProgramsText": "Телепередачи",
      "programsInfoList": [
        {"day": "Yesterday", "tvPrograms": []},
        {"day": "Today", "tvPrograms": []},
        {"day": "Tomorrow", "tvPrograms": []}
      ],
      "showController": true,
      "playVideoFromAsset": false,
      "assetPath": "",
      "seasonIndex": 0,
      "episodeIndex": 0,
      "episodeText": "эпизод",
      "seasonText": "Сезон",
      "isMegogo": false,
      "isPremier": false,
      "videoId": "",
      "sessionId": "64368bc00ef5171d45e9a8b4",
      "megogoAccessToken":
          "MToxMjc3MzAzMTc3OjE2ODEzMDQ3NzQ6OjYyMWYxMDYzODA5MjZkZWQ3Y2JkOGIzNzJkMzg5NWZm",
      "authorization":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODU2MTI1NTQsImlzcyI6InVzZXIiLCJwaWQiOjM2MTA1LCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI4M2Q1OWY0My1mNzA1LTQ5OGYtODI1Zi0yZTYyMGE0MGY4ODgifQ.XSItCVaJyLePn6pWv1p33v41CHnlpO3CZfRkR5wV_j4",
      "autoText": "Автонастройка",
      "baseUrl": "https://api.spec.uzd.udevs.io/v1/",
      "channels": [
        {
          "id": "0e335c03-e8a6-4960-b4e7-a3f9b96e0312",
          "image":
              "https://cdn.api.milliontv.uz/million-movies/images/da033011830d4d3eaa94fc42c7b7a12a.jpg",
          "name": "Sport Uz",
          "resolutions": {}
        },
        {
          "id": "47825ed6-673c-474a-a571-19cdbb65d7c2",
          "image":
              "https://cdn.api.milliontv.uz/million-movies/images/54e11d3547894f90a664db293692294f.jpg",
          "name": "TOSHKENT",
          "resolutions": {}
        },
        {
          "id": "838e2437-9b60-47a4-a7a9-5cda7839d6e2",
          "image":
              "https://cdn.api.milliontv.uz/million-movies/images/c1121590c00f4fba97f1844d48b07746.jpg",
          "name": "NAVO",
          "resolutions": {}
        },
        {
          "id": "d5d3d512-5f07-4257-995a-6135af28e2b2",
          "image":
              "https://cdn.api.milliontv.uz/million-movies/images/58082f29007c4ac69f14671d4483047a.jpg",
          "name": "Madaniyat va Ma'rifat",
          "resolutions": {}
        },
        {
          "id": "2e7181b6-9d7b-43b3-acc6-962ee950ae18",
          "image":
              "https://cdn.api.milliontv.uz/million-movies/images/bf61d527a5b54ef6b8101b54b19a6de5.jpg",
          "name": "Dunyo Boylab",
          "resolutions": {}
        },
      ],
      "ip": "89.236.205.221",
      "selectChannelIndex": 1,
    });
    return UdevsVideoPlayerPlatform.instance.playVideo(
      playerConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> downloadVideo({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.downloadVideo(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> pauseDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.pauseDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> resumeDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.resumeDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<bool> isDownloadVideo({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.isDownloadVideo(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getCurrentProgressDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getCurrentProgressDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Stream<MediaItemDownload> get currentProgressDownloadAsStream =>
      UdevsVideoPlayerPlatform.instance.currentProgressDownloadAsStream();

  Future<int?> getStateDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getStateDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getBytesDownloaded({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getBytesDownloaded(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getContentBytesDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getContentBytesDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> removeDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.removeDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  void dispose() => UdevsVideoPlayerPlatform.instance.dispose();
}
