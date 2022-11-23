//
//  DownloadConfiguration.swift
//  udevs_video_player
//
//  Created by Udevs on 23/11/22.
//

import Foundation

struct DownloadConfiguration {
    var url: String
    init(url: String) {
        self.url = url
    }
    static func fromMap(map : [String:Any]) -> DownloadConfiguration {
        return DownloadConfiguration(url: map["url"] as! String)
    }
}
