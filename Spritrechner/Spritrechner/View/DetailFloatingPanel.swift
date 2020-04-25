//
//  DetailFloatingPanel.swift
//  Spritrechner
//
//  Created by Lukas on 23.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//

import FloatingPanel
import UIKit

class MyFloatingPanelLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        //                case .full: return 16.0 // A top inset from safe area
        case .half: return 216.0 // A bottom inset from the safe area
        case .tip: return 44.0 // A bottom inset from the safe area
        default: return nil // Or `case .hidden: return nil`
        }
    }
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .tip]
    }
}
