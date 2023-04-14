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

    String jsonStringConfig = jsonEncode(playerConfig.toJson());
    // String jsonStringConfig = jsonEncode({
    //   "initialResolution": {
    //     "Auto":
    //         "https://st1.uzdigital.tv/Animal_Planet/video.m3u8?token=20c4ea3df0ba43ac0feebbe1bb3fdff82d2971ed-78717a74766e586e6f50644f69724747-1681455918-1681445118&remote=94.232.24.122"
    //   },
    //   "resolutions": {
    //     "Auto":
    //         "https://st1.uzdigital.tv/Animal_Planet/video.m3u8?token=20c4ea3df0ba43ac0feebbe1bb3fdff82d2971ed-78717a74766e586e6f50644f69724747-1681455918-1681445118&remote=94.232.24.122",
    //     "480p":
    //         "http://st1.uzdigital.tv/Animal_Planet/tracks-v1a1a2/mono.m3u8?remote=94.232.24.122&token=20c4ea3df0ba43ac0feebbe1bb3fdff82d2971ed-78717a74766e586e6f50644f69724747-1681455918-1681445118&remote=94.232.24.122"
    //   },
    //   "qualityText": "Качество",
    //   "speedText": "Скорость",
    //   "lastPosition": 0,
    //   "title": "Animal Planet",
    //   "isSerial": false,
    //   "seasons": [],
    //   "isLive": true,
    //   "tvProgramsText": "Телепередачи",
    //   "programsInfoList": [
    //     {"day": "Yesterday", "tvPrograms": []},
    //     {"day": "Today", "tvPrograms": []},
    //     {"day": "Tomorrow", "tvPrograms": []}
    //   ],
    //   "showController": true,
    //   "playVideoFromAsset": false,
    //   "assetPath": "",
    //   "seasonIndex": 0,
    //   "episodeIndex": 0,
    //   "episodeText": "эпизод",
    //   "seasonText": "Сезон",
    //   "isMegogo": false,
    //   "isPremier": false,
    //   "videoId": "",
    //   "sessionId": "64368bc00ef5171d45e9a8b4",
    //   "megogoAccessToken":
    //       "MToxMjc3MzAzMTc3OjE2ODEzMDQ3NzQ6OjYyMWYxMDYzODA5MjZkZWQ3Y2JkOGIzNzJkMzg5NWZm",
    //   "authorization":
    //       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODEyOTYzMjAsImlzcyI6InVzZXIiLCJwaWQiOjQ0NjEyLCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI3NTA1MjdhMS0yMjdjLTRhYTUtYjY2MC04NjQzNjA5NzA0OTUifQ.D9wCndt8JCXvK5-HkSxCSikOouWra6hydussIJ9xclQ",
    //   "autoText": "Автонастройка",
    //   "baseUrl": "https://api.spec.uzd.udevs.io/v1/"
    // });
    return UdevsVideoPlayerPlatform.instance.playVideo(
      playerConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> downloadVideo(
      {required DownloadConfiguration downloadConfig}) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance
        .downloadVideo(downloadConfigJsonString: jsonStringConfig);
  }

  Future<dynamic> pauseDownload(
      {required DownloadConfiguration downloadConfig}) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance
        .pauseDownload(downloadConfigJsonString: jsonStringConfig);
  }

  Future<dynamic> resumeDownload(
      {required DownloadConfiguration downloadConfig}) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance
        .resumeDownload(downloadConfigJsonString: jsonStringConfig);
  }

  Future<bool> isDownloadVideo(
      {required DownloadConfiguration downloadConfig}) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance
        .isDownloadVideo(downloadConfigJsonString: jsonStringConfig);
  }

  Future<int?> getCurrentProgressDownload(
      {required DownloadConfiguration downloadConfig}) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance
        .getCurrentProgressDownload(downloadConfigJsonString: jsonStringConfig);
  }

  Stream<MediaItemDownload> get currentProgressDownloadAsStream =>
      UdevsVideoPlayerPlatform.instance.currentProgressDownloadAsStream();

  Future<int?> getStateDownload(
      {required DownloadConfiguration downloadConfig}) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance
        .getStateDownload(downloadConfigJsonString: jsonStringConfig);
  }

  Future<int?> getBytesDownloaded(
      {required DownloadConfiguration downloadConfig}) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance
        .getBytesDownloaded(downloadConfigJsonString: jsonStringConfig);
  }

  Future<int?> getContentBytesDownload(
      {required DownloadConfiguration downloadConfig}) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance
        .getContentBytesDownload(downloadConfigJsonString: jsonStringConfig);
  }

  Future<dynamic> removeDownload(
      {required DownloadConfiguration downloadConfig}) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance
        .removeDownload(downloadConfigJsonString: jsonStringConfig);
  }

  void dispose() => UdevsVideoPlayerPlatform.instance.dispose();
}
