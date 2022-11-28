import Flutter
import AVFoundation
import AVFAudio
import UIKit

public class SwiftUdevsVideoPlayerPlugin: NSObject, FlutterPlugin, VideoPlayerDelegate {
    
    public static var viewController = FlutterViewController()
    private var flutterResult: FlutterResult?
    private static var channel : FlutterMethodChannel?
    
    fileprivate let downloadIdentifier = "\(Bundle.main.bundleIdentifier!).background"
    var totalDownloadedBytes: Int64 = 0
    /// The AVAssetDownloadURLSession to use for managing AVAssetDownloadTasks.
    fileprivate var assetDownloadURLSession: AVAssetDownloadURLSession!
    /// Internal map of AVAggregateAssetDownloadTask to its corresponding Asset.
    fileprivate var activeDownloadsMap = [AVAggregateAssetDownloadTask: MediaItemDownload]()
    
    /// Internal map of AVAggregateAssetDownloadTask to download URL.
    fileprivate var willDownloadToUrlMap = [AVAggregateAssetDownloadTask: MediaItemDownload]()
    
    override private init(){
        super.init()
        let configuration = URLSessionConfiguration.background(withIdentifier: downloadIdentifier)
        // Create a new AVAssetDownloadURLSession with background configuration, delegate, and queue
        assetDownloadURLSession = AVAssetDownloadURLSession(configuration: configuration,
                                                            assetDownloadDelegate: self,
                                                            delegateQueue: OperationQueue.main)
    }
    
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
            setupAssetDownload(download: download)
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
            pauseDownload(for: download)
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
            resumeDownload(for: download)
            return
        }
        case "getStateDownload": do {
            guard let args = call.arguments else {
                return
            }
            guard let json = convertStringToDictionary(text: (args as! [String:String])["downloadConfigJsonString"] ?? "") else {
                return
            }
            let download : DownloadConfiguration = DownloadConfiguration.fromMap(map: json)
            getStateDownload(for: download)
            return
        }
        case "getBytesDownloaded": do {
            guard let args = call.arguments else {
                return
            }
            guard let json = convertStringToDictionary(text: (args as! [String:String])["downloadConfigJsonString"] ?? "") else {
                return
            }
            let download : DownloadConfiguration = DownloadConfiguration.fromMap(map: json)
            getStateDownload(for: download)
            return
        }
        case "getContentBytesDownload": do {
            guard let args = call.arguments else {
                return
            }
            guard let json = convertStringToDictionary(text: (args as! [String:String])["downloadConfigJsonString"] ?? "") else {
                return
            }
            let download : DownloadConfiguration = DownloadConfiguration.fromMap(map: json)
            getStateDownload(for: download)
            return
        }
        case "checkIsDownloadedVideo": do {
            guard let args = call.arguments else {
                return
            }
            guard let json = convertStringToDictionary(text: (args as! [String:String])["downloadConfigJsonString"] ?? "") else {
                return
            }
            let download : DownloadConfiguration = DownloadConfiguration.fromMap(map: json)
            isDownloadVideo(for: download)
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
        flutterResult!(Int(duration))
    }
    
    private func getPercentComplete(download: MediaItemDownload){
        SwiftUdevsVideoPlayerPlugin.channel?.invokeMethod("percent", arguments: download.fromString())
    }
    
    /// is download video
    private func isDownloadVideo(for download: DownloadConfiguration){
        assetDownloadURLSession.getAllTasks { tasksArray in
            // For each task, restore the state in the app by recreating Asset structs and reusing existing AVURLAsset objects.
            for task in tasksArray {
                guard let assetDownloadTask = task as? AVAggregateAssetDownloadTask else { break }
                let urlAsset = assetDownloadTask.urlAsset
                if urlAsset.url.absoluteString == download.url {
                    self.flutterResult!(true)
                    break
                }
            }
        }
        flutterResult!(false)
    }
    
    /// get state download
    private func getStateDownload(for download: DownloadConfiguration){
        var task: AVAggregateAssetDownloadTask?
        for (taskKey, assetVal) in activeDownloadsMap where (download.url == assetVal.url) {
            task = taskKey
            break
        }
        flutterResult!(task?.state ?? MediaItemDownload.STATE_FAILED)
    }
    
    /// download an AVAssetDownloadTask given an Asset.
    /// - Tag: DownloadDownload
    private func setupAssetDownload(download: DownloadConfiguration) {
        guard UserDefaults.standard.value(forKey: download.url) is String else {
            // Create new background session configuration.
            if let url = URL(string: download.url) {
                let asset = AVURLAsset(url: url)
                // Get the default media selections for the asset's media selection groups.
                let preferredMediaSelection = asset.preferredMediaSelection
                // Create new AVAssetDownloadTask for the desired asset
                guard let downloadTask = assetDownloadURLSession.aggregateAssetDownloadTask(with: asset, mediaSelections: [preferredMediaSelection],
                                                                                            assetTitle: "Some Title",
                                                                                            assetArtworkData: nil,
                                                                                            options:  [AVAssetDownloadTaskMinimumRequiredMediaBitrateKey: 265_000]) else { return }
                downloadTask.taskDescription = asset.description
                activeDownloadsMap[downloadTask] = MediaItemDownload(url: download.url, percent: 0, state: MediaItemDownload.STATE_RESTARTING)
                downloadTask.resume()
            }
            return
        }
        getPercentComplete(download: MediaItemDownload(url: download.url, percent: 100, state: MediaItemDownload.STATE_COMPLETED))
    }
    
    /// Cancels an AVAssetDownloadTask given an Asset.
    /// - Tag: CancelDownload
    func cancelDownload(for asset: MediaItemDownload) {
        var task: AVAggregateAssetDownloadTask?
        
        for (taskKey, assetVal) in activeDownloadsMap where (asset.url == assetVal.url) {
            task = taskKey
            break
        }
        
        task?.cancel()
    }
    
    /// suspend an AVAssetDownloadTask given an Asset.
    /// - Tag: SuspendDownload
    func pauseDownload(for asset: DownloadConfiguration) {
        var task: AVAggregateAssetDownloadTask?
        for (taskKey, assetVal) in activeDownloadsMap where asset.url == assetVal.url {
            task = taskKey
            break
        }
        task?.suspend()
    }
    
    /// Resume an AVAssetDownloadTask given an Asset.
    /// - Tag: ResumeDownload
    func resumeDownload(for asset: DownloadConfiguration) {
        var task: AVAggregateAssetDownloadTask?
        for (taskKey, assetVal) in activeDownloadsMap where asset.url == assetVal.url {
            task = taskKey
            break
        }
        task?.resume()
    }
}

