import Foundation
import AVKit
import AVFoundation
import Flutter
import UIKit

class VideoPlayerView: NSObject, FlutterPlatformView {
    private var viewId: Int64
    private var videoView : UIView
    private var videoViewController: VideoViewController
    private var _methodChannel: FlutterMethodChannel
    
    func view() -> UIView {
        return videoView
    }
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        registrar: FlutterPluginRegistrar
    ) {
        self.viewId = viewId
        self.videoView = UIView(frame: frame)
        let viewController = VideoViewController()
        viewController.registrar = registrar
        self.videoViewController = viewController
        _methodChannel = FlutterMethodChannel(name: "plugins.udevs/video_player_view_\(viewId)", binaryMessenger: registrar.messenger())

        super.init()
        // iOS views can be created here
        _methodChannel.setMethodCallHandler(onMethodCall)
    }
    
    deinit {
        self.videoViewController.dismiss(animated: true)
        NotificationCenter.default.removeObserver(self)
        self._methodChannel.setMethodCallHandler(nil)
    }


    func onMethodCall(call: FlutterMethodCall, result: FlutterResult) {
        switch(call.method){
        case "setUrl":
            setText(call:call, result:result)
        case "setAssets":
            setAssets(call:call, result:result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func setText(call: FlutterMethodCall, result: FlutterResult){
        let arguments = call.arguments as? [String:Any]
        if let args = arguments {
            let videoPath: String? = args["url"] as? String
            let sourceType: String? = args["resizeMode"] as? String
            self.videoViewController.videoGravity = videoGravity(s: sourceType)
            self.videoViewController.url = videoPath ?? ""
            videoView.addSubview(videoViewController.view)
            result(nil)
        }
    }
    
    func setAssets(call: FlutterMethodCall, result: FlutterResult){
        let arguments = call.arguments as? [String:Any]
        if let args = arguments {
            let videoPath: String? = args["url"] as? String
            let sourceType: String? = args["resizeMode"] as? String
            self.videoViewController.assets = videoPath ?? ""
            self.videoViewController.videoGravity = videoGravity(s: sourceType)
            videoView.addSubview(videoViewController.view)
            result(nil)
        }
    }
    
    func videoGravity(s:String?) -> AVLayerVideoGravity{
        switch(s){
        case "fit":
            return .resizeAspect
        case "fill":
            return .resizeAspectFill
        case "zoom":
            return .resize
        default:
            return .resizeAspect
        }
    }
}

class VideoViewController: UIViewController {
    
    var registrar: FlutterPluginRegistrar?
    var assets: String = ""
    var url: String = ""
    var videoGravity: AVLayerVideoGravity = .resizeAspect
    
    lazy private var player = AVPlayer()
    lazy private var playerLayer = AVPlayerLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
    }
    
    func playVideo() {
        var videoURL : URL
        if url.isEmpty {
            let key = self.registrar?.lookupKey(forAsset: assets)
            guard let path = Bundle.main.path(forResource: key, ofType: nil) else {
                debugPrint("video not found")
                return
            }
            videoURL = URL(fileURLWithPath: path)
        } else {
            videoURL = URL(string: url)!
        }
        player.automaticallyWaitsToMinimizeStalling = true
        player.replaceCurrentItem(with: AVPlayerItem(asset: AVURLAsset(url: videoURL)))
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = videoGravity
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    deinit {
        playerLayer.removeFromSuperlayer()
        player.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        playerLayer.removeFromSuperlayer()
        player.pause()
        NotificationCenter.default.removeObserver(self)
    }
}
