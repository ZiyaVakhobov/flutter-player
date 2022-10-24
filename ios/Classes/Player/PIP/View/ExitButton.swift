//
//  PlayButton.swift
//  udevs_video_player
//
//  Created by Udevs on 23/10/22.
//

import Foundation

@IBDesignable
class ExitButton: UIButton {
    
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
        self.setImage(Svg.exit.uiImage, for: .normal)
        self.tintColor = .white
        self.backgroundColor = .clear
        self.imageView?.contentMode = .scaleAspectFit
        self.size(CGSize(width: 48, height: 48))
    }
    
}