/**
 Extend `SwiftUdevsVideoPlayerPlugin` to conform to the `AVAssetDownloadDelegate` protocol.
 */
extension SwiftUdevsVideoPlayerPlugin: AVAssetDownloadDelegate {

    /// Tells the delegate that the task finished transferring data.
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
       
    }

    /// Method called when the an aggregate download task determines the location this asset will be downloaded to.
    public func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask,
                    willDownloadTo location: URL) {
        UserDefaults.standard.set(location.relativePath, forKey: "\(aggregateAssetDownloadTask.urlAsset.url.absoluteURL)")
        self.getPercentComplete(download: MediaItemDownload(url: aggregateAssetDownloadTask.urlAsset.url.absoluteString, percent: 100, state: MediaItemDownload.STATE_COMPLETED))
    }

    /// Method called when a child AVAssetDownloadTask completes.
    public func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask,
                    didCompleteFor mediaSelection: AVMediaSelection) {
        /*
         This delegate callback provides an AVMediaSelection object which is now fully available for
         offline use. You can perform any additional processing with the object here.
         */

        guard let asset = activeDownloadsMap[aggregateAssetDownloadTask] else { return }

    }

    /// Method to adopt to subscribe to progress updates of an AVAggregateAssetDownloadTask.
    public func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask,
                    didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue],
                    timeRangeExpectedToLoad: CMTimeRange, for mediaSelection: AVMediaSelection) {
        guard activeDownloadsMap[aggregateAssetDownloadTask] != nil else { return }
        var percentComplete = 0.0
        for value in loadedTimeRanges {
            let loadedTimeRange: CMTimeRange = value.timeRangeValue
            percentComplete +=
                loadedTimeRange.duration.seconds / timeRangeExpectedToLoad.duration.seconds
        }
        percentComplete *= 100
        print(percentComplete)
        self.getPercentComplete(download: MediaItemDownload(url: aggregateAssetDownloadTask.urlAsset.url.absoluteString, percent: Int(percentComplete), state: MediaItemDownload.STATE_DOWNLOADING))
    }
}

