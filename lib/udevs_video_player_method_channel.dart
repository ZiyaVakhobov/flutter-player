import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'udevs_video_player_platform_interface.dart';

/// An implementation of [UdevsVideoPlayerPlatform] that uses method channels.
class MethodChannelUdevsVideoPlayer extends UdevsVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('udevs_video_player');

  @override
  playVideo(
    String url,
    int lastPosition,
    int duration,
    String title,
  ) async {
    await methodChannel.invokeMethod<Map>('playVideo', <String, dynamic>{
      'url': url,
      'lastPosition': lastPosition,
      'duration': duration,
      'title': title,
    });
  }
}
