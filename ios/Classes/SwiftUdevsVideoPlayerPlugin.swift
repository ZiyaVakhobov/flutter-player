import Flutter
import AVFoundation
import AVFAudio
import UIKit

public class SwiftUdevsVideoPlayerPlugin: NSObject, FlutterPlugin, VideoPlayerDelegate, AVAssetDownloadDelegate {
    
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
        switch call.method  {
        case "closePlayer": do {
            SwiftUdevsVideoPlayerPlugin.viewController.dismiss(animated:true)
            return
        }
        case "playVideo": do {
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
            return
        }
        default: do {
            result("Not Implemented")
            return
          }
        }
    }
    
    func getDuration(duration: Double) {
        flutterResult!("\(duration)")
    }
    
    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
        var percentComplete = 0.0
        // Iterate through the loaded time ranges
        for value in loadedTimeRanges {
            // Unwrap the CMTimeRange from the NSValue
            let loadedTimeRange = value.timeRangeValue
            // Calculate the percentage of the total expected asset duration
            percentComplete += loadedTimeRange.duration.seconds / timeRangeExpectedToLoad.duration.seconds
        }
        percentComplete *= 100
        // Update UI state: post notification, update KVO state, invoke callback, etc.
    }
    
    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        // Do not move the asset from the download location
        UserDefaults.standard.set(location.relativePath, forKey: "testVideoPath")
    }
}

//struct Download  {
////    var configuration: URLSessionConfiguration?
////    var downloadSession: AVAssetDownloadURLSession?
//    var downloadIdentifier = "\(Bundle.main.bundleIdentifier!).background"
//    weak var delegate: VideoPlayerDelegate?
//    
//    mutating func setupAssetDownload(videoUrl: String) {
//        // Create new background session configuration.
//       var configuration = URLSessionConfiguration.background(withIdentifier: downloadIdentifier)
//
//        // Create a new AVAssetDownloadURLSession with background configuration, delegate, and queue
//        var downloadSession = AVAssetDownloadURLSession(configuration: configuration,
//                                                        assetDownloadDelegate: delegate,
//                                                        delegateQueue: OperationQueue.main)
//
//        if let url = URL(string: videoUrl){
//            let asset = AVURLAsset(url: url)
//
//            // Create new AVAssetDownloadTask for the desired asset
//            let downloadTask = downloadSession?.makeAssetDownloadTask(asset: asset,
//                                                                     assetTitle: "Some Title",
//                                                                     assetArtworkData: nil,
//                                                                     options: nil)
//            // Start task and begin download
//            downloadTask?.resume()
//        }
//    }//end method
//    
//}
