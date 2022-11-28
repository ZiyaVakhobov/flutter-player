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
        case "pauseDownload": do {
            guard let args = call.arguments else {
                return
            }
            guard let json = convertStringToDictionary(text: (args as! [String:String])["downloadConfigJsonString"] ?? "") else {
                return
            }
            let download : DownloadConfiguration = DownloadConfiguration.fromMap(map: json)
            pauseDownload(videoUrl: download.url)
            return
        }
        case "resumeDownload": do {
            guard let args = call.arguments else {
                return
            }
            guard let json = convertStringToDictionary(text: (args as! [String:String])["downloadConfigJsonString"] ?? "") else {
                return
            }
            let download : DownloadConfiguration = DownloadConfiguration.fromMap(map: json)
            restorePendingDownloads()
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
            print("Download URL \(playerConfiguration.url)")
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
    
    func successDownload(){
        flutterResult!("Success")
    }
    
    private func getPercentComplete(percent: Int){
        SwiftUdevsVideoPlayerPlugin.channel?.invokeMethod("percent", arguments: Int(percent))
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
        print(assetDownloadTask.state)
        percentComplete *= 100
        print("percentComplete \(percentComplete)")
        getPercentComplete(percent : Int(percentComplete))
        let params = ["percent": percentComplete]
        if percentComplete == 100 {
            successDownload()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "completion"), object: nil, userInfo: params)
    }
    
    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        UserDefaults.standard.set(location.relativePath, forKey: "assetPath")
    }
    
    func setupAssetDownload(videoUrl: String) {
        guard UserDefaults.standard.value(forKey: "assetPath") is String else {
            // Create new background session configuration.
            configuration = URLSessionConfiguration.background(withIdentifier: downloadIdentifier)
            
            // Create a new AVAssetDownloadURLSession with background configuration, delegate, and queue
            downloadSession = AVAssetDownloadURLSession(configuration: configuration!,
                                                        assetDownloadDelegate: self,
                                                        delegateQueue: OperationQueue.main)
            if let url = URL(string: videoUrl){
                let asset = AVURLAsset(url: url)
                // Create new AVAssetDownloadTask for the desired asset
                let downloadTask = downloadSession?.makeAssetDownloadTask(asset: asset,
                                                                          assetTitle: "Some Title",
                                                                          assetArtworkData: nil,
                                                                          options: nil)
                downloadTask?.resume()
            }
            return
        }
        print(UserDefaults.standard.value(forKey: "\(String(describing: videoUrl)).cache"))
        getPercentComplete(percent: 100)

    }
    
    private func pauseDownload(videoUrl:String){
        //        configuration = URLSessionConfiguration.background(withIdentifier: downloadIdentifier)
        //
        //        // Create a new AVAssetDownloadURLSession with background configuration, delegate, and queue
        //        downloadSession = AVAssetDownloadURLSession(configuration: configuration!,
        //                                                    assetDownloadDelegate: self,
        //                                                    delegateQueue: OperationQueue.main)
        
        if let url = URL(string: videoUrl){
            let asset = AVURLAsset(url: url)
            // Create new AVAssetDownloadTask for the desired asset
            let downloadTask = downloadSession?.makeAssetDownloadTask(asset: asset,
                                                                      assetTitle: "Some Title",
                                                                      assetArtworkData: nil,
                                                                      options: nil)
            print("PAUSE -------------")
            downloadTask?.suspend()
        }
    }
    
    private func restorePendingDownloads() {
        // Create session configuration with ORIGINAL download identifier
        configuration = URLSessionConfiguration.background(withIdentifier: downloadIdentifier)
        
        // Create a new AVAssetDownloadURLSession
        downloadSession = AVAssetDownloadURLSession(configuration: configuration!,
                                                    assetDownloadDelegate: self,
                                                    delegateQueue: OperationQueue.main)
        
        // Grab all the pending tasks associated with the downloadSession
        downloadSession!.getAllTasks { tasksArray in
            // For each task, restore the state in the app
            for task in tasksArray {
                guard let downloadTask = task as? AVAssetDownloadTask else { break }
                // Restore asset, progress indicators, state, etc...
                _ = downloadTask.urlAsset
            }
        }
    }
    
}
