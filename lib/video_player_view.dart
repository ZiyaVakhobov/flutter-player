import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef FlutterVideoPayerViewCreatedCallback = void Function(
  VideoPlayerViewController controller,
);

class VideoPlayerView extends StatelessWidget {
  const VideoPlayerView({
    super.key,
    required this.onMapViewCreated,
  });

  final FlutterVideoPayerViewCreatedCallback onMapViewCreated;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          layoutDirection: TextDirection.ltr,
          viewType: 'plugins.udevs/video_player_view',
          onPlatformViewCreated: _onPlatformViewCreated,
        );
      case TargetPlatform.iOS:
        return UiKitView(
          layoutDirection: TextDirection.ltr,
          creationParams: const <String, dynamic>{},
          viewType: 'plugins.udevs/video_player_view',
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        return Text(
          '$defaultTargetPlatform is not yet supported by the web_view plugin',
        );
    }
  }

  // Callback method when platform view is created
  void _onPlatformViewCreated(int id) =>
      onMapViewCreated(VideoPlayerViewController._(id));
}

// VideoPlayerView Controller class to set url etc
class VideoPlayerViewController {
  VideoPlayerViewController._(int id)
      : _channel = MethodChannel('plugins.udevs/video_player_view_$id');

  final MethodChannel _channel;

  Future<void> setUrl({
    required String url,
    ResizeMode resizeMode = ResizeMode.fit,
  }) async =>
      _channel.invokeMethod(
        'setUrl',
        {
          'url': url,
          'resizeMode': resizeMode.name,
        },
      );

  Future<void> setAssets({
    required String assets,
    ResizeMode resizeMode = ResizeMode.fit,
  }) async {
    await _channel.invokeMethod(
      'setAssets',
      {
        'url': assets,
        'resizeMode': resizeMode.name,
      },
    );
  }
}

enum ResizeMode { fit, fill, zoom }
