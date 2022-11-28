//
//  DownloadConfiguration.swift
//  udevs_video_player
//
//  Created by Udevs on 23/11/22.
//

import Foundation

struct DownloadConfiguration {
    var url: String
    var percent: Int
    
    init(url: String, percent: Int) {
        self.url = url
        self.percent = percent
    }
    
    static func fromMap(map : [String:Any]) -> DownloadConfiguration {
        return DownloadConfiguration(url: map["url"] as! String, percent: map["percent"] as! Int)
    }
    
    func fromString() -> String {
        do {
            let data1 = try JSONSerialization.data(withJSONObject: ["url": url, "percent":percent], options: JSONSerialization.WritingOptions.prettyPrinted)
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) ?? ""
            return convertedString
        } catch _ {
            return ""
        }
    }
}
