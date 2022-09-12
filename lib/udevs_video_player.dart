import 'udevs_video_player_platform_interface.dart';

class UdevsVideoPlayer {
  Future<String?> playVideo({
    required String cryptKey,
    required Map<String, String> initialResolution,
    required Map<String, String> resolutions,
    required String qualityText,
    required String speedText,
    required int lastPosition,
    required String title,
    required bool isSerial,
    required String episodeButtonText,
    required String nextButtonText,
    required Map<String, List<String>> seasons,
    required bool isLive,
    required String tvProgramsText,
    required List<String> tvPrograms,
  }) {
    return UdevsVideoPlayerPlatform.instance.playVideo(
      cryptKey: cryptKey,
      initialResolution: initialResolution,
      resolutions: resolutions,
      qualityText: qualityText,
      speedText: speedText,
      lastPosition: lastPosition,
      title: title,
      isSerial: isSerial,
      episodeButtonText: episodeButtonText,
      nextButtonText: nextButtonText,
      seasons: seasons,
      isLive: isLive,
      tvProgramsText: tvProgramsText,
      tvPrograms: tvPrograms,
    );
  }
}
