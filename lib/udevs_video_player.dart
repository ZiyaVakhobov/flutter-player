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
    String jsonStringConfig = jsonEncode({"initialResolution":{"Автонастройка":"https://st1.uzdigital.tv/Milly_TVHD/video.m3u8?token=514ebf5d7567aa1c6bb690e177e7f76452063e34-49767a7a6e4479715657466647587942-1694522831-1694512031&remote=94.232.24.122"},"resolutions":{"Автонастройка":"https://st1.uzdigital.tv/Milly_TVHD/video.m3u8?token=514ebf5d7567aa1c6bb690e177e7f76452063e34-49767a7a6e4479715657466647587942-1694522831-1694512031&remote=94.232.24.122","1080p":"http://st1.uzdigital.tv/Milly_TVHD/tracks-v1a1/mono.m3u8?remote=94.232.24.122&token=514ebf5d7567aa1c6bb690e177e7f76452063e34-49767a7a6e4479715657466647587942-1694522831-1694512031&remote=94.232.24.122","576p":"http://st1.uzdigital.tv/Milly_TVHD/tracks-v2a1/mono.m3u8?remote=94.232.24.122&token=514ebf5d7567aa1c6bb690e177e7f76452063e34-49767a7a6e4479715657466647587942-1694522831-1694512031&remote=94.232.24.122"},"qualityText":"Качество","speedText":"Скорость воспроизведения","lastPosition":0,"title":"Milliy","isSerial":false,"episodeButtonText":"","nextButtonText":"","seasons":[],"isLive":true,"tvProgramsText":"Телепередачи","programsInfoList":[{"day":"Вчера","tvPrograms":[]},{"day":"Сегодня","tvPrograms":[]},{"day":"Завтра","tvPrograms":[]}],"showController":true,"playVideoFromAsset":false,"assetPath":"","seasonIndex":0,"episodeIndex":0,"isMegogo":false,"isPremier":false,"videoId":"","sessionId":"64fc659dd80dc5f8a1bab9c0","megogoAccessToken":"MToxMzE5OTY0Nzk2OjE2OTQyNjM3MDg6OjEyMzFmMWU2NWJhZWI0OTE1OWNhY2I5ODk0Y2EwNWNi","authorization":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODY1NTk5MDIsImlzcyI6InVzZXIiLCJwaWQiOjc2MDY2LCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI4YzUyNmFiZC0yZDBhLTQ1YzEtYjUyNy04MTRmOTliNWYwNDAifQ.ffXIBxI693pcaZmMrXNWEa_HrvYO_waN77FzBLbryUI","autoText":"Автонастройка","baseUrl":"https://api.spec.uzd.udevs.io/v1/","fromCache":false,"movieShareLink":"","channels":[{"id":"932c72d6-d2e2-4bbc-a930-cd8c3b0b2350","image":"https://cdn.uzd.udevs.io/uzdigital/images/c9971d2d-a444-4bb8-9595-54b716ec0bd7.png","name":"RUTV","resolutions":{}},{"id":"2e514cc7-1cef-4768-8932-39c77643dd9d","image":"https://cdn.uzd.udevs.io/uzdigital/images/cefa678c-e2cf-4de3-957c-d1a1873ecd3d.png","name":"FTV","resolutions":{}},{"id":"007d537e-4031-44da-9d1b-adf7a085ff5c","image":"https://cdn.uzd.udevs.io/uzdigital/images/0b27ce2a-090c-425d-b2e3-3e0e53318005.png","name":"Zor TV HD","resolutions":{}},{"id":"536de716-fba2-4efc-8548-23c1d17f927a","image":"https://cdn.uzd.udevs.io/uzdigital/images/4a7f5262-b2e8-4b35-a8a3-4427485d50a2.png","name":"МУЗ-ТВ O'ZBEKISTON","resolutions":{}},{"id":"85a51c4b-3d6e-49a3-84df-70c476b60e04","image":"https://cdn.uzd.udevs.io/uzdigital/images/5e61f56e-b741-4ea2-8c27-a2ef2af56f4f.png","name":"Музыка Первого","resolutions":{}},{"id":"d255671e-c00b-4815-a5e1-53082ff26ddf","image":"https://cdn.uzd.udevs.io/uzdigital/images/d249c9ce-cc04-40bb-8eff-58c23ee8a37d.png","name":"MY 5 ","resolutions":{}},{"id":"9a7b354c-40b3-4216-851b-466314dcc756","image":"https://cdn.uzd.udevs.io/uzdigital/images/a958f39e-d79e-4c1b-a730-06e81dbb4f9f.png","name":"MYDAY TV","resolutions":{}},{"id":"3536bb4a-06d1-49b0-87a1-9103e1a11032","image":"https://cdn.uzd.udevs.io/uzdigital/images/131a4813-f906-4cff-bf8e-0281f1f24528.png","name":"TRT MUSIC","resolutions":{}},{"id":"7f2f390c-75cd-4e85-a461-9c5874a84940","image":"https://cdn.uzd.udevs.io/uzdigital/images/47a6b4a3-ddd0-41d7-aa8e-4b15ea456107.png","name":"Milliy","resolutions":{}},{"id":"83ec6e22-e11e-4b6a-9391-59ba8043abec","image":"https://cdn.uzd.udevs.io/uzdigital/images/1e4ee1ad-c3d4-4131-bc43-74b7a1e29ea2.png","name":"NAVO","resolutions":{}},{"id":"f310c203-d487-447c-99aa-22010927799d","image":"https://cdn.uzd.udevs.io/uzdigital/images/7363c604-e0e6-41ea-b271-0193122014d1.png","name":"Buxoro","resolutions":{}}],"ip":"89.236.205.221","selectChannelIndex":0});
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
