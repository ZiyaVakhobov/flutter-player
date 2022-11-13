import Flutter
import AVFAudio
import UIKit

public class SwiftUdevsVideoPlayerPlugin: NSObject, FlutterPlugin, VideoPlayerDelegate {
    
    func getDuration(duration: Double) {
        flutterResult!("\(duration)")
    }
    
    public static var viewController = FlutterViewController()
    private var flutterResult: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        viewController = (UIApplication.shared.delegate?.window??.rootViewController)! as! FlutterViewController
        let channel = FlutterMethodChannel(name: "udevs_video_player", binaryMessenger: registrar.messenger())
        let instance = SwiftUdevsVideoPlayerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        flutterResult = result
        if (call.method == "closePlayer" ) {
            SwiftUdevsVideoPlayerPlugin.viewController.dismiss(animated:true)
            return
        }
        if (call.method == "playVideo"){
            guard let args = call.arguments else {
                return
            }
            guard let json = convertStringToDictionary(text: (args as! [String:String])["playerConfigJsonString"] ?? "") else {
                return
            }
            let playerConfiguration : PlayerConfiguration = PlayerConfiguration.fromMap(map: json)
            let sortedResolutions = SortFunctions.sortWithKeys(playerConfiguration.resolutions)
            guard URL(string: playerConfiguration.url) != nil else {
                return
            }
            let vc = VideoPlayerViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.playerConfiguration = playerConfiguration
            vc.qualityLabelText = playerConfiguration.qualityText
            vc.speedLabelText = playerConfiguration.speedText
            vc.resolutions = sortedResolutions
            vc.selectedQualityText = playerConfiguration.autoText
            vc.seasons  = playerConfiguration.seasons
            SwiftUdevsVideoPlayerPlugin.viewController.present(vc, animated: true,  completion: nil)
        } else {
            result("iOS " + UIDevice.current.systemVersion);
        }
    }
}
