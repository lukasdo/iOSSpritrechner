//
//  SettingsModel.swift
//  Spritrechner
//
//  Created by Lukas on 15.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//

import Foundation


protocol SectionType: CustomStringConvertible {
    var containsSeg: Bool { get }
    var containsNumberField: Bool { get }
    
    var containSlider: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Fuel
    case General
    
    var description: String {
        switch self {
        case .Fuel: return "Fuel"
        case .General: return "General"

//        case .Elektro: return "Elektro"
        }
    }
}

enum FuelOptions: Int, CaseIterable, SectionType {
  
    

    case GasType
//    case Tank
//    case Average
//
    var containsSeg: Bool {
        switch  self {
        case .GasType : return true
        default: return false
        }
    }
    
    var containsNumberField: Bool {
        switch  self {
//        case .Average : return true
        default: return false
        }
    }
    
    var containSlider: Bool {
        switch self {
//        case .Tank:
//            return true
        default:
            return false
        }
    }
    
    var description: String {
        switch self {
        case .GasType: return "Gas Type"
//        case .Tank: return "Tank"
//        case .Average: return "Average Consumption"
        }
    }
}

enum GeneralOptions: Int, CaseIterable, SectionType {

    case Range
    case Sort
//    case SortDescr
    
    var containsNumberField: Bool {
        return false
    }
    
    var containsSeg: Bool {
        switch  self {
        case .Sort: return true
//        case .SortDescr: return false
        default: return false
          }
      }
    var containSlider: Bool {
           switch self {
           case .Range: return true
           default: return false
           }
       }
    
    var description: String {
        switch self {
        case .Range: return "Range"
        case .Sort: return "Sortieren nach:"
//        case .SortDescr: return ""
        }
    }
}
