import 'package:udevs_video_player/models/player_configuration.dart';

import 'udevs_video_player_platform_interface.dart';
export 'package:udevs_video_player/models/player_configuration.dart';
export 'package:udevs_video_player/models/movie.dart';
export 'package:udevs_video_player/models/season.dart';
export 'package:udevs_video_player/models/tv_program.dart';
export 'package:udevs_video_player/models/programs_info.dart';

class UdevsVideoPlayer {
  Future<String?> playVideo({
    required PlayerConfiguration playerConfig,
    required bool isIos,
  }) {
    return UdevsVideoPlayerPlatform.instance.playVideo(
      playerConfigJsonString: playerConfig,
      isIos: isIos,
    );
  }
}
