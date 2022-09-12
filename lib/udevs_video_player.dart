import 'udevs_video_player_platform_interface.dart';

class UdevsVideoPlayer {
  Future<String?> playVideo(
    String url,
    int lastPosition,
    String title,
    bool isSerial,
    String episodeButtonText,
    String nextButtonText,
    bool isLive,
    String tvProgramsText,
  ) {
    return UdevsVideoPlayerPlatform.instance.playVideo(
      url,
      lastPosition,
      title,
      isSerial,
      episodeButtonText,
      nextButtonText,
      isLive,
      tvProgramsText,
    );
  }
}
