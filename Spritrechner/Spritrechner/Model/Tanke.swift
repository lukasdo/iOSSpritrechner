//
//  TankeViewController.swift
//  Spritrechner
//
//  Created by Lukas on 06.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Tanke: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    let id: String
    
    //let brand: String;
    //let diesel: String;
    //let dist: String;
    //let e10: String
    //let e5: String
    //let houseNumber: String
    //let id: String
    //let isOpen: Int
    //let lat: String
    //let lng: String
    //let name: String
    //let place: String
    //let postCode: Int
    //let street: String
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D, id: String) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        self.id = id
        
        super.init()
    }
    
    
    var subtitle: String? {
        return locationName
    }
}
