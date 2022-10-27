////
////  CustomPlayerViewController.swift
////  udevs_video_player
////
////  Created by Udevs on 24/10/22.
////
//
//import Foundation
//import AVKit
//
//class CustomAVPlayerViewController : AVPlayerViewController {
//    private var exitButton: ExitButton = {
//        let button = ExitButton()
//        button.addTarget(self, action: #selector(exitButtonPressed(_:)), for: .touchUpInside)
//        return button
//    }()
//    
//    func addControls() {
//        self.showsPlaybackControls = false
//        //PLAY BUTTON
//        let btnPlayRect = CGRect(x: 0, y: 0, width: 19, height: 25)
//       self.view.addSubview(exitButton)
//    }
//    
//    @objc func exitButtonPressed(_ sender: UIButton){
//        self.dismiss(animated: true, completion: nil);
//    }
//}
