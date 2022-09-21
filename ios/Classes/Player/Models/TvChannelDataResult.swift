//
//  TvChannelDataResult.swift
//  Runner
//
//  Created by Udevs on 24/08/22.
//

import Foundation

struct TvChannelDataResult{
    var title, url : String?
    var has: Bool
    var resolutions : [String: String]
    var programmes: TvProgrammes
    
    init(title : String, url :String, has: Bool, resolutions : [String:String], programmes: TvProgrammes){
        self.title = title
        self.has = has
        self.url = url
        self.resolutions = resolutions
        self.programmes = programmes
    }
    
    static func fromMap(map : [String:Any])->TvChannelDataResult {
        return TvChannelDataResult(title: map["title"] as! String, url: map["url"] as! String, has: (map["has"] != nil),   resolutions:map["resolutions"] as! [String: String], programmes: TvProgrammes.fromMap(map: map["programs_info"]as![String:Any]))
    }
}

struct TvProgrammes {
    var day:String?
    var programmes: [Programme]
    
    init(day: String, programmes: [Programme]) {
        self.day = day
        self.programmes = programmes
    }
    
    static func fromMap(map : [String:Any])->TvProgrammes {
        var tempProgrammes: [Programme] = []
        if map["programme"] != nil {
            (map["programme"] as! [[String:Any]]).forEach { item in
                tempProgrammes.append(Programme.fromMap(map: item))
            }
        }
        return TvProgrammes(day: map["day"] as! String, programmes: tempProgrammes)
    
    }
    
}

struct Programme {
    var title, description,startTime,endTime:String?
    var isAvailable: Bool?
    
    init(title:String,description:String,startTime:String,endTime:String,isAvailable:Bool) {
        self.title = title
        self.isAvailable = isAvailable
        self.startTime = startTime
        self.endTime = endTime
        self.description = description
    }
    
    static func fromMap(map : [String:Any])->Programme {
        return Programme(
            title:map["title"] as! String,
            description:map["description"] as! String,
            startTime:map["start_time"] as! String,
            endTime: map["end_time"] as! String,
            isAvailable:map["is_available"] as! Bool
            )
    }
}
