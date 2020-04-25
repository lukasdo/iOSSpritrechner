//
//  APIDetails.swift
//  Spritrechner
//
//  Created by Lukas on 27.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//


import Foundation
import UIKit
import MapKit


class APIDetails {
    
    var stations: [Station]?
    var delegateDetail: DetailPanel!
    
    let resourceURL: URL
    init(id: String, apikey: String){
        guard let url = URL(string: "https://creativecommons.tankerkoenig.de/json/detail.php?id=\(id)&apikey=\(apikey)") else {fatalError()}
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
                     let messageData = try JSONDecoder().decode(DetailQuery.self, from: jsonData)
                    if messageData.ok == true {
                        DispatchQueue.main.async {
                            self.delegateDetail.showDetailApi(station: messageData.station, append: true)
                        }
                    }
                }catch{
                    print(error)
                    print("DecoingProb")
                }
            }
            task.resume()
        
    }
}

// MARK: - Welcome
struct DetailQuery: Codable {
    let ok: Bool
    let license, data, status: String
    let station: StationDetail
}

// MARK: - Station
struct StationDetail: Codable {
    let id, name:String
    let brand: String?
    let street: String?
    let houseNumber: String?
    let postCode: Int?
    let place: String?
    let openingTimes: [OpeningTime]
    let overrides: [String]
    let wholeDay, isOpen: Bool?
    let e5, e10, diesel :Double?
    let lat: Double
    let lng: Double
    let state: String?
}

// MARK: - OpeningTime
struct OpeningTime: Codable {
    let text, start, end: String
}
