//
//  API.swift
//  Spritrechner
//
//  Created by Lukas on 07.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//https://app.quicktype.io

import Foundation
import UIKit
import MapKit

enum APIError: Error {
    case responseProblem
    case decodingProblem
    case otherProblem
}

class APIRequest {
    
    var stations: [Station]?
    
    let resourceURL: URL
    init(lat: CLLocationDegrees, long: CLLocationDegrees, rad: Int, type: Sprit, apikey: String){
        guard let url = URL(string: "https://creativecommons.tankerkoenig.de/json/list.php?lat=\(lat)&lng=\(long)&rad=\(rad)&sort=dist&type=\(type)&apikey=\(apikey)") else {fatalError()}
        self.resourceURL = url
    }
    
    func fetch(){
             var urlRequ = URLRequest(url: resourceURL)
            urlRequ.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: urlRequ) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    let jsonData = data
                    else {
                        print("ResponseProblem")
                        return
                }
                do{
                    let messageData = try JSONDecoder().decode(PriceQuery.self, from: jsonData)
                    if messageData.ok == true {
                        self.stations = messageData.stations
                        NotificationCenter.default.post(name: Notification.Name(gc_fetchMsg), object: nil)
                    }
                }catch{
                    print(error)
                    print("DecoingProb")
                }
            }
            task.resume()
        }
        
        
    
}



struct PriceQuery: Codable {
    let ok: Bool
    let license, data, status: String
    let stations: [Station]
}

// MARK: - Station
struct Station: Codable {
    let id, name, brand, street: String
    let place: String
    let lat, lng, dist: Double
    let price: Double?
    let isOpen: Bool
    let houseNumber: String
    let postCode: Int
}


