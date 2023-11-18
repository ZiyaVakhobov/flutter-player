import Foundation
import AVFoundation
import Flutter
import UIKit

class FlutterWebView: NSObject, FlutterPlatformView {
    private var viewId: Int64
    private var videoView : VideoView
    private var requestAudioFocus: Bool = true
    private var mute: Bool = false
    private var volume: Double = 1.0
    private var _methodChannel: FlutterMethodChannel
    
    func view() -> UIView {
        return videoView
    }
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        self.viewId = viewId
        self.videoView = VideoView(frame: frame)
        _methodChannel = FlutterMethodChannel(name: "plugins.udevs/video_player_view_\(viewId)", binaryMessenger: messenger)

        super.init()
        self.videoView.addOnPreparedObserver {
            [weak self] () -> Void in
//            self.onPrepared()
        }
        self.videoView.addOnFailedObserver {
            [weak self] (message: String) -> Void in
//            self.onFailed(message: message)
        }
        self.videoView.addOnCompletionObserver {
            [weak self] () -> Void in
//            self.onCompletion()
        }
        // iOS views can be created here
        _methodChannel.setMethodCallHandler(onMethodCall)

    }
    
    deinit {
        self._methodChannel.setMethodCallHandler(nil)
        NotificationCenter.default.removeObserver(self)
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
        let url = call.arguments as! [String:String]
//        
//        _nativeWebView.loadRequest(NSURLRequest(url: NSURL(string: "https://flutter.dev/development")! as URL) as URLRequest)
    }
    
    func setAssets(call: FlutterMethodCall, result: FlutterResult){
        let arguments = call.arguments as? [String:Any]
        if let args = arguments {
        let videoPath: String? = args["url"] as? String
        let sourceType: String? = args["resizeMode"] as? String
//        let requestAudioFocus: Bool? = args["requestAudioFocus"] as? Bool
//        self.requestAudioFocus = requestAudioFocus ?? false
        if let path = videoPath {
            print(path)
            self.configurePlayer()
            self.videoView.configure(videoPath: path, isURL: false)
          }
        }
        result(nil)
    }
    
    func configurePlayer(){
        self.handleAudioFocus()
        self.configureVolume()
    }
    
    func handleAudioFocus(){
          do {
              if requestAudioFocus {
                  try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
              } else {
                  try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
              }
              try AVAudioSession.sharedInstance().setActive(true)
          } catch {
              print(error)
          }
      }

      func configureVolume(){
          if mute {
              self.videoView.setVolume(volume: 0.0)
          } else {
              self.videoView.setVolume(volume: volume)
          }
      }
}
