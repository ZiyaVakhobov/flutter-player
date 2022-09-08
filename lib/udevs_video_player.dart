import 'udevs_video_player_platform_interface.dart';

class UdevsVideoPlayer {
  playVideo(
    String url,
    int lastPosition,
    String title,
  ) {
    UdevsVideoPlayerPlatform.instance.playVideo(
      url,
      lastPosition,
      title,
    );
  }
}
