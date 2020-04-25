//
//  OverViewCell.swift
//  Spritrechner
//
//  Created by Lukas on 26.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//

import MapKit
import UIKit

var gv_overViewSection: OverViewSection!
var gv_overViewFuel: FuelOverViewSec!
var gv_overViewMaps: MapOverViewSec!
var gv_stationDetail: StationDetail!


protocol OverviewCellProtocol {
    func exitDetailPanel()
    func displayRoute(coordinate: CLLocationCoordinate2D)
    func openInMaps(coordinate: CLLocationCoordinate2D)
}

class OverVieCell: UITableViewCell, UITextFieldDelegate {
    
    var overViewDelegate: OverviewCellProtocol?
    var station: StationDetail?
    var descriptionLabel: String?
    var Section: OverViewSection?
    var row: Int?
    
    var descr: String? {
        didSet {
            textLabel?.text = self.descr
        }
    }
    
    
    lazy var priceLabel: UILabel = {
        let textfield = UILabel()
        var textl = ""
        switch gv_overViewFuel {
        case .Diesel: textl = String(station?.diesel ?? 0)
        case .E10: textl = String(station?.e10 ?? 0)
        case .E5: textl = String(station?.e5 ?? 0)
            default: textl = "0.00"
        }
        textl.remove(at: textl.index(before: textl.endIndex))
        textl = textl + "\u{2079}"
        
        textfield.text = textl
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = UIFont.boldSystemFont(ofSize: 16.0)
        return textfield
    }()
    
    lazy var nameLabel: UILabel = {
        let textfield = UILabel()
        var text:String
        switch gv_overViewSection {
        case .Fuel:
            text = gv_overViewFuel.description
        case .Maps:
            text = gv_overViewMaps.description
        default: text = ""
        }
        textfield.text = text
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let forwardImage: UIImageView = {
           let iv = UIImageView()
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           iv.translatesAutoresizingMaskIntoConstraints = false
           iv.image = UIImage(named: "forward")
           return iv
       }()
    
    func forwardButton() -> UIButton {
        let button = UIButton()
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        var image  = UIImage(named: "forward")
        image = image?.withTintColor(UIColor.systemBlue)
        iv.image = image!
       
        button.setImage(iv.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        station = gv_stationDetail
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        if station != nil {
            
            if gv_overViewSection == .Fuel {
                
                addSubview(priceLabel)
                priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                priceLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
                
                addSubview(nameLabel)
                nameLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor).isActive = true
                nameLabel.leftAnchor.constraint(equalTo:  priceLabel.rightAnchor, constant: 12).isActive = true
            }else {
                addSubview(nameLabel)
                nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
                
                let forwardBTN = forwardButton()
                if gv_overViewMaps.rawValue == 0 {
                    forwardBTN.addTarget(self, action: #selector(displayRoute), for: .touchUpInside)
                } else {
                    forwardBTN.addTarget(self, action: #selector(displayRouteMaps), for: .touchUpInside)
                }
                addSubview(forwardBTN)
                forwardBTN.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                forwardBTN.leftAnchor.constraint(equalTo: rightAnchor, constant: -35).isActive = true
                
                
            }
            
            
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func displayRoute() {
        // Display Route
        var coordinate:CLLocationCoordinate2D
        coordinate = CLLocationCoordinate2DMake(self.station!.lat, self.station!.lng)
        overViewDelegate?.displayRoute(coordinate: coordinate)
        
    }

    @objc func displayRouteMaps() {
        
        var coordinate:CLLocationCoordinate2D
        coordinate = CLLocationCoordinate2DMake(self.station!.lat, self.station!.lng)
        overViewDelegate?.openInMaps(coordinate: coordinate)
        
    }
}



