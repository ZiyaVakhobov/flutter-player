//
//  NextVideoResult.swift
//  Runner
//
//  Created by Nuriddin Jumayev on 21/04/22.
//

import Foundation

struct NextVideoResult{
    var title, url : String?
    var has, hasNextVideo: Bool
    var startAt: Int
    var resolutions : [String: String]
    
    init(title : String, url :String, has: Bool, hasNextVideo: Bool, startAt: Int, resolutions : [String:String]){
        self.title = title
        self.hasNextVideo = hasNextVideo
        self.has = has
        self.url = url
        self.startAt = startAt
        self.resolutions = resolutions
    }
    
    static func fromMap(map : [String:Any])->NextVideoResult {
        return NextVideoResult(title: map["title"] as! String, url: map["url"] as! String, has: (map["has"] != nil), hasNextVideo: map["has_next_video"] as! Bool, startAt: map["start_at"] as! Int, resolutions:map["resolutions"] as! [String: String])
    }
}
