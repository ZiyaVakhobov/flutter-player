//
//  ProgramModel.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//

import UIKit

struct ProgramModel {
    var day: String
    var programsList: [Programms]
    
    init(day: String, programsList: [Programms]) {
        self.day = day
        self.programsList = programsList
    }
    
    
    static func fromDictinaryProgramms(map: [Dictionary<String, Any>])-> [ProgramModel]{
        var programInfoMain: [ProgramModel] = []
        map.forEach({programInfo in
            var programList :[Programms] = []
            var programMap: [Dictionary<String, Any>]?
            
            programMap  = programInfo["programme"] as! [Dictionary<String, Any>]?
            
            programMap?.forEach({ data in
                
                let programs = Programms(description: data["description"] as? String ?? "", endTime: data["end_time"] as? String ?? "", startTime: data["start_time"] as? String ?? "", id: data["id"] as? Int ?? 0, isAvailable: data["is_available"] as? Bool ?? false, programTitle: data["title"] as? String ?? "", xmlTitle: data["xml_title"] as? String ?? "")
                programList.append(programs)
            })
            let programInfos = ProgramModel(day: programInfo["day"] as? String ?? "", programsList: programList)
            programInfoMain.append(programInfos)
        })
        print("DAAATAA \(programInfoMain)")
        return programInfoMain
    }
}

struct Programms{
    
    var description,endTime,startTime,programTitle,xmlTitle: String
    var isAvailable: Bool
    var id:Int
    
    init(description:String, endTime: String,startTime: String, id: Int,isAvailable:Bool, programTitle:String,xmlTitle:String){
        self.id = id
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
        self.isAvailable = isAvailable
        self.programTitle = programTitle
        self.xmlTitle = xmlTitle
    }
}
