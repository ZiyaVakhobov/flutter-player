import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'udevs_video_player_platform_interface.dart';

/// An implementation of [UdevsVideoPlayerPlatform] that uses method channels.
class MethodChannelUdevsVideoPlayer extends UdevsVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('udevs_video_player');

  @override
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
  }) async {
    final res =
        await methodChannel.invokeMethod<String>('playVideo', <String, dynamic>{
      'cryptKey': cryptKey,
      'initialResolution': initialResolution,
      'resolutions': resolutions,
      'qualityText': qualityText,
      'speedText': speedText,
      'lastPosition': lastPosition,
      'title': title,
      'isSerial': isSerial,
      'episodeButtonText': episodeButtonText,
      'nextButtonText': nextButtonText,
      'seasons': seasons,
      'isLive': isLive,
      'tvProgramsText': tvProgramsText,
      'tvPrograms': tvPrograms,
    });
    return res;
  }
}
