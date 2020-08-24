import UIKit
import MapKit
import CoreLocation

class Bedtime: UIViewController{
    let MK_ID = "MKID"
    var mapView = MKMapView()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    private var destinations: [MKPointAnnotation] = []
    private var currentRoutes: [MKRoute] = []
    var routesIterator = 0
    private var ETA: TimeInterval?
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        styleNavBar()
        configureMapView()
        setLocationManager()
    }
    func styleNavBar(){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .gray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "Adding Annotations"
        navigationItem.setRightBarButtonItems([UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(barButtonClicked)), UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(barButtonClicked))], animated: true)
    }
    @objc func barButtonClicked(){
        let nav = UINavigationController(rootViewController: UIViewController())
        nav.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(quitVC))
        navigationController?.present(nav, animated: true, completion: nil)
    }
    @objc func quitVC(){
        navigationController?.dismiss(animated: true, completion: nil)
    }
    func configureMapView(){
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        mapView.mapType = .standard
        mapView.delegate = self
        configureMapViewSubButtons()
    }
    
    func configureMapViewSubButtons(){
        let trackingButton = MKUserTrackingButton(mapView: mapView)
        trackingButton.backgroundColor = .white
        mapView.addSubview(trackingButton)
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackingButton.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 10),
            trackingButton.widthAnchor.constraint(equalToConstant: 40),
            trackingButton.heightAnchor.constraint(equalToConstant: 40),
            trackingButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10)
        ])
        
    }
    func configureSorryView(){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        label.backgroundColor = .cyan
        view.addSubview(label)
    }
    //MARK: locationManager
    func setLocationManager(){
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            startUpdating()
        }else if status == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }else{
            configureSorryView()
        }
    }
    func startUpdating(){
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.userLocation.title = "Current Location"
        mapView.userLocation.subtitle = "(0,0)"
    }
    func setZoomRegion(to coordinate: CLLocationCoordinate2D){
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 7000, longitudinalMeters: 7000)
        mapView.setRegion(region, animated: true)
    }
    func setAnnotations(){
        let YBCA = MKPointAnnotation()
        YBCA.title = "Yerba Buena Center"
        YBCA.subtitle = "For the arts"
        YBCA.coordinate = CLLocationCoordinate2D(latitude: 37.7856, longitude: -122.4022)
        let anotherOne = LandMark(coorindate: CLLocationCoordinate2D(latitude: 37.7856, longitude: -122.4030), title: "Starbucks", subtitle: "anotherOne")
        let chipotle = MKPointAnnotation()
        chipotle.coordinate = CLLocationCoordinate2D(latitude: 37.7856, longitude: -122.4108)
        chipotle.subtitle = "Just ate here."
        let innout = LandMark(coorindate: CLLocationCoordinate2D(latitude: 37.7856, longitude: -122.510), title: "innout", subtitle: "a restaurant")
        let destination = MKPointAnnotation()
        destination.subtitle = "BCP"
        destination.coordinate = CLLocationCoordinate2D(latitude: 37.3435, longitude: -121.9188)
        destinations.append(YBCA)
        destinations.append(chipotle)
        destinations.append(destination)
        mapView.addAnnotations([YBCA, anotherOne, chipotle, innout, destination])
    }
    //MARK: Directions
    private func constructRoute(location: CLLocationCoordinate2D){
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: location))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinations[2].coordinate))
        directionsRequest.transportType = .automobile
        directionsRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { [weak self](directionResponse, error) in
            guard let strongSelf = self else {return}
            
            if let error = error{
                print(error.localizedDescription)
            }else if let response = directionResponse, response.routes.count > 0{
                var fastestRoute = response.routes[0]
                for i in response.routes{
                    strongSelf.currentRoutes.append(i)
                    if i.expectedTravelTime < fastestRoute.expectedTravelTime{
                        fastestRoute = i
                    }
                }
                strongSelf.currentRoutes.remove(at: strongSelf.currentRoutes.firstIndex(of: fastestRoute)!)
                strongSelf.currentRoutes.insert(fastestRoute, at: strongSelf.currentRoutes.count)
                
                var i = 0
                while i<response.routes.count{
                    strongSelf.mapView.addOverlay(response.routes[i].polyline)
                    i+=1
                }
                strongSelf.mapView.setVisibleMapRect(strongSelf.currentRoutes[0].polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 40, left: 50, bottom: 40, right: 50), animated: true)
            }
        }
        directions.calculateETA { [weak self](etaResponse, error) in
            guard let strongSelf = self else {return}
            if let error = error{
                print(error.localizedDescription)
            }else if let response = etaResponse, response.expectedTravelTime>=0{
                strongSelf.ETA = response.expectedTravelTime
                print("the expected time of arrival is \(strongSelf.ETA!) seconds")
            }
            
        }
    }
    private func addCurrentRoutes(route: MKRoute){
        currentRoutes.append(route)
    }
}
//MARK: Delegates
extension Bedtime: MKMapViewDelegate, CLLocationManagerDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if currentRoutes.count>0{
            let polylineRenderer = MKPolylineRenderer(polyline: currentRoutes[routesIterator].polyline)
            if routesIterator == currentRoutes.count-1{
                polylineRenderer.strokeColor = .blue
            }else{
                polylineRenderer.strokeColor = .gray
            }
            polylineRenderer.lineWidth = 5
            routesIterator += 1
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {return}
        if currentLocation == nil{
            setZoomRegion(to: latestLocation.coordinate)
            setAnnotations()
            constructRoute(location: latestLocation.coordinate)
        }
        currentLocation = latestLocation.coordinate
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization just changed.")
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            startUpdating()
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotatedView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView") as? MKMarkerAnnotationView
        if annotatedView == nil{
            annotatedView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView") as? MKMarkerAnnotationView
        }
        annotatedView?.image = UIImage.init(systemName: "plus")
        annotatedView?.leftCalloutAccessoryView = UIImageView(image: UIImage(systemName: "plus"))
        annotatedView?.rightCalloutAccessoryView = UIImageView(image: UIImage.init(systemName: "Road"))
        annotatedView?.canShowCallout = true
        return annotatedView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("MKAnnotationView with title \(view.annotation?.title) was selected.")
    }
}
class LandMark: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(coorindate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coorindate
        self.title  = title
        self.subtitle = subtitle
    }
}

