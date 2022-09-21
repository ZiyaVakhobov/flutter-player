import Flutter
import UIKit

public class SwiftUdevsVideoPlayerPlugin: NSObject, FlutterPlugin, VideoPlayerDelegate {

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
         if let myArgs = json as? [String: Any],let url = (myArgs["initialResolution"] as! [String:String]).values.first,
            let title = myArgs["title"] as? String,
            let qualityText = myArgs["qualityText"] as? String,
            let speedText = myArgs["speedText"] as? String,
            let duration = myArgs["lastPosition"] as? Int,
            let seasons = myArgs["seasons"] as? [Dictionary<String, Any>],
            let isSerial = myArgs["isSerial"] as? Bool,
            let resolutions = myArgs["resolutions"] as? [String:String] {
                guard URL(string: url) != nil else {
                   return
                }
                print("fvjnkm,l")
                let sortedResolutions = SortFunctions.sortWithKeys(resolutions)
                let vc = VideoPlayerViewController()
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self
                vc.locale = "en"
                vc.urlString = url
                vc.startPosition = 0
                vc.qualityLabelText = qualityText
                vc.speedLabelText = speedText
                vc.hasNextVideo = false
                vc.resolutions = sortedResolutions
                vc.isSerial = isSerial
                vc.titleText = title
                vc.seasons  = Seasons.fromDictinary(map: seasons)
                vc.binaryMessenger = SwiftUdevsVideoPlayerPlugin.viewController.binaryMessenger
             SwiftUdevsVideoPlayerPlugin.viewController.present(vc, animated: true,  completion: nil)
         } else if call.method == "playTV" {
             
             var channelData = [Dictionary<String, Any>()]
             var programData = [Dictionary<String, Any>()]
           
             guard let args = call.arguments else {
                 return
             }
            
             if let myArgs = args as? [String: Any],
                let url = myArgs["url"] as? String,let title = myArgs["title"] as? String, let duration = myArgs["duration"] as? Int, let hasNextVideo = myArgs["has_next_video"] as? Bool,let isSerial = myArgs["is_serial"] as? Bool, let locale = myArgs["locale"] as? String, let resolutions = myArgs["resolutions"] as? [String:String] {
                 print("QUALITY MAP: \(resolutions)")
                 guard let videoURL = URL(string: url) else {
                     return
                 }
                 channelData = myArgs["channels"] as! [Dictionary<String, Any>]
                 programData = myArgs["programs"] as! [Dictionary<String, Any>]

                 let sortedResolutions = SortFunctions.sortWithKeys(resolutions)
                 let vc = TVVideoPlayerViewController()
                 vc.modalPresentationStyle = .fullScreen
                 vc.delegate = self
                 vc.urlString = url
                 vc.startPosition = duration
                 vc.hasNextVideo = hasNextVideo
                 vc.resolutions = sortedResolutions
                 vc.isSerial = isSerial
                 vc.titleText = title
                 vc.locale = locale
                 vc.programs = ProgramModel.fromDictinaryProgramms(map: programData)
                 vc.channels = Channels.fromDictinaryChannel(map: channelData)
                 print("ChannelData = \(channelData)")
                 print("PROGRAM DATA \(programData)")
                 vc.binaryMessengerMainChannel = SwiftUdevsVideoPlayerPlugin.viewController.binaryMessenger
                 vc.binaryMessenger = SwiftUdevsVideoPlayerPlugin.viewController.binaryMessenger
                 SwiftUdevsVideoPlayerPlugin.viewController.present(vc, animated: true,  completion: nil)
             }
         } else {
             result("Parse error");
         }
    } else {
        result("iOS " + UIDevice.current.systemVersion);
    }
  }
    
    func getDuration(duration: Double) {
        flutterResult!("\(duration)")
        print("Duration: \(duration)")
    }
    
    
}
