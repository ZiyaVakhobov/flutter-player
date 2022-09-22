//
//  VGPlayerUtils.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//


import UIKit
import AVFoundation

public enum VGPlayerMediaFormat : String{
    case unknown
    case mpeg4
    case m3u8
    case mov
    case m4v
    case error
}


class VGPlayerUtils: NSObject {
    static public func playerBundle() -> Bundle {
        return Bundle(for: AVPlayer.self)
    }
    
    static public func fileResource(_ fileName: String, fileType: String) -> String? {
        let bundle = playerBundle()
        let path = bundle.path(forResource: fileName, ofType: fileType)
        return path
    }
    
    static public func imageResource(_ name: String) -> UIImage? {
        let bundle = playerBundle()
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    static func imageSize(image: UIImage, scaledToSize newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage;
    }
    
    static func decoderVideoFormat(_ URL: URL?) -> VGPlayerMediaFormat {
        if URL == nil {
            return .error
        }
        if let path = URL?.absoluteString{
            if path.contains(".mp4") {
                return .mpeg4
            } else if path.contains(".m3u8") {
                return .m3u8
            } else if path.contains(".mov") {
                return .mov
            } else if path.contains(".m4v"){
                return .m4v
            } else {
                return .unknown
            }
        } else {
            return .error
        }
    }
}
