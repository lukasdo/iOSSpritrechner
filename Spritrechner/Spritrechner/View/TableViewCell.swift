//
//  TableViewCell.swift
//  Spritrechner
//
//  Created by Lukas on 19.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell, UITextFieldDelegate {
    
    
    var station: Station?
    var descriptionLabel: String?
    
    var descr: String? {
        didSet {
            textLabel?.text = self.descr
        }
    }
    
    
    lazy var priceLabel: UILabel = {
        let textfield = UILabel()
        var textl = String(station?.price ?? 0.00 )
        textl.remove(at: textl.index(before: textl.endIndex))
        textl = textl + "\u{2079}"
        
        textfield.text = textl
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = UIFont.boldSystemFont(ofSize: 18)
        return textfield
    }()
    
    lazy var nameLabel: UILabel = {
        let textfield = UILabel()
        var text = ""
        if station?.brand != "" && station!.brand.count < 32 {
            text = station!.brand
        } else {
            text = station!.name
        }
        textfield.text = text.maxLength(length: 13)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var addressLabel: UILabel = {
        let textfield = UILabel()
        let text1 = station?.street ?? "Tankstelle"
        let text2 = station?.houseNumber ?? " "
        let text3 = station?.place ?? " "
        let text = text1 + " " + text2 + ", " + text3
        
        textfield.font = UIFont.systemFont(ofSize: 12)
        textfield.text = text.maxLength(length: 40)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var distanceLabel: UILabel = {
        let textfield = UILabel()
        textfield.text = String(station?.dist ?? 0.0) + " km"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        station = gv_station
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if station != nil {
            addSubview(priceLabel)
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            priceLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            
            
            addSubview(nameLabel)
            nameLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor, constant: -10).isActive = true
            nameLabel.leftAnchor.constraint(equalTo:  priceLabel.rightAnchor, constant: 12).isActive = true
            addSubview(addressLabel)
            addressLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor, constant: 10).isActive = true
            addressLabel.leftAnchor.constraint(equalTo: priceLabel.rightAnchor, constant: 12).isActive = true
            
            addSubview(distanceLabel)
            distanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            distanceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String {
    func maxLength(length: Int) -> String {
        var str = self
        let nsString = str as NSString
        if nsString.length >= length {
            str = nsString.substring(with:
                NSRange(
                    location: 0,
                    length: nsString.length > length ? length : nsString.length)
            )
            str = str + ".."
        }
        return  str
    }
}
