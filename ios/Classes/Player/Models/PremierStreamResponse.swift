//
//  PremierStreamResponse.swift
//  udevs_video_player
//
//  Created by Udevs on 07/10/22.
//

import Foundation

struct PremierStreamResponse: Decodable {
    var file_info : [FileInfo]?
}

struct FileInfo: Decodable{
    var quality: String?
    var file_name: String?
    var duration: Int?
    var width: Int?
    var height: Int?
}
