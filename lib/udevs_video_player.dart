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
    String jsonStringConfig = jsonEncode({"initialResolution":{"Auto":"https://st1.uzdigital.tv/Viasat_Nature/index.m3u8?token=2c166b0705491d9efcfc0deec3a470a7cad9d01d-4564596945517641664b6d4b42465679-1680774106-1680763306&remote=94.232.24.122"},"resolutions":{"Auto":"https://st1.uzdigital.tv/Viasat_Nature/index.m3u8?token=2c166b0705491d9efcfc0deec3a470a7cad9d01d-4564596945517641664b6d4b42465679-1680774106-1680763306&remote=94.232.24.122","576p":"https://st1.uzdigital.tv/Viasat_Nature/tracks-v1a1/mono.m3u8?remote=94.232.24.122&token=2c166b0705491d9efcfc0deec3a470a7cad9d01d-4564596945517641664b6d4b42465679-1680774106-1680763306&remote=94.232.24.122"},"qualityText":"Качество","speedText":"Скорость","lastPosition":0,"title":"Viasat  nature","isSerial":false,"episodeButtonText":"","nextButtonText":"","seasons":[],"isLive":true,"tvProgramsText":"Телепередачи","programsInfoList":[{"day":"Вчера","tvPrograms":[]},{"day":"Сегодня","tvPrograms":[]},{"day":"Завтра","tvPrograms":[]}],"showController":true,"playVideoFromAsset":false,"assetPath":"","seasonIndex":0,"episodeIndex":0,"isMegogo":false,"isPremier":false,"videoId":"","sessionId":"642d63030ef5171d45e2bf59","megogoAccessToken":"","authorization":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODA1MDM5NDcsImlzcyI6InVzZXIiLCJwaWQiOjM2MTA1LCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI3YjgzNDZhMS1iZjNmLTQxYzQtOGNjOS00NDNkM2M1MTQzZDQifQ.7N9aUIKVyhyuQ1DO-V2iyUdwFRkC1Bme1FqRSk7h-P0","autoText":"Автонастройка","baseUrl":"https://api.spec.uzd.udevs.io/v1/","fromCache":false});
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
