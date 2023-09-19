import 'dart:async';
import 'dart:convert';

import 'package:udevs_video_player/models/download_configuration.dart';
import 'package:udevs_video_player/models/media_item_download.dart';
import 'package:udevs_video_player/models/player_configuration.dart';

import 'udevs_video_player_platform_interface.dart';

export 'package:udevs_video_player/models/download_configuration.dart';
export 'package:udevs_video_player/models/media_item_download.dart';
export 'package:udevs_video_player/models/movie.dart';
export 'package:udevs_video_player/models/player_configuration.dart';
export 'package:udevs_video_player/models/programs_info.dart';
export 'package:udevs_video_player/models/season.dart';
export 'package:udevs_video_player/models/tv_program.dart';

class UdevsVideoPlayer {
  factory UdevsVideoPlayer() => _instance;

  UdevsVideoPlayer._();

  static final UdevsVideoPlayer _instance = UdevsVideoPlayer._();

  Future<int?> playVideo({required PlayerConfiguration playerConfig}) {
    // String jsonStringConfig = jsonEncode(playerConfig.toJson());
    final String jsonStringConfig = jsonEncode({'initialResolution':{'Автонастройка':'https://st1.uzdigital.tv/Setanta1HD/video.m3u8?token=57de54127d279954e8c269b506ccceffe40f7031-554244766c747a5159706e59684f564d-1695109781-1695098981&remote=94.232.24.122'},'resolutions':{'Автонастройка':'https://st1.uzdigital.tv/Setanta1HD/video.m3u8?token=57de54127d279954e8c269b506ccceffe40f7031-554244766c747a5159706e59684f564d-1695109781-1695098981&remote=94.232.24.122','1080p':'http://st1.uzdigital.tv/Setanta1HD/tracks-v1a1a2/mono.m3u8?remote=94.232.24.122&token=57de54127d279954e8c269b506ccceffe40f7031-554244766c747a5159706e59684f564d-1695109781-1695098981&remote=94.232.24.122','576p':'http://st1.uzdigital.tv/Setanta1HD/tracks-v2a1a2/mono.m3u8?remote=94.232.24.122&token=57de54127d279954e8c269b506ccceffe40f7031-554244766c747a5159706e59684f564d-1695109781-1695098981&remote=94.232.24.122'},'qualityText':'Качество','speedText':'Скорость воспроизведения','lastPosition':0,'title':'Setanta Sports 1','isSerial':false,'episodeButtonText':'','nextButtonText':'','seasons':[],'isLive':true,'tvProgramsText':'Телепередачи','programsInfoList':[{'day':'Вчера','tvPrograms':[{'scheduledTime':'17:00','programTitle':'Программа отсутствует.'}]},{'day':'Сегодня','tvPrograms':[]},{'day':'Завтра','tvPrograms':[]}],'showController':true,'playVideoFromAsset':false,'assetPath':'','seasonIndex':0,'episodeIndex':0,'isMegogo':false,'isPremier':false,'videoId':'','sessionId':'65092979d80dc5f8a11f9e98','megogoAccessToken':'','authorization':'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODY1NTk5MDIsImlzcyI6InVzZXIiLCJwaWQiOjc2MDY2LCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI4YzUyNmFiZC0yZDBhLTQ1YzEtYjUyNy04MTRmOTliNWYwNDAifQ.ffXIBxI693pcaZmMrXNWEa_HrvYO_waN77FzBLbryUI','autoText':'Автонастройка','baseUrl':'https://api.spec.uzd.udevs.io/v1/','fromCache':false,'movieShareLink':'','channels':[{'id':'c0f06350-c9f7-44c0-a813-a6a594892133','image':'https://cdn.uzd.udevs.io/uzdigital/images/6de473e9-ecd9-4872-858c-a52f788a17fb.png','name':'Детский мир','resolutions':{}},{'id':'2666e36e-99fe-423d-b8ed-2dcfb0595c32','image':'https://cdn.uzd.udevs.io/uzdigital/images/9add8f57-db7f-4b99-82c0-1e85bcc0c388.png','name':' СТС Kids','resolutions':{}},{'id':'5c5f969a-2972-4a9f-bebc-24671eadd567','image':'https://cdn.uzd.udevs.io/uzdigital/images/d43063ce-82a3-41c1-9503-736f375a1309.png','name':'Карусель','resolutions':{}},{'id':'7866d816-1738-4714-b2fa-4333a50b28b1','image':'https://cdn.uzd.udevs.io/uzdigital/images/b68cde9e-3aeb-4a9f-bc3b-4374c03dd733.png','name':'Уник-Ум','resolutions':{}},{'id':'e5055009-1c69-492b-8cc3-afff6b5b66a9','image':'https://cdn.uzd.udevs.io/uzdigital/images/dedfe1ad-593b-4bdf-b6ba-4f1131a47a9d.png','name':'В гостях у сказки','resolutions':{}},{'id':'47f33a27-9001-4a92-9eb0-33c8857dbde9','image':'https://cdn.uzd.udevs.io/uzdigital/images/c4e4bcc5-6edd-41be-8d49-aa88518eabb0.png','name':'BOLAJON','resolutions':{}}],'ip':'89.236.205.221','selectChannelIndex':0,'tvCategories':[{'id':'','title':'Все'},{'id':'d761e3ce-6457-400e-adf8-8f86e1862fff','title':'Детские'},{'id':'1d157249-86c1-40c0-9ad0-763da20ed342','title':'Познавательные'},{'id':'976aafb5-a5f8-403e-9559-1d8f041a6c7d','title':'Новостные'},{'id':'2c503c02-413e-47d7-ad56-9768dab78071','title':'Музыкальные'},{'id':'682f2e44-6b5b-4c5d-bb54-c275d6cfef97','title':'Кино'},{'id':'547216f1-fd58-42ce-9e51-9f6d7b51bb0a','title':'Спортивные '},{'id':'16391f05-894c-49a8-8aa5-b1bdb60e6432','title':'Национальные'}]});
    return UdevsVideoPlayerPlatform.instance.playVideo(
      playerConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> downloadVideo({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.downloadVideo(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> pauseDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.pauseDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> resumeDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.resumeDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<bool> isDownloadVideo({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.isDownloadVideo(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getCurrentProgressDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getCurrentProgressDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Stream<MediaItemDownload> get currentProgressDownloadAsStream =>
      UdevsVideoPlayerPlatform.instance.currentProgressDownloadAsStream();

  Future<int?> getStateDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getStateDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getBytesDownloaded({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getBytesDownloaded(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getContentBytesDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getContentBytesDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> removeDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.removeDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  void dispose() => UdevsVideoPlayerPlatform.instance.dispose();
}
