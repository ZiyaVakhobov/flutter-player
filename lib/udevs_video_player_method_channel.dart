import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'udevs_video_player_platform_interface.dart';

/// An implementation of [UdevsVideoPlayerPlatform] that uses method channels.
class MethodChannelUdevsVideoPlayer extends UdevsVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('udevs_video_player');
  final StreamController<int> _streamController = StreamController<int>();

  @override
  Future<String?> playVideo({
    required String playerConfigJsonString,
  }) async {
    final res =
        await methodChannel.invokeMethod<String>('playVideo', <String, dynamic>{
      'playerConfigJsonString': playerConfigJsonString,
    });
    return res;
  }

  @override
  Future<dynamic> closeVideo() async {
    final res = await methodChannel.invokeMethod<dynamic>('closePlayer');
    return res;
  }

  @override
  Future<dynamic> download(String url) async {
    final res = await methodChannel.invokeMethod<dynamic>(
      'download',
      <String, String>{
        'url': url,
      },
    );
    return res;
  }

  @override
  Stream<int> percent() {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'percent') {
        print("call.arguments");
        print(call.arguments);

        _streamController.add(int.parse(call.arguments.toString()));
      }
    });
    return _streamController.stream;
  }
}
