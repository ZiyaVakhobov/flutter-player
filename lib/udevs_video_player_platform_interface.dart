import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:udevs_video_player/models/media_item_download.dart';

import 'udevs_video_player_method_channel.dart';

abstract class UdevsVideoPlayerPlatform extends PlatformInterface {
  /// Constructs a UdevsVideoPlayerPlatform.
  UdevsVideoPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static UdevsVideoPlayerPlatform _instance = MethodChannelUdevsVideoPlayer();

  /// The default instance of [UdevsVideoPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelUdevsVideoPlayer].
  static UdevsVideoPlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UdevsVideoPlayerPlatform] when
  /// they register themselves.
  static set instance(UdevsVideoPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<dynamic> playVideo({required String playerConfigJsonString});

  Future downloadVideo({required String downloadConfigJsonString});

  Future pauseDownload({required String downloadConfigJsonString});

  Future resumeDownload({required String downloadConfigJsonString});

  Future<bool> isDownloadVideo({required String downloadConfigJsonString});

  Future<int?> getCurrentProgressDownload({
    required String downloadConfigJsonString,
  });

  Stream<MediaItemDownload> currentProgressDownloadAsStream();

  Future<int?> getStateDownload({required String downloadConfigJsonString});

  Future<int?> getPercentDownload({required String downloadConfigJsonString});

  Future<int?> getBytesDownloaded({required String downloadConfigJsonString});

  Future<int?> getContentBytesDownload({
    required String downloadConfigJsonString,
  });

  Future removeDownload({required String downloadConfigJsonString});

  void dispose();
}
