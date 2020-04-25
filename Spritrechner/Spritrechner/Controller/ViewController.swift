//
//  ViewController.swift
//  Spritrechner
//
//  Created by Lukas on 06.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
// 

import UIKit
import FloatingPanel
import MapKit

var fpc: FloatingPanelController!
var detailPanel: FloatingPanelController?
var blurStyle: UIBlurEffect.Style!

class ViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate{
    
    // MARK:: Vars
    var window: UIWindow?
    var mapView: MKMapView?
    var topPadding: CGFloat!
    var bottomPadding: CGFloat!
    var safeArea: UILayoutGuide!
    var stations: [Station]?
    var postRequ: APIRequest?
    let gvStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var resultSearchController: UISearchController? = nil
    var locationSearchTable: LocationSearchTable!
    var locationManager: CLLocationManager!
    var apiKey: String?
    var contentVC:ContentPanelViewController!
    var fetch:Bool!
    var detailVC: OverViewController?
    var locationButton: UIButton!
    var reloadButton: UIButton!
    var compassButton:  MKCompassButton!
    
    var styleTrack: UIBlurEffect.Style?
    
    // MARK:: Controller LFC
    override func viewDidLoad() {
        super.viewDidLoad()
        #if targetEnvironment(simulator)
        apiKey = gc_apiKey
        fetch = true
        #else
        apiKey = gc_apiKeyTest
        fetch = true
        #endif
        darkMode()
        setupMapView()
        initButton()
        setupLocationManager()
        annotateExample()
        navBar()
        initPanel()
        
        
        mapView?.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
       let cust = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 51.0392702, longitude: -0.2421105))
        cust.title = "Custom Title"
        mapView?.addAnnotation(cust)

    }
    
   

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
        // Remove the views managed by the `FloatingPanelController` object from self.view.
