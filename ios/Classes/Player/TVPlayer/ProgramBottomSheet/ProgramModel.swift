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
            
            programMap  = programInfo["tvPrograms"] as! [Dictionary<String, Any>]?
            
            programMap?.forEach({ data in
                let programs = Programms(scheduledTime: data["scheduledTime"] as? String ?? "", programTitle: data["programTitle"] as? String ?? "")
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
    var scheduledTime,programTitle:String
    
    init(scheduledTime:String, programTitle: String){
        self.scheduledTime = scheduledTime
        self.programTitle = programTitle
    }
}
