//
//  PlayButton.swift
//  udevs_video_player
//
//  Created by Udevs on 23/10/22.
//

import Foundation

@IBDesignable
class PlayButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        shared()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        shared()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        shared()
    }
    
    func shared() {
        self.setImage(Svg.play.uiImage, for: .normal)
        self.tintColor = .white
        self.layer.zPosition = 5
        self.imageView?.contentMode = .scaleAspectFit
        self.imageEdgeInsets = UIEdgeInsets(top: Constants.controlButtonInset, left: Constants.controlButtonInset, bottom: Constants.controlButtonInset, right: Constants.controlButtonInset)
        self.size(CGSize(width: 48, height: 48))
    }
    
}
