//
//  AnnoOverViewHeader.swift
//  Spritrechner
//
//  Created by Lukas on 22.03.20.
//  Copyright © 2020 Lukas. All rights reserved.


import UIKit

class UserInfoHeader: UIView {
    
    // MARK: - Properties
    var station: StationDetail!
    var overViewDelegate: OverviewCellProtocol?
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        var image = UIImage(named: "station")
        image = image?.withTintColor(UIColor.systemBlue)
        iv.image = image!
        return iv
    }()
    
    func createNamelbl() -> UILabel {
        let label = UILabel()
        label.text = station.name.maxLength(length: 25)
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    func createDetailLabel() -> UILabel {
        let label = UILabel()
        label.text = station.place
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    func createOpeningLabel(openTime:OpeningTime) -> UILabel {
        let label = UILabel()
        label.text = openTime.text.maxLength(length: 10) + ": " + openTime.start + " - " + openTime.end
        print(label.text)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
  
    func exitButton() -> UIButton{
        let button = UIButton()
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        var image = UIImage(named: "customX")
        image = image?.withTintColor(.lightGray)
        iv.image = image!
        
        button.setImage(iv.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exit), for: .touchUpInside)
        
        return button
    }
    
    
    let exitImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        var image = UIImage(named: "customX")
        image = image?.withTintColor(.lightGray)
        iv.image = image
        return iv
    }()
    
    
    // MARK: - Init
    
    init(frame: CGRect, station: StationDetail) {
        super.init(frame: frame)
        self.station = station
        let profileImageDimension: CGFloat = 50
        
        addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        let usernameLabel = createNamelbl()
        addSubview(usernameLabel)
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        
        let detailLabel = createDetailLabel()
        addSubview(detailLabel)
        detailLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 10).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        
        var count:CGFloat = 1
        for open in station.openingTimes {
//            if let val = Date().dayNumberOfWeek() {
//                if open.text.contains(weekDaysAbbr[val]) {
                    
                    let openingLabel = createOpeningLabel(openTime: open)//, openText: weekDays[val])
                    addSubview(openingLabel)
                    openingLabel.centerYAnchor.constraint(equalTo: detailLabel.centerYAnchor, constant: 20*count).isActive = true
                    openingLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
                    
                    count += 1
                break
//                }}else {
                
//            }
        }
     
        
        let exitImageDim: CGFloat = 30
        let exitBtn = exitButton()
        addSubview(exitBtn)
        exitBtn.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -self.bounds.height/4).isActive = true
        exitBtn.leftAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        exitBtn.widthAnchor.constraint(equalToConstant: exitImageDim).isActive = true
        exitBtn.heightAnchor.constraint(equalToConstant: exitImageDim).isActive = true
        exitBtn.layer.cornerRadius = exitImageDim / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func exit() {
        print("exit")
        overViewDelegate?.exitDetailPanel()
    }
    
}
extension Date {
    func dayNumberOfWeek() -> Int? {
        // Montag, Dienstag, Mittwoch, Donnerstag, Freitag, Samstag, Sonntag
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
