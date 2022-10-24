//
//  ViewController.swift
//  PictureinPictureApp
//
//  Created by macbookpro on 12.06.2019.
//  Copyright © 2019 halilozel. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit

class PlayerViewController: UIViewController, AVPlayerViewControllerDelegate {
    
    var playerConfg : PlayerConfiguration!
    var playerController : CustomAVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        play(url: playerConfg.url)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func play(url:String){
        guard let url = URL(string: url) else { return }
        let player = AVPlayer(url: url)
        playerController = CustomAVPlayerViewController()
        NotificationCenter.default.addObserver(self, selector: #selector(didfinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        playerController.player = player
        playerController.allowsPictureInPicturePlayback = true
        playerController.showsPlaybackControls = true
        playerController.delegate = self
        addChild(playerController)
        view.addSubview(playerController.view)
        playerController.player?.play()
    }
    
    @objc func didfinishPlaying(note : NSNotification)  {
        playerController.dismiss(animated: true, completion: nil)
        let alertView = UIAlertController(title: "Finished", message: "Video finished", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        let currentviewController = navigationController?.visibleViewController
        if currentviewController != playerViewController{
            currentviewController?.present(playerViewController, animated: true, completion: nil)
        }
    }
}
