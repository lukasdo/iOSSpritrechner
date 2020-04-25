//
//  SettingsController.swift
//  Spritrechner
//
//  Created by Lukas on 12.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//

import UIKit

var gv_section: SettingsSection!

class SettingsViewController: UIViewController {
    
    var segControl: UISegmentedControl?
    var slider: UISlider?
    var slidVal: Int?
    var segVal: Int?
    var frame: CGRect?
    var width: CGFloat?
    var height: CGFloat?
    var tableView: UITableView!
    
    
    private let reuseIdentifier = "SettingsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        width = view.frame.width
        height = view.frame.height
        frame = UIScreen.main.bounds
        
        hideKeyboardWhenTappedAround()
        configureNavBar()
        configureTableView()
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.allowsSelection = false
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
//        tableView.tableFooterView.
//        tableView.tableFooterView = UIView()
    }
    
    func configureNavBar() {
        let backButton = UIButton(type: .custom)
           backButton.setTitle("Back", for: .normal)
           backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
           backButton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
           
       self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
       self.navigationItem.title = "Settings"
    }


    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let view = UIView()
         view.backgroundColor = blueColor
         
         let title = UILabel()
         title.font = UIFont.boldSystemFont(ofSize: 16)
         title.textColor = .white
         title.text = SettingsSection(rawValue: section)?.description
         view.addSubview(title)
         title.translatesAutoresizingMaskIntoConstraints = false
         title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
         title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
         
         return view
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          guard let section = SettingsSection(rawValue: section) else { return 0 }
            
          switch section {
          case .Fuel:
            return FuelOptions.allCases.count
          case .General:
            return GeneralOptions.allCases.count

          }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        gv_section = section
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath ) as! SettingsCell
        
        switch section {
        case .Fuel:
            let fuel = FuelOptions(rawValue: indexPath.row)
            gv_section = .Fuel
            cell.sectionType = fuel
        case .General:
            let general = GeneralOptions(rawValue: indexPath.row)
            cell.sectionType = general
//        default: return UIT
        }
        cell.sliderTag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
            return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        guard let section = SettingsSection(rawValue: section) else { return 0}
        switch section {
        case .General:
            return 60
        default:
            return 0
        }
    }
//    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return nil
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endEditing"), object: nil)
        view.endEditing(true)
    }
}
