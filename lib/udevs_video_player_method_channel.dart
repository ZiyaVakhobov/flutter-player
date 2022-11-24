import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'models/download_configuration.dart';
import 'udevs_video_player_platform_interface.dart';

/// An implementation of [UdevsVideoPlayerPlatform] that uses method channels.
class MethodChannelUdevsVideoPlayer extends UdevsVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('udevs_video_player');
  final StreamController<DownloadConfiguration> _streamController =
      StreamController<DownloadConfiguration>();

  @override
  Future<String?> playVideo({
    required String playerConfigJsonString,
  }) async {
    final res = await methodChannel
        .invokeMethod<String?>('playVideo', <String, dynamic>{
      'playerConfigJsonString': playerConfigJsonString,
    });
    return res;
  }

  @override
  Future<String?> downloadVideo({
    required String downloadConfigJsonString,
  }) async {
    final res = await methodChannel
        .invokeMethod<String?>('downloadVideo', <String, dynamic>{
      'downloadConfigJsonString': downloadConfigJsonString,
    });
    return res;
  }

  @override
  Future<String?> pauseDownload({
    required String downloadConfigJsonString,
  }) async {
    final res = await methodChannel
        .invokeMethod<String?>('pauseDownload', <String, dynamic>{
      'downloadConfigJsonString': downloadConfigJsonString,
    });
    return res;
  }

  @override
  Future<String?> resumeDownload({
    required String downloadConfigJsonString,
  }) async {
    final res = await methodChannel
        .invokeMethod<String?>('resumeDownload', <String, dynamic>{
      'downloadConfigJsonString': downloadConfigJsonString,
    });
    return res;
  }

  @override
  Future<bool> isDownloadVideo({
    required String downloadConfigJsonString,
  }) async {
    final res = await methodChannel
        .invokeMethod<bool?>('checkIsDownloadedVideo', <String, dynamic>{
      'downloadConfigJsonString': downloadConfigJsonString,
    });
    return res ?? false;
  }

  @override
  Future<int?> getCurrentProgressDownload({
    required String downloadConfigJsonString,
  }) async {
    final res = await methodChannel
        .invokeMethod<int>('getCurrentProgressDownload', <String, dynamic>{
      'downloadConfigJsonString': downloadConfigJsonString,
    });
    return res;
  }

  @override
  Future<dynamic> closeVideo() async {
    final res = await methodChannel.invokeMethod<dynamic>('closePlayer');
    return res;
  }

  @override
  Stream<DownloadConfiguration> currentProgressDownloadAsStream() {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'percent') {
        var json = call.arguments as String;
        var decode = jsonDecode(json);
        _streamController.add(DownloadConfiguration(
            url: decode['url'], percent: decode['percent']));
      }
    });
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.onCancel;
  }
}
