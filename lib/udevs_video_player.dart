import 'dart:convert';

import 'package:udevs_video_player/models/player_configuration.dart';

import 'udevs_video_player_platform_interface.dart';

class UdevsVideoPlayer {
  Future<String?> playVideo({
    required PlayerConfiguration playerConfig,
  }) {
    String jsonStringConfig = jsonEncode(playerConfig);
    return UdevsVideoPlayerPlatform.instance
        .playVideo(playerConfigJsonString: jsonStringConfig);
  }
}
