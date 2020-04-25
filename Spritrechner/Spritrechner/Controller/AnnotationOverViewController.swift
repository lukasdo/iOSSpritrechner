//
//  AnnotationOverViewController.swift
//  Spritrechner
//
//  Created by Lukas on 22.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//
import UIKit

private let reuseIdentifier = "OverView"


class OverViewController: UIViewController{
    
    // MARK: - Properties
    var delegate: DetailPanel!
    var cellDelegate: OverviewCellProtocol!
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!
    var station: StationDetail!
    
    // MARK: - Init
    init(station: StationDetail) {
        
        super.init(nibName: nil, bundle: nil)
        self.station = station
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .right
        self.view.addGestureRecognizer(swipeLeft)
        
        configureTableView()
    }
    
    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        tableView.layer.cornerRadius = cornerRadiusTabl
        tableView.backgroundColor = .clear
        //        tableView.isScrollEnabled = false   tableView.backgroundColor = .clear
        let blur = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        tableView.backgroundView = blurView
        
        tableView.register(OverVieCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame, station: station)
        userInfoHeader.overViewDelegate = cellDelegate
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView()
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
            print("Swipe Right")
            delegate.dismissDetail()
        }
            
        else if gesture.direction == .down {
            print("Swipe Down")
            delegate.dismissDetail()
        }
    }
}

extension OverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        OverViewSection.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = OverViewSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Fuel:
            return FuelOverViewSec.allCases.count
        case .Maps:
            return MapOverViewSec.allCases.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = blueColor
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = OverViewSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = OverViewSection(rawValue: indexPath.section) else { return UITableViewCell() }
        print(indexPath.row)
        gv_stationDetail = self.station
        gv_overViewSection = section
        switch gv_overViewSection {
        case .Fuel:
        gv_overViewFuel = FuelOverViewSec(rawValue: indexPath.row)
        case .Maps:
            gv_overViewMaps = MapOverViewSec(rawValue: indexPath.row)
        default: _ = 1 //? return empty?
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath ) as! OverVieCell
        cell.overViewDelegate = cellDelegate
        cell.backgroundColor = .clear
        return cell
    }
    
    
    
}
