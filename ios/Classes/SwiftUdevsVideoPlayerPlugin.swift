import Flutter
import UIKit

public class SwiftUdevsVideoPlayerPlugin: NSObject, FlutterPlugin, VideoPlayerDelegate {
    
    func getDuration(duration: Double) {
        flutterResult!("\(duration)")
        print("Duration: \(duration)")
    }
    
    public static var viewController = FlutterViewController()
    public var flutterResult: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        viewController = (UIApplication.shared.delegate?.window??.rootViewController)! as! FlutterViewController
        let channel = FlutterMethodChannel(name: "udevs_video_player", binaryMessenger: registrar.messenger())
        let instance = SwiftUdevsVideoPlayerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        flutterResult = result;
        if (call.method == "closePlayer" ) {
            let vc = VideoPlayerViewController()
            vc.dismiss(animated: true, completion: nil)
        }
        if(call.method == "playVideo"){
            guard let args = call.arguments else {
                return
            }
            let json = (args as! [String:Any])["playerConfigJsonString"]
            let playerConfiguration = PlayerConfiguration.fromMap(map: json as! [String : Any])
            if playerConfiguration != nil {
                if (playerConfiguration.isLive){
                    guard let videoURL = URL(string: playerConfiguration.url) else {
                        return
                    }
                    
                    let sortedResolutions = SortFunctions.sortWithKeys(playerConfiguration.resolutions)
                    print("playerConfiguration.tvProgramsText")
                    print(playerConfiguration.tvProgramsText)
                    print(playerConfiguration)
                    let vc = TVVideoPlayerViewController()
                    vc.modalPresentationStyle = .fullScreen
                    vc.delegate = self
                    vc.urlString = playerConfiguration.url
                    vc.startPosition = playerConfiguration.lastPosition
                    vc.resolutions = sortedResolutions
                    vc.titleText = playerConfiguration.title
                    vc.speedLabelText = playerConfiguration.speedText
                    vc.qualityLabelText = playerConfiguration.qualityText
                    vc.showsBtnText = playerConfiguration.tvProgramsText
                    vc.programs = playerConfiguration.programsInfoList
                    SwiftUdevsVideoPlayerPlugin.viewController.present(vc, animated: true,  completion: nil)
                } else {
                    guard URL(string: playerConfiguration.url) != nil else {
                        return
                    }
                    let sortedResolutions = SortFunctions.sortWithKeys(playerConfiguration.resolutions)
                    
                    let vc = VideoPlayerViewController()
                    vc.modalPresentationStyle = .fullScreen
                    vc.delegate = self
                    vc.urlString = playerConfiguration.url
                    vc.selectedQualityText = playerConfiguration.qualityText
                    vc.startPosition = playerConfiguration.lastPosition
                    vc.qualityLabelText = playerConfiguration.qualityText
                    vc.speedLabelText = playerConfiguration.speedText
                    vc.resolutions = sortedResolutions
                    vc.isSerial = playerConfiguration.isSerial
                    vc.titleText = playerConfiguration.title
                    vc.serialLabelText = playerConfiguration.episodeButtonText
                    vc.seasons  = playerConfiguration.seasons
                    SwiftUdevsVideoPlayerPlugin.viewController.present(vc, animated: true,  completion: nil)
                }
            }
        } else {
            result("iOS " + UIDevice.current.systemVersion);
        }
    }
}
