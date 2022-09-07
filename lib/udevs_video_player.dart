
import 'udevs_video_player_platform_interface.dart';

class UdevsVideoPlayer {

  playVideo(String url) {
    UdevsVideoPlayerPlatform.instance.playVideo(url);
  }
}
