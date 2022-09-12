import 'package:flutter_test/flutter_test.dart';
import 'package:udevs_video_player/udevs_video_player.dart';
import 'package:udevs_video_player/udevs_video_player_platform_interface.dart';
import 'package:udevs_video_player/udevs_video_player_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockUdevsVideoPlayerPlatform
    with MockPlatformInterfaceMixin
    implements UdevsVideoPlayerPlatform {
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
  }) =>
      Future.value('42');
}

void main() {
  final UdevsVideoPlayerPlatform initialPlatform =
      UdevsVideoPlayerPlatform.instance;

  test('$MethodChannelUdevsVideoPlayer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUdevsVideoPlayer>());
  });

  test('playVideo', () async {
    UdevsVideoPlayer udevsVideoPlayerPlugin = UdevsVideoPlayer();
    MockUdevsVideoPlayerPlatform fakePlatform = MockUdevsVideoPlayerPlatform();
    UdevsVideoPlayerPlatform.instance = fakePlatform;

    expect(
        await udevsVideoPlayerPlugin.playVideo(
          cryptKey: '#&',
          initialResolution: {'Auto': '_url'},
          resolutions: {'Auto': '_url', '720p': '_url'},
          qualityText: 'Quality',
          speedText: 'Speed',
          lastPosition: 1000,
          title: 'Shan-chi',
          isSerial: false,
          episodeButtonText: 'Episodes',
          nextButtonText: 'Next',
          seasons: {'': []},
          isLive: false,
          tvProgramsText: 'Programs',
          tvPrograms: [],
        ),
        '42');
  });
}
