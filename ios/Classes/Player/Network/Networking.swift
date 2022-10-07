//
//  Network.swift
//  Pods
//
//  Created by Udevs on 07/10/22.
//

import Foundation
import UIKit

enum UserError : Error {
    case NoDataAvailable
    case CanNotProcessData
}

struct Networking {
    static let sharedInstance = Networking()
    let session = URLSession.shared
    
    func getMegogoStream(_ baseUrl:String, token:String, sessionId:String, parameters: [String: String], completion: @escaping(Result<[MegogoStreamResponse],UserError>) ->Void) {
        
        var components = URLComponents(string: baseUrl)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Authorization", forHTTPHeaderField: token)
        request.setValue("SessionId", forHTTPHeaderField: sessionId)
        let dataTask = session.dataTask(with: request){data,_,_ in
            guard let jsonData = data else{
                completion(.failure(.NoDataAvailable))
                return
            }
            do{
                let decoder = JSONDecoder()
                let userResponse = try decoder.decode([MegogoStreamResponse].self,from:jsonData)
                completion(.success(userResponse))
            }
            catch{
                completion(.failure(.CanNotProcessData))
            }
        }
        dataTask.resume()
    }
    
    func getPremierStream(_ baseUrl:String, token:String, sessionId:String, completion: @escaping(Result<[PremierStreamResponse],UserError>) ->Void) {
        
        let url = URL(string: baseUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Authorization", forHTTPHeaderField: token)
        request.setValue("SessionId", forHTTPHeaderField: sessionId)
        let dataTask = session.dataTask(with: request){data,_,_ in
            guard let jsonData = data else{
                completion(.failure(.NoDataAvailable))
                return
            }
            do{
                let decoder = JSONDecoder()
                let userResponse = try decoder.decode([PremierStreamResponse].self,from:jsonData)
                completion(.success(userResponse))
            }
            catch{
                completion(.failure(.CanNotProcessData))
            }
        }
        dataTask.resume()
    }
}
