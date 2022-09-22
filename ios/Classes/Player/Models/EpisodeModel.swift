//
//  EpisodeModel.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//

import Foundation

struct Seasons{
    
    var title : String
    var episodeList = [Episodes]()
    init(title:String,episodes: [Episodes]){
        self.episodeList = episodes
        self.title = title
    }
    
    static func fromDictinary(map: [Dictionary<String, Any>])-> [Seasons]{
        var seasons : [Seasons] = []
        map.forEach({seasonsData in
            var episodes :[Episodes] = []
            var episodesMap: [Dictionary<String, Any>]?
            
            episodesMap  = seasonsData["movies"] as! [Dictionary<String, Any>]?
            
            episodesMap?.forEach({ data in
                var resolutions :[String:String] = [:]
                resolutions = (data["resolutions"] as? [String:String] ?? [:])!
                
                let episode = Episodes(title: data["title"] as? String ?? "", image: data["image"] as? String ?? "", description: data["description"] as? String ?? "", duration: data["duration"] as? Int ?? 0,resolutions: resolutions)
                episodes.append(episode)
            })
            
            let season = Seasons(title: seasonsData["title"] as? String ?? "",episodes: episodes)
            seasons.append(season)
        })
        return seasons
    }
}

struct Episodes{
    var title, image, description : String
    var duration : Int
    var resolutions: [String:String]
    init(title: String,image: String,description: String,duration:Int, resolutions:[String:String]){
        self.title = title
        self.image = image
        self.description = description
        self.duration = duration
        self.resolutions = resolutions
    }
}
//
//struct FileInfo{
//    var image,duration : String
//    init(image:String,duration: String){
//        self.image = image
//        self.duration = duration
//    }
//}
//struct Videos {
//    var fileName, quality: String
//    var duration : Int
//    init(fileName:String, quality: String, duration: Int){
//        self.fileName = fileName
//        self.quality = quality
//        self.duration = duration
//    }
//}
//
//
