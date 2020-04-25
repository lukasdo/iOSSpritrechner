//
//  SettingsCell.swift
//  Spritrechner
//
//  Created by Lukas on 15.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: - Properties
    var segVal: Int?
    var slidVal: Int?
    var section: SettingsSection?
    var sliderTag: Int? {
        didSet {
            slider.tag = self.sliderTag!
        }
    }
    
    var sectionType: SectionType? {
        didSet {
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            segControl.isHidden = !sectionType.containsSeg
            numberField.isHidden = !sectionType.containsNumberField
            slider.isHidden = !sectionType.containSlider
            sliderField.isHidden = !sectionType.containSlider
            sortSegControl.isHidden = !sectionType.containsSeg
        }
    }
    
    lazy var numberField: UITextField = {
        let textfield = UITextField()
        if let defaultVal = UserDefaults.standard.string(forKey: gc_avgCons) {
            textfield.text = defaultVal
        }
        else {
            let val = 7
            UserDefaults.standard.set( val, forKey: gc_avgCons)
            textfield.text = String(val)
        }
        
        textfield.keyboardType = UIKeyboardType.decimalPad
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        switch self.section {
        case .Fuel:
            slider.maximumValue = 80
            slider.minimumValue = 0
        case .General:
            slider.maximumValue = 30
            slider.minimumValue = 0
        default:
            slider.maximumValue = 30
            slider.minimumValue = 0
        }
        slider.trackRect(forBounds: CGRect(x: frame.minX + 10, y: frame.minY , width: frame.width - 10, height: frame.height*0.05))
        slidVal = UserDefaults.standard.integer(forKey: gc_keySlid)
        
        slider.setValue( Float(slidVal!), animated: true)
        slider.frame = CGRect(x: frame.width/2  , y: frame.height/2 + (frame.height*0.05) * 4 , width: frame.width/2, height: frame.height*0.05)
        slider.addTarget(self, action: #selector(self.setRadius), for: .valueChanged)
        return slider
    }()
    
    lazy var sliderField: UILabel = {
        let textfield = UILabel()
        textfield.text = UserDefaults.standard.string(forKey: gc_keySlid)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var segControl: UISegmentedControl = {
        let segControl = UISegmentedControl(items: items)
        segVal = UserDefaults.standard.integer(forKey: gc_keySprit)
        segControl.selectedSegmentIndex = segVal!
        segControl.translatesAutoresizingMaskIntoConstraints = false
        segControl.addTarget(self, action: #selector(self.setSprit), for: .valueChanged)
        
        return segControl
    }()
    
    lazy var sortSegControl: UISegmentedControl = {
        let segControl = UISegmentedControl(items: sortBy)
        segVal = UserDefaults.standard.integer(forKey: gc_keySprit)
        segControl.selectedSegmentIndex = segVal!
        segControl.translatesAutoresizingMaskIntoConstraints = false
        segControl.addTarget(self, action: #selector(self.setsortBy), for: .valueChanged)
        
        return segControl
    }()
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.section = gv_section!
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        numberField.delegate = self
        addSubview(numberField)
        numberField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        numberField.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        
     
        if gv_section == .General {
            addSubview(sortSegControl)
            sortSegControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            sortSegControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
            
        } else {
            addSubview(segControl)
            segControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            segControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
            
        }
        
        
        addSubview(slider)
        addSubview(sliderField)
        sliderField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sliderField.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func setSprit(sender: UISegmentedControl) {
        UserDefaults.standard.set( sender.selectedSegmentIndex, forKey: gc_keySprit)
        //        segControl?.selectedSegmentIndex = sender.selectedSegmentIndex
    }
    
    @objc func setRadius(sender: UISlider) {
        
        UserDefaults.standard.set( Int(sender.value), forKey: gc_keySlid)
        sliderField.text = String(Int(sender.value))
    }
    
    @objc func setsortBy(sender: UISegmentedControl) {
        print( sender.selectedSegmentIndex)
        UserDefaults.standard.set( sender.selectedSegmentIndex, forKey: gc_sort )
               
    }
    
    func textFieldDidEndEditing(_ textField: UITextField,
                                reason: UITextField.DidEndEditingReason){
        print("endEditing")
        if let val = Int(textField.text ?? "7") {
            UserDefaults.standard.set( val, forKey: gc_avgCons)
            
        }
    }
    
    
}


