//
//  LocationSearchTable.swift
//  Spritrechner
//
//  Created by Lukas on 07.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//

import Foundation
import UIKit
import MapKit

enum Country: Int, CaseIterable, CustomStringConvertible {
    var description: String {
        switch self {
        case .Adress:
            return "1000"
        case .Country:
            return "1000000"
        case .City:
            return "10000"
        }
    }
    

    case City
    case Country
    case Adress
}



class LocationSearchTable: UITableViewController {
    //
    
    
    var cellIdentifier: String = "ResultCell"
    var matchingItems:[MKMapItem] = []
    var subMatchingItems: [Country] = []
    var mapView: MKMapView? = nil
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.tableView.backgroundColor = .clear
            let blur = UIBlurEffect(style: blurStyle)
            let blurView = UIVisualEffectView(effect: blur)
            blurView.frame = self.view.bounds
            self.tableView.backgroundView = blurView
        }
    

    
    
}
extension LocationSearchTable : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        
//
     
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.subMatchingItems = []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            //
        }
    }
}
extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return 70
      }
    
    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if let path = indexPath {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier)
        let selectedItem = self.matchingItems[indexPath.row].placemark
        var descr: String!
        if let city = selectedItem.locality {
            
            if let straße = selectedItem.thoroughfare {
                if let number = selectedItem.subThoroughfare {
                    
                    subMatchingItems.append(.Adress)
                    descr = straße + " " + number + ", " + city
                }
                else {
                    descr = straße + ", " + city

                    subMatchingItems.append(.Adress)
                }
            }
            else {
                subMatchingItems.append(.City)
                descr = city
            }
        } else {
            print("Land")
            descr = selectedItem.country
           subMatchingItems.append(.Country)
        }
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = descr
        cell.backgroundColor = .clear
        return cell
        //        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = matchingItems[indexPath.row]
        let distance = Double(subMatchingItems[indexPath.row].description)
        
        let coords = selectedPlace.placemark.coordinate
        print(selectedPlace)
        _ = MKAnnotationView(frame: CGRect(x: 50, y: 70, width: 80, height: 90))
        //        let annotation = MKAnnotation(annotationView)
        //        annotation.
        //        mapView?.addAnnotation(<#T##annotation: MKAnnotation##MKAnnotation#>)
        self.dismiss(animated: true, completion: nil)
        let location = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
        //        let location2D = CLLocationCoordinate2DMake(coords.latitude, coords.longitude)
        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: distance ?? 10000, longitudinalMeters: distance ?? 10000)
        mapView?.setRegion( coordinateRegion, animated: true)
        
        
    }
}


