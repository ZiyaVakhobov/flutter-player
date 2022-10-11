//
//  Network.swift
//  Pods
//
//  Created by Udevs on 07/10/22.
//

import Foundation
import UIKit

enum NetworkError : Error {
    case NoDataAvailable
    case CanNotProcessData
}


struct Networking {
    static let sharedInstance = Networking()
    let session = URLSession.shared
    
    func getMegogoStream(_ baseUrl:String, token:String, sessionId:String, parameters: [String: String]) -> Result<MegogoStreamResponse, NetworkError> {
        var components = URLComponents(string: baseUrl)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        print("URLLLL")
        print(components.url!)
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Authorization", forHTTPHeaderField: token)
        request.setValue("SessionId", forHTTPHeaderField: sessionId)
        
        var result: Result<MegogoStreamResponse, NetworkError>!
        let semaphore = DispatchSemaphore(value: 0)
        session.dataTask(with: request){data,_,_ in
            guard let json = data else{
                result = .failure(.NoDataAvailable)
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MegogoStreamResponse.self, from: Data(json))
                result = .success(response)
                print("success")
                print(response)
            }
            catch{
                print("success")
                print(json)
                result = .failure(.CanNotProcessData)
            }
            semaphore.signal()
        }.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return result
    }
    
//    func getPremierStream(_ baseUrl:String, token:String, sessionId:String, completion: @escaping(Result<[PremierStreamResponse],Networking>) ->Void) {
//
//        let url = URL(string: baseUrl)!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Authorization", forHTTPHeaderField: token)
//        request.setValue("SessionId", forHTTPHeaderField: sessionId)
//        let dataTask = session.dataTask(with: request){data,_,_ in
//            guard let jsonData = data else{
//                completion(.failure(.NoDataAvailable))
//                return
//            }
//            do{
//                let decoder = JSONDecoder()
//                let userResponse = try decoder.decode([PremierStreamResponse].self,from:jsonData)
//                completion(.success(userResponse))
//            }
//            catch{
//                completion(.failure(.CanNotProcessData))
//            }
//        }
//        dataTask.resume()
//    }
}
