import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:udevs_video_player/udevs_video_player_method_channel.dart';

void main() {
  MethodChannelUdevsVideoPlayer platform = MethodChannelUdevsVideoPlayer();
  const MethodChannel channel = MethodChannel('udevs_video_player');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('playVideo', () async {
    expect(
        await platform.playVideo(
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