//                fpc.removePanelFromParent(animated: animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onLoadData), name: NSNotification.Name(gc_fetchMsg), object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(panelDismiss), name: NSNotification.Name("FloatingPanelHalf"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(hideDetail))
        self.mapView?.addGestureRecognizer(gestureRec)
        
        //        detailPanel.backdropView.addGestureRecognizer(gestureRec)
        
    }
    
    func configBlurredUI() {
//                fpc.removePanelFromParent(animated: false)
//        initPanel()
        configButton()
    }
    
    func configButton() {
        locationButton.roundedTopButton()
        locationButton.addBlurEffect()
        reloadButton.roundedBottom()
        reloadButton.addBlurEffect()
    }
    
    func initButton() {
        locationButton = UIButton()
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.titleLabel?.text = "P"
        
        var locationImg = UIImage(named: "location")
        locationImg = locationImg?.withTintColor(UIColor.systemBlue)
        locationButton.setImage(locationImg, for: .normal)
        locationButton.addTarget(self, action: #selector(showUserLocation), for: .touchUpInside)
        //        locationButton.backgroundColor = UIColor.black
        self.mapView?.addSubview(locationButton)
        NSLayoutConstraint.activate([
            locationButton.widthAnchor.constraint(equalToConstant: 30),
            locationButton.heightAnchor.constraint(equalToConstant: 50),
            locationButton.rightAnchor.constraint(equalTo: self.mapView!.rightAnchor, constant: -12),
            locationButton.topAnchor.constraint(equalTo: self.mapView!.topAnchor,constant: 60)
        ])
        
        reloadButton = UIButton()
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        var refreshImg = UIImage(named: "refresh")
        refreshImg = refreshImg?.withTintColor(UIColor.systemBlue)
        reloadButton.setImage(refreshImg, for: .normal)
        reloadButton.addTarget(self, action: #selector(fetchHere), for: .touchUpInside)
        //        reloadButton.backgroundColor = UIColor.black
        self.mapView?.addSubview(reloadButton)
        NSLayoutConstraint.activate([
            reloadButton.widthAnchor.constraint(equalToConstant: 30),
            reloadButton.heightAnchor.constraint(equalToConstant: 50),
            reloadButton.rightAnchor.constraint(equalTo: self.mapView!.rightAnchor, constant: -12),
            reloadButton.topAnchor.constraint(equalTo: locationButton.bottomAnchor)
        ])
        
        let seperator = UIView()
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = UIColor.gray
        self.mapView?.addSubview(seperator)
        NSLayoutConstraint.activate([
            seperator.widthAnchor.constraint(equalToConstant: 30),
            seperator.heightAnchor.constraint(equalToConstant: 1),
            seperator.rightAnchor.constraint(equalTo: self.mapView!.rightAnchor, constant: -12),
            seperator.topAnchor.constraint(equalTo: locationButton.bottomAnchor)
        ])
        
        
        //        compassButton = MKCompassButton(mapView: self.mapView)
        //        compassButton.frame.origin = CGPoint(x: self.view.frame.maxX - 40, y: 20)
        //        compassButton.compassVisibility = .adaptive
        //        self.mapView?.addSubview(compassButton)
        //
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
        blur.frame = locationButton.bounds
        blur.isUserInteractionEnabled = false
        locationButton.insertSubview(blur, at: 0)
    }
    
    // MARK:: Configure UI
    func initPanel() {
        
        fpc = FloatingPanelController()
//        fpc.surfaceView.backgroundColor = .clear
        fpc.surfaceView.cornerRadius = cornerRadiusTabl
        fpc.surfaceView.shadowHidden = false
        
        // Set a content view controller.
        contentVC = ContentPanelViewController()
        contentVC.detailDelegate = self
        //        let blur = UIBlurEffect(style: .light)
        //        let blurView = UIVisualEffectView(effect: blur)
        //        blurView.frame = self.view.bounds
        
        fpc.set(contentViewController: contentVC)
        
        contentVC.mapView = mapView!
        // Track a scroll view(or the siblings) in the content view controller.
        
        fpc.track(scrollView: contentVC.tableView)
        //        contentVC.tableView.addBlurEffect()
        fpc.addPanel(toParent: self)
        
        
        
    }
    
    public var initialPosition: FloatingPanelPosition {
        return .full
    }
    
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
            mapView?.showsUserLocation = true
        }
    }
    
    func setupMapView() {
        //MapView
        
        //MARK:: Change Map Type https://developer.apple.com/documentation/mapkit/mkmapview/1452742-maptype
        self.window = UIWindow(frame: UIScreen.main.bounds)
        safeArea = view.layoutMarginsGuide
        self.mapView = MKMapView(frame: CGRect(x: safeArea.layoutFrame.minX, y: (window?.safeAreaInsets.top)!, width: safeArea.layoutFrame.width, height: safeArea.layoutFrame.height))
        self.view.addSubview(self.mapView!)
        self.mapView?.showsCompass = false
        
    }
    
    func navBar(){
        //Table View
        locationSearchTable = LocationSearchTable()
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        locationSearchTable.mapView = mapView
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        //      NavBar
        let settingsImg = UIImage(named: "settings")
        let settingsButton = UIBarButtonItem(image: settingsImg!, style: .plain, target: self, action: #selector(self.onSettings))
        
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.backgroundColor = .clear
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        blur.frame = (navigationController?.navigationBar.bounds)!
        blur.isUserInteractionEnabled = false
//        navigationController?.navigationBar.addSubview(blur)
        
        self.navigationItem.titleView = resultSearchController?.searchBar
        self.navigationItem.setLeftBarButton(settingsButton, animated: false  )
    }
    
    func darkMode() {
        
        var style: UIBlurEffect.Style
        switch traitCollection.userInterfaceStyle.rawValue {
        case 1:
            style =  .light
        case 2:
            style = .dark
        default:
            style =  .light
        }
        
        blurStyle = style
        if let stylechang = styleTrack {
            if stylechang != blurStyle {
//                Remove Button and Add again
                fpc.removePanelFromParent(animated: false)
                for views in self.locationButton.subviews {
                    views.removeFromSuperview()
                }
                for views in self.reloadButton.subviews {
                    views.removeFromSuperview()
                }
                initButton()
                
                initPanel()
                onLoadData()
                configBlurredUI()
            }
        }
        let styleConst = style
        styleTrack = styleConst
    }
    
    // MARK:: MAP Functions
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
        var annotationView: MKAnnotationView?
        if let annotation = annotation as? CustomAnnotation {
            annotationView = setUpCustomAnnotationView(for: annotation, on: mapView)
        }
        return annotationView
    }
    
    func setUpCustomAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        return  (self.mapView?.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CustomAnnotation.self), for: annotation))!
    }
    
    
    func annotateExample() {
        // Annotation Example
        mapView?.delegate = self
        
        mapView?.register(MarkerView.self,
                          forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let customAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 51.0392702, longitude: -0.2421105))
        customAnnotation.title = "Custom Annotation"
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        _ = mapView.selectedAnnotations
        if let tankeAnno = view.annotation as? Tanke {
            
            if let stations = contentVC.stations {
                let station = stations.filter{
                    $0.id == tankeAnno.id
                }
                if station.count > 0 {
                    let apiCall = APIDetails(id: station[0].id, apikey: gc_apiKey)
                    apiCall.delegateDetail = self
                    apiCall.fetch()
                    
                }
            }
        }
    }
    
    
    public func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: radius, longitudinalMeters: radius)
        mapView?.setRegion(coordinateRegion, animated: true)
        //TODO:: Request
    }
    
    func prepareRoute(coordinate: CLLocationCoordinate2D) {
      let destLocation = coordinate
        if let sourceLocation = mapView?.userLocation.coordinate{
            
            let midPoint = geoMidPoint(loc1: destLocation, loc2: sourceLocation)
            print(midPoint)
//            centerMapOnLocation(location: midPoint, radius: <#T##CLLocationDistance#>)
        
            
            let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
            let destinationPlacemark = MKPlacemark(coordinate: destLocation, addressDictionary: nil)
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
        
            let directionRequest = MKDirections.Request()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationMapItem
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate(completionHandler: { (response, error) in
                if error != nil {
                    print("Error getting directions")
                    print(error!)
                } else {
                    
                    
                    detailPanel?.move(to: .tip, animated: true)
//                    self.centerMapOnLocation(location: midPoint, radius: 1000)
                    
                    self.showRoute(response!)
                }
            })
        }
    }
    
    func geoMidPoint(loc1:CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) -> CLLocation
    {
        let lon1 = deg2rad(loc1.longitude)
        let lon2 = deg2rad(loc2.longitude)
        
        let lat1 = deg2rad(loc1.latitude)
        let lat2 = deg2rad(loc2.latitude)
        
        let  Bx = cos(lat2) * cos(lon2-lon1);
        let By = cos(lat2) * sin(lon2-lon1);
        
        let latMid = atan2(sin(lat1) + sin(lat2), sqrt( (cos(lat1)+Bx)*(cos(lat1)+Bx) + By*By ) )
        let  lonMid = lon1 + atan2(By, cos(lat1) + Bx);
        
        return CLLocation(latitude: latMid, longitude: lonMid)
        
        
        
//        let dLon =  deg2rad(posB.longitude - posA.longitude)
//        let Bx = cos(deg2rad(posB.latitude) * cos(dLon))
//        let By = cos(deg2rad(posB.longitude) * sin(dLon))
//
//        let latitude = rad2deg(atan2(
//            sin(deg2rad(posA.latitude)) + sin(deg2rad(posB.latitude)),
//            sqrt(
//                (cos(deg2rad(posA.latitude)) + Bx) *
//                    (cos(deg2rad(posA.latitude)) + Bx) + By * By)))
//
//        let longitude = posA.longitude + rad2deg(atan2(By, cos(deg2rad(posA.latitude)) + Bx))
//
//        let midPoint = CLLocation(latitude: latitude, longitude: longitude)
//        return midPoint
    }
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
    }
    
    func showRoute(_ response: MKDirections.Response) {
        
        for route in response.routes {
            self.mapView?.addOverlay(route.polyline,
                                     level: MKOverlayLevel.aboveRoads)
            for step in route.steps {
                print(step.instructions)
            }
        }
    }
    
    func launchInMaps(coordinate: CLLocationCoordinate2D) {
        let destLocation = coordinate
        let destinationPlacemark = MKPlacemark(coordinate: destLocation, addressDictionary: nil)
        // Open Route in Maps
        let mapItem = MKMapItem(placemark: destinationPlacemark)
        mapItem.name = "The way I want to go"
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
        
    }
    
    //    Rendering the Route
    func mapView(_ mapView: MKMapView, rendererFor
        overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func removeOverlay() {
        if let overlays = mapView?.overlays {
            mapView!.removeOverlays(overlays)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard UIApplication.shared.applicationState == .inactive else {
            return
        }
        
        darkMode()

        configBlurredUI()

    }
    
    // MARK:: OBJC Methods
    @objc func appMovedToForeground() {
//        darkMode()
//        configBlurredUI()
//        contentVC.tableView.reloadData()
    }
    
    @objc func appMovedToBackground() {
    
//        contentVC.tableView.reloadData()
        print("movedToBackgr")
    }
    @objc func hideDetail() {
        //        if detailVC != nil {
        //            detailPanel!.hide()
        //            fpc.show()
        //        }
    }
    
    @objc func showUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    @objc func onLoadData() {
        if let stations = postRequ?.stations {
            let rv_station = stations.filter{ $0.price != nil }
            contentVC.stations = rv_station
            
            DispatchQueue.main.async {
                self.contentVC.tableView.allowsSelection = true
                self.contentVC.tableView.reloadData()
                self.contentVC.stationDetail = nil
            }
            for station in rv_station {
                let tanke = Tanke(title: station.name, locationName: station.brand, coordinate: CLLocationCoordinate2D(latitude: station.lat, longitude: station.lng) , id: station.id)
                self.mapView?.addAnnotation(tanke)
            }
        }
    }
    
    @objc func onSettings() {
        guard let settingsVC = gvStoryboard.instantiateViewController(withIdentifier: "SettingsNavController") as? UINavigationController
            else { return;}
        settingsVC.modalPresentationStyle = .fullScreen
        self.present(settingsVC, animated: true)
    }
    
    @objc func fetchHere() {
        if let center =  mapView?.centerCoordinate {
            self.postRequ = APIRequest(lat: center.latitude, long: center.longitude, rad: UserDefaults.standard.integer(forKey: gc_keySlid), type: Sprit(rawValue: UserDefaults.standard.integer(forKey: gc_keySprit))!, apikey: apiKey!)
            self.postRequ!.fetch()
            if let annotations = self.mapView?.annotations {
                self.mapView?.removeAnnotations(annotations)
            }
        }
    }
    
    @objc func panelDismiss() {
        fpc?.move(to: .tip, animated: true)
    }
    
}

extension ViewController:DetailPanel, FloatingPanelControllerDelegate {

    
    func showDetailApi(station: StationDetail, append: Bool) {
        
    
        if contentVC.stationDetail != nil {
            if append == true {
    
                contentVC.stationDetail!.append(station)
            }
        }else {
            var stationDet: [StationDetail] = []
            stationDet.append(station)
            contentVC.stationDetail = stationDet
            
            
        }
        
        
        detailPanel = FloatingPanelController()
        self.detailVC = OverViewController(station: station)
        self.detailVC!.delegate = self
        self.detailVC!.cellDelegate = self
        detailPanel!.set(contentViewController: self.detailVC)
        detailPanel?.surfaceView.cornerRadius = cornerRadiusTabl
        detailPanel!.track(scrollView: self.detailVC!.tableView)
        detailPanel!.addPanel(toParent: self)
        detailPanel!.show(animated: true, completion: nil )
        fpc.hide(animated: true, completion: nil)
        
    }
    
    func showDetail(station: Station) {
        detailPanel = FloatingPanelController()
//        detailVC = OverViewController(station: station)
        detailVC!.delegate = self
        detailPanel!.set(contentViewController: detailVC)
        detailPanel?.surfaceView.cornerRadius = cornerRadiusTabl
        detailPanel!.track(scrollView: detailVC!.tableView)
        detailPanel!.addPanel(toParent: self)
        detailPanel!.show(animated: true, completion: nil )
        fpc.hide(animated: true, completion: nil)
    }
    
    func dismissDetail() {
        if let overlays = mapView?.overlays {
            mapView?.removeOverlays(overlays)
        }
        
        detailPanel!.hide(animated: true, completion: nil)
        detailVC = nil
        fpc.show()
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let radius = UserDefaults.standard.integer(forKey: gc_keySlid)
        let location: CLLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        print(location)
        centerMapOnLocation(location: location, radius: Double(radius * 1000))
        
        //TODO:: Condition
        //         damit nicht bei jeder kleinsten Bewegung neu gefetched wird // Timer oder location based
        if (fetch) {
            self.postRequ = APIRequest(lat: locValue.latitude, long: locValue.longitude, rad: radius, type: Sprit(rawValue: UserDefaults.standard.integer(forKey: gc_keySprit))!, apikey: apiKey!)
            self.postRequ!.fetch()
            fetch = false
        }
        
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ViewController: OverviewCellProtocol {
    func displayRoute(coordinate: CLLocationCoordinate2D) {
        prepareRoute(coordinate: coordinate)
    }
    
    func openInMaps(coordinate: CLLocationCoordinate2D) {
        launchInMaps(coordinate: coordinate)
    }
    
    func exitDetailPanel() {
        dismissDetail()
    }
    

    
    
}

extension UIButton{
    func roundedTopButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedBottom(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft , .bottomRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func addBlurEffect()
    {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView{
            self.bringSubviewToFront(imageView)
        }
    }
}
