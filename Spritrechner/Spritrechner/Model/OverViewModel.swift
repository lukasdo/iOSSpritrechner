//
//  OverViewModel.swift
//  Spritrechner
//
//  Created by Lukas on 26.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//

import Foundation

enum OverViewSection: Int, CaseIterable, CustomStringConvertible {
    case Fuel
    case Maps
    
    var description: String {
        switch self {
        case .Fuel: return "Fuel"
        case .Maps: return "Maps"
            
            //        case .Elektro: return "Elektro"
        }
    }
}

enum FuelOverViewSec: Int, CaseIterable, CustomStringConvertible {
    case E5
    case E10
    case Diesel
    
    var description: String {
        switch self {
        case .E5: return "E5"
        case .E10: return "E10"
        case .Diesel: return "Diesel"
            //        case .Elektro: return "Elektro"
        }
    }
}

enum MapOverViewSec: Int, CaseIterable, CustomStringConvertible {
    case Route
    case Maps
    
    var description: String {
        switch self {
        case .Route: return "Display Route"
        case .Maps: return "Open in Maps"
            
            //        case .Elektro: return "Elektro"
        }
    }
}

