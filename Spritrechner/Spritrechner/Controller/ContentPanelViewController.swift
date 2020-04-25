//
//  ContentPanelViewController.swift
//  Spritrechner
//
//  Created by Lukas on 20.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//


import UIKit
import MapKit

var gv_station: Station!

protocol DetailPanel {
    func showDetail(station: Station)
    func showDetailApi(station: StationDetail, append: Bool)
    func dismissDetail()
}


class ContentPanelViewController: UIViewController {
    
    var detailDelegate: DetailPanel!
    
    var stationDetail: [StationDetail]?
    var tableView: UITableView!
    var stations: [Station]? {
        didSet {
            self.stations = sortStation(lv_station: self.stations!)
        }}
    var reuseIdentifier = "PanelCell"
    
    var mapView: MKMapView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        if stations == nil {
            NotificationCenter.default.post(name: Notification.Name("FloatingPanelHalf"), object: nil)
            tableView.allowsSelection = false
        }
    }
    
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = cornerRadiusTabl
        tableView.backgroundColor = .clear
        let blur = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        tableView.backgroundView = blurView
        
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        
        
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        
    }
    
    
    
    func sortStation( lv_station: [Station]) -> [Station]{
        var rv_station = lv_station.filter{ $0.price != nil }
        let sortBy = UserDefaults.standard.integer(forKey: gc_sort)
        switch sortBy {
        case 0:
            rv_station.sort(by: {
                $0.price ?? 0 < $1.price ?? 0
            })
        case 1:
            rv_station.sort(by: {
                $0.dist < $1.dist
            })
            
            //        case 2:
            //            let avgCons = UserDefaults.standard.integer(forKey: gc_avgCons)
            //            let tankfuel = UserDefaults.standard.integer(forKey: gc_keySlid)
            //            rv_station.sort(by: {
            //                $0.price ?? 0 * Double(tankfuel) + $0.dist * Double(avgCons) / 100 >  $1.price ?? 0 * Double(tankfuel ) + $1.dist * Double(avgCons) / 100
        //            })
        default:
            rv_station.sort(by: {
                $0.price ?? 0 < $1.price ?? 0
            })
        }
        //        gv_station = rv_station
        return rv_station
    }
}

extension ContentPanelViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stations?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var enabled = false
        var cell: UITableViewCell
        if let station = stations?[indexPath.row] {
            gv_station = station
            enabled = station.isOpen
            cell = TableViewCell()
        } else {
            
            cell = TableViewCell()
            cell.textLabel?.text = "Keine Tankstellen in dieser Region"
            cell.isHighlighted = false
        }
        
        cell.isEditing = enabled
        cell.backgroundColor = .clear
        //        cell.style
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let station = stations?[indexPath.row] {
            
            if let stationDet = stationDetail?.first(where: {$0.id == station.id}) {
                // do something with foo
                detailDelegate.showDetailApi(station: stationDet, append: false)
            } else {
                // item could not be found
                let apiCall = APIDetails(id: station.id, apikey: gc_apiKey)
                apiCall.delegateDetail = detailDelegate
                apiCall.fetch()
            }
            let location = CLLocation(latitude: station.lat, longitude: station.lng)
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView?.setRegion( coordinateRegion, animated: true)
            
            
        }
    }
}

extension UITableView {
    
    func addBlurEffect()
    {
        var blur: UIVisualEffectView
        switch traitCollection.userInterfaceStyle.rawValue {
        case 1:
            blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        case 2:
            blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        default:
            blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        }
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        self.insertSubview(blur, at: 0)
        
    }
}


