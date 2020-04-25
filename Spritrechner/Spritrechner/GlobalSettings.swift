//
//  GlobalSettings.swift
//  Spritrechner
//
//  Created by Lukas on 12.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//

import Foundation
import MapKit
import UIKit

public let distanceSpan: Double = 1000
public let regionRadius: CLLocationDistance = 100000
public let localRadius: CLLocationDistance = 100000
public let items = ["E5", "E10", "Diesel"]
public let sortBy = ["Preis", "Distanz" ]//, "Gesamtkosten"]
public let weekDaysAbbr = [" ","So","Mo","Di","Mi","Do","Fr","Sa"]
public let weekDays = [ " ", "Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"]
public let gc_keySprit = "Sprit"
public let gc_keySlid = "Radius"
public let gc_fetchMsg = "Fetched"
public let gc_sort = "SortBy"


// Key für den Zugriff auf die freie Tankerkönig-Spritpreis-API
// Für eigenen Key bitte hier https://creativecommons.tankerkoenig.de
// registrieren.
public let gc_apiKey = "00000000-0000-0000-0000-000000000000"
public let gc_apiKeyTest = "00000000-0000-0000-0000-000000000000"
//open var gv_section: SettingsSection?
public let blueColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
public let gc_avgCons = "avgCons"
public let cornerRadiusTabl: CGFloat = 9

enum Sprit: Int{
    case e5
    case e10
    case diesel
}
//func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//    // Used for StoryBoard
//    // Ignoring User
//    self.view.isUserInteractionEnabled = true
//    
//    //Activity Indicator
//    let activityIndicator = UIActivityIndicatorView()
//    activityIndicator.center = self.view.center
//    activityIndicator.color = .gray
//    activityIndicator.hidesWhenStopped = true
//    activityIndicator.startAnimating()
//    
//    self.view.addSubview(activityIndicator)
//    
//    //Hides search Bar
//    searchBar.resignFirstResponder()
//    dismiss(animated: true, completion: nil)
//    guard let searchText = resultSearchController?.searchBar.text
//               else { return }
//    
//    let location =  locationSearchTable.searchRequest(text: searchText)
//    centerMapOnLocation(location: location, radius: distanceSpan)
//}
//
//@objc func onSearch() {
//    let searchController = UISearchController(searchResultsController: nil)
//    searchController.searchBar.delegate = self
//    present(searchController, animated: true, completion: nil)
//   }

//   func searchRequest(text: String) -> CLLocation {
//            //Create search request
//        var location: CLLocation?
//            let searchRequest = MKLocalSearch.Request()
//            searchRequest.naturalLanguageQuery = text
//
//            let activSearch = MKLocalSearch(request: searchRequest)
//
//            activSearch.start { (response, error) in
//
//    //            activityIndicator.stopAnimating()
//    //            self.view.isUserInteractionEnabled = false
//
//                if response == nil {
//                    print("Erorr")
//                    location = CLLocation(latitude: 0, longitude: 0)
//                }
//                else{
//
//                    self.matchingItems = response!.mapItems
//                    self.tableView.reloadData()
//
//                    // Remove Annotation
//    //                let annotation = self.mapView?.annotations
//    //                self.mapView?.removeAnnotations(annotations)
//
//                    //Getting Data
//                    let latitude = response?.boundingRegion.center.latitude
//                    let longitude = response?.boundingRegion.center.longitude
//
//                    //Create annotation
//    //                let annotation = MKAnnotation()
//    //                annotation.title = searchBar.text
//    //                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
//    //                self.mapView?.addOverlay(annotation)
//
//                     location = CLLocation(latitude: latitude!, longitude: longitude!)
////                    ViewController.centerMapOnLocation(location: location, radius:  ViewController.distanceSpan)
////                    ViewController.center
//
//                    print(self.matchingItems)
//
//                }
//
//            }
//        return location ?? CLLocation(latitude: 0, longitude: 0)
//        }

//func updateSearchResults(for searchController: UISearchController) {
//    guard let searchText = searchController.searchBar.text
//        else { return }
//    guard searchText.count > 0 else {
//        return
//    }
//   let location =  locationSearchTable.searchRequest(text: searchText)
//    if location.coordinate.latitude == 0 && location.coordinate.longitude == 0{
//        return
//    }
//    centerMapOnLocation(location: location, radius: distanceSpan)
//}
