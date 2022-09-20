import Flutter
import UIKit

public class SwiftUdevsVideoPlayerPlugin: NSObject, FlutterPlugin, VideoPlayerDelegate {
    
   
    public static var viewController = FlutterViewController()
    var flutterResult: FlutterResult?
    
   
    
  public static func register(with registrar: FlutterPluginRegistrar) {
      viewController = (UIApplication.shared.delegate?.window??.rootViewController)! as! FlutterViewController
      let channel = FlutterMethodChannel(name: "udevs_video_player", binaryMessenger: registrar.messenger())
    let instance = SwiftUdevsVideoPlayerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      flutterResult = result;
    if(call.method == "playVideo"){
        
     var seasons = [Dictionary<String, Any>()]
                  guard let args = call.arguments else {
                      return
                  }
        print(args);
                  if (call.method == "closePlayer" ) {
                      let vc = VideoPlayerViewController()
                      debugPrint("XCODE PLAYER CLOSE")
                      vc.dismiss(animated: true, completion: nil)
                  }
                  let a = (args as! [String:Any])["playerConfigJsonString"];
                  if let myArgs = a as? [String: Any],
                     
                        let url = (myArgs["initialResolution"] as! [String:String])["Auto"],
                     let title = myArgs["title"] as? String,
                    
                     let resolutions = myArgs["resolutions"] as? [String:String] {
                      guard URL(string: url) != nil else {
                          return
                      }
                      let sortedResolutions = SortFunctions.sortWithKeys(resolutions)
                      let vc = VideoPlayerViewController()
                      vc.modalPresentationStyle = .fullScreen
                      vc.delegate = self
                      vc.locale = "en"
                      vc.urlString = url
                      vc.startPosition = 10000
                      vc.hasNextVideo = false
                      vc.resolutions = sortedResolutions
                      vc.isSerial = false
                      vc.titleText = title
                      vc.seasons  = Seasons.fromDictinary(map: seasons)
                      vc.binaryMessenger = SwiftUdevsVideoPlayerPlugin.viewController.binaryMessenger
                      SwiftUdevsVideoPlayerPlugin.viewController.present(vc, animated: true,  completion: nil)
                  }
    }else{
        result("iOS " + UIDevice.current.systemVersion)}
  }
    
    func getDuration(duration: Double) {
        flutterResult!(Int(duration))
        print("Duration: \(duration)")
    }
    
}
