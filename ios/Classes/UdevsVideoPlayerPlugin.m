#import "UdevsVideoPlayerPlugin.h"
#if __has_include(<udevs_video_player/udevs_video_player-Swift.h>)
#import <udevs_video_player/udevs_video_player-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "udevs_video_player-Swift.h"
#endif

@implementation UdevsVideoPlayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [UdevsVideoPlayerPlugin registerWithRegistrar:registrar];
}
@end
