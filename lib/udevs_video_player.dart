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
    String jsonStringConfig = jsonEncode({"initialResolution":{"1000000p":"https://meta.vcdn.biz/2ca58920e3bc0847276ccaa8d13433ea_mgg/vod/hls/b/450_900_1350_1500_2000_5000/u_sid/0/o/128752391/rsid/02240c54-5062-498f-b1b9-b464fad7f36d/u_uid/0/u_vod/3/u_device/uzdigital_test/u_devicekey/_uzdigital_test/a/0/type.amlst/playlist.m3u8","1080p":"https://meta.vcdn.biz/72d2f82af3b06b388ea3521e5a90aeef_mgg/vod/hls/b/5000/u_sid/0/o/128752391/rsid/4badb0ec-e9a8-4d89-ae60-3c74e315a55c/u_uid/0/u_vod/3/u_device/uzdigital_test/u_devicekey/_uzdigital_test/a/0/type.amlst/playlist.m3u8","720p":"https://meta.vcdn.biz/7c01ea93b2b05625313dda2263170db8_mgg/vod/hls/b/2000/u_sid/0/o/128752391/rsid/f9b9676a-1024-4209-8f66-dd273593279b/u_uid/0/u_vod/3/u_device/uzdigital_test/u_devicekey/_uzdigital_test/a/0/type.amlst/playlist.m3u8","480p":"https://meta.vcdn.biz/f9daa78ab2827fd7ac0fa9ba32908ec8_mgg/vod/hls/b/1500/u_sid/0/o/128752391/rsid/b186157a-cbf7-4f7f-8e28-7e9a47aef0cc/u_uid/0/u_vod/3/u_device/uzdigital_test/u_devicekey/_uzdigital_test/a/0/type.amlst/playlist.m3u8","360p":"https://meta.vcdn.biz/75aa8ecf1918be3fa068c285e0835d00_mgg/vod/hls/b/1350/u_sid/0/o/128752391/rsid/05d48543-8141-4093-a7c8-f4bb3d93874d/u_uid/0/u_vod/3/u_device/uzdigital_test/u_devicekey/_uzdigital_test/a/0/type.amlst/playlist.m3u8","320p":"https://meta.vcdn.biz/d7867113830ec72c775244fdfdf6f9d4_mgg/vod/hls/b/900/u_sid/0/o/128752391/rsid/9db2a03e-2945-49f1-8f1e-a0dd999664dd/u_uid/0/u_vod/3/u_device/uzdigital_test/u_devicekey/_uzdigital_test/a/0/type.amlst/playlist.m3u8","240p":"https://meta.vcdn.biz/4138a24a336e0760a683abf70dec9491_mgg/vod/hls/b/450/u_sid/0/o/128752391/rsid/82a0e55a-384c-4476-abc4-2ecc6c9324f9/u_uid/0/u_vod/3/u_device/uzdigital_test/u_devicekey/_uzdigital_test/a/0/type.amlst/playlist.m3u8"},"resolutions":{"1000000p":"https://meta.vcdn.biz/2ca58920e3bc0847276ccaa8d13433ea_mgg/vod/hls/b/450_900_1350_1500_2000_5000/u_sid/0/o/128752391/rsid/02240c54-5062-498f-b1b9-b464fad7f36d/u_uid/0/u_vod/3/u_device/uzdigital_test/u_devicekey/_uzdigital_test/a/0/type.amlst/playlist.m3u8","1080p":"https://meta.vcdn.biz/72d2f82af3b06b388ea3521e5a90aeef_mgg/vod/hls/b/5000/u_sid/0/o/128752391/rsid/4badb0ec-e9a8-4d89-ae60-3c74e315a55c/u_uid/0/u_vod/3/u_device/uzdigital_test/u_devicekey/_uzdigital_test/a/0/type.amlst/playlist.m3u8","720p":"https://meta.vcdn.biz/7c01ea93b2b05625313dda2263170db8_mgg/vod/hls/b/2000/u_sid/0/o/128752391/rsid/f9b9676a-1024-4209-8f66-dd273593279b/u_uid/0/u_vod/3/u_device/uzdigital_test/u_devicekey/_uzdigital_test/a/0/type.amlst/playlist.m3u8","480p":"https://meta.vcdn.biz/f9daa78ab2827fd7ac0fa9ba32908ec8_mgg/vod/hls/b/1500/u_sid/0/o/128752391/rsid/b186157a-cbf7-4f7f-8e28-7e9a47aef0cc/u_uid/0/u_vod/3/u_device/uzdigital_test/u_devicekey/_uzdigital_test/a/0/type.amlst/playlist.m3u8","360p":"https://meta.vcdn.biz/75aa8ecf1918be3fa068c285e0835d00_mgg/vod/hls/b/1350/u_sid/0/o/128752391/rsid/05d48543-8141-4093-a7c8-f4bb3d93874d/u_uid/0/u_vod/3/u_device/uzdigital_test/u_devicekey/_uzdigital_test/a/0/type.amlst/playlist.m3u8","320p":"https://meta.vcdn.biz/d7867113830ec72c775244fdfdf6f9d4_mgg/vod/hls/b/900/u_sid/0/o/128752391/rsid/9db2a03e-2945-49f1-8f1e-a0dd999664dd/u_uid/0/u_vod/3/u_device/uzdigital_test/u_devicekey/_uzdigital_test/a/0/type.amlst/playlist.m3u8","240p":"https://meta.vcdn.biz/4138a24a336e0760a683abf70dec9491_mgg/vod/hls/b/450/u_sid/0/o/128752391/rsid/82a0e55a-384c-4476-abc4-2ecc6c9324f9/u_uid/0/u_vod/3/u_device/uzdigital_test/u_devicekey/_uzdigital_test/a/0/type.amlst/playlist.m3u8"},"qualityText":"Качество","speedText":"Скорость","lastPosition":5264,"title":"Таксист","isSerial":false,"episodeButtonText":"Эпизоды","nextButtonText":"След.эпизод","seasons":[],"isLive":false,"tvProgramsText":"Телеканалы","programsInfoList":[],"showController":true,"playVideoFromAsset":false,"assetPath":"","seasonIndex":0,"episodeIndex":0,"isMegogo":true,"isPremier":false,"videoId":"16360645","sessionId":"6389a24c186ba07753d2902d","megogoAccessToken":"","authorization":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NjcyMzAyNzQsImlzcyI6InVzZXIiLCJwaWQiOjEzMDcsInJvbGUiOiJjdXN0b21lciIsInN1YiI6IjNlMmIxOWUxLTczZGQtNDgxOC04ZTJjLTk0YzYzMWEwNWQ5MiJ9.qlX_XMFGPnakwG8gsy_Yu3xGyayT6JXyY_AMS-kTObo","autoText":"Автонастройка","baseUrl":"https://api.spec.uzd.udevs.io/v1/","fromCache":false});
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
