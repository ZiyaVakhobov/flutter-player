import Flutter
import AVFoundation
import AVFAudio
import UIKit

public class SwiftUdevsVideoPlayerPlugin: NSObject, FlutterPlugin, VideoPlayerDelegate, AVAssetDownloadDelegate, AVAssetResourceLoaderDelegate {
    
    public static var viewController = FlutterViewController()
    private var flutterResult: FlutterResult?
    private static var channel : FlutterMethodChannel?
    
    var configuration: URLSessionConfiguration?
    var downloadSession: AVAssetDownloadURLSession?
    var downloadIdentifier = "\(Bundle.main.bundleIdentifier!).background"
    var totalDownloadedBytes: Int64 = 0
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        viewController = (UIApplication.shared.delegate?.window??.rootViewController)! as! FlutterViewController
        channel = FlutterMethodChannel(name: "udevs_video_player", binaryMessenger: registrar.messenger())
        let instance = SwiftUdevsVideoPlayerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel!)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        flutterResult = result
        switch call.method  {
        case "closePlayer": do {
            SwiftUdevsVideoPlayerPlugin.viewController.dismiss(animated:true)
            return
        }
        case "downloadVideo": do {
            guard let args = call.arguments else {
                return
            }
            guard let json = convertStringToDictionary(text: (args as! [String:String])["downloadConfigJsonString"] ?? "") else {
                return
            }
            let download : DownloadConfiguration = DownloadConfiguration.fromMap(map: json)
            print("Download URL \(download.url)")
            setupAssetDownload(videoUrl: download.url)
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
        flutterResult!("\(Int(duration))")
    }
    
    private func getPercentComplete(percent: Int){
        SwiftUdevsVideoPlayerPlugin.channel?.invokeMethod("percent", arguments: Int(percent))
    }
    
    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
        
        var percentComplete = 0.0
        print("percentComplete \(percentComplete)")
        // Iterate through the loaded time ranges
        for value in loadedTimeRanges {
            // Unwrap the CMTimeRange from the NSValue
            let loadedTimeRange = value.timeRangeValue
            // Calculate the percentage of the total expected asset duration
            percentComplete += loadedTimeRange.duration.seconds / timeRangeExpectedToLoad.duration.seconds
        }
        percentComplete *= 100
        print("percentComplete \(percentComplete)")
        getPercentComplete(percent :Int(percentComplete))
        let params = ["percent": percentComplete]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "completion"), object: nil, userInfo: params)
    }
    
    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("percentComplete \(100)")
        // Do not move the asset from the download location
        UserDefaults.standard.set(location.relativePath, forKey: "\(location.relativePath).cache")
    }
    
    
    func setupAssetDownload(videoUrl: String) {
        // Create new background session configuration.
        configuration = URLSessionConfiguration.background(withIdentifier: downloadIdentifier)
        
        // Create a new AVAssetDownloadURLSession with background configuration, delegate, and queue
        downloadSession = AVAssetDownloadURLSession(configuration: configuration!,
                                                    assetDownloadDelegate: self,
                                                    delegateQueue: OperationQueue.main)
        
        if let url = URL(string: videoUrl){
            let options = [AVURLAssetAllowsCellularAccessKey: false]
            let asset = AVURLAsset(url: url, options: options)
            asset.resourceLoader.setDelegate(self, queue: DispatchQueue(label: "uz.udevs.udevsVideoPlayer"))
            // Create new AVAssetDownloadTask for the desired asset
            let downloadTask = downloadSession?.makeAssetDownloadTask(asset: asset,
                                                                      assetTitle: "Some Title",
                                                                      assetArtworkData: nil,
                                                                      options: nil)
            
            print("Download URL \(url)")
            

//            downloadSession?.makeAssetDownloadTask(
//                  asset: asset,
//                  assetTitle: "My Video",
//                  assetArtworkData: nil,
//                  options: nil
//               )?.resume()
            // Start task and begin download
            downloadTask?.resume()
        }
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
