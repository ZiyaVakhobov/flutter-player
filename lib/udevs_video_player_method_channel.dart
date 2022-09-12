import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'udevs_video_player_platform_interface.dart';

/// An implementation of [UdevsVideoPlayerPlatform] that uses method channels.
class MethodChannelUdevsVideoPlayer extends UdevsVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('udevs_video_player');

  @override
  Future<String?> playVideo(
    String url,
    int lastPosition,
    String title,
    bool isSerial,
    String episodeButtonText,
    String nextButtonText,
    bool isLive,
    String tvProgramsText,
  ) async {
    final res = await methodChannel.invokeMethod<String>('playVideo', <String, dynamic>{
      'url': url,
      'lastPosition': lastPosition,
      'title': title,
      'isSerial': isSerial,
      'episodeButtonText': episodeButtonText,
      'nextButtonText': nextButtonText,
      'isLive': isLive,
      'tvProgramsText': tvProgramsText,
    });
    return res;
  }
}
