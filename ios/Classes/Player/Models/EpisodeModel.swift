//
//  EpisodeModel.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//

import Foundation

struct Seasons{
    
    var id,title, seasonNumber,plot, releaseYear,active,isSelected : String
    var episodeList = [Episodes]()
    init(id:String, title:String,seasonNumber :String,plot: String,releaseYear: String,active :String,isSelected: String, episodes: [Episodes]){
        self.id = id
        self.seasonNumber = seasonNumber
        self.plot = plot
        self.releaseYear = releaseYear
        self.active = active
        self.isSelected = isSelected
        self.episodeList = episodes
        self.title = title
    }
    
    static func fromDictinary(map: [Dictionary<String, Any>])-> [Seasons]{
        var seasons : [Seasons] = []
        map.forEach({seasonsData in
            var episodes :[Episodes] = []
            var episodesMap: [Dictionary<String, Any>]?
            
            episodesMap  = seasonsData["episodes"] as! [Dictionary<String, Any>]?
            
            episodesMap?.forEach({ data in
                var videos :[Videos] = []
                var videosMap: [Dictionary<String, Any>]?
                let fileInfo = data["file_info"] as! Dictionary<String, Any>
                videosMap = fileInfo["videos"] as! [Dictionary<String, Any>]?
                videosMap?.forEach({ videoData in
                    let video = Videos(fileName: videoData["file_name"] as? String ?? "", quality: videoData["quality"] as? String ?? "", duration: videoData["duration"] as? Int ?? 0)
                    videos.append(video)
                })
                
                let episode = Episodes(id: data["id"] as? String ?? "", episodeNumber: data["episode_number"] as? String ?? "", title: data["title"] as? String ?? "", logoImage: data["logo_image"] as? String ?? "", plot: data["plot"] as? String ?? "", description: data["description"] as? String ?? "", active: data["active"] as? String ?? "", rating: data["rating"] as? String ?? "", access: data["access"] as? String ?? "", seconds: data["seconds"] as? String ?? "", fileIMage: data["rating"] as? String ?? "",fileDuration: data["rating"] as? String ?? "",videos: videos)
                episodes.append(episode)
            })
            
            let season = Seasons(
                id: seasonsData["id"] as? String ?? "",title: "", seasonNumber: seasonsData["season_number"] as? String ?? "", plot: seasonsData["plot"] as? String ?? "", releaseYear: seasonsData["release_year"] as? String ?? "", active: "", isSelected: "", episodes: episodes)
            seasons.append(season)
        })
        return seasons
    }
}

struct Episodes{
    var id, episodeNumber,title, logoImage,plot,description,active,rating,access,seconds,fileIMage,fileDuation : String
    var videos: [Videos]
    init(id:String, episodeNumber :String,title: String,logoImage: String,plot :String,description: String, active: String,rating:String,access:String,seconds:String, fileIMage: String,fileDuration: String, videos:[Videos]){
        self.id = id
        self.episodeNumber = episodeNumber
        self.title = title
        self.logoImage = logoImage
        self.plot = plot
        self.description = description
        self.access = access
        self.active = active
        self.seconds = seconds
        self.rating = rating
        self.fileIMage = fileIMage
        self.fileDuation = fileDuration
        self.videos = videos
        
    }
}

struct FileInfo{
    var image,duration : String
    init(image:String,duration: String){
        self.image = image
        self.duration = duration
    }
}
struct Videos {
    var fileName, quality: String
    var duration : Int
    init(fileName:String, quality: String, duration: Int){
        self.fileName = fileName
        self.quality = quality
        self.duration = duration
    }
}


