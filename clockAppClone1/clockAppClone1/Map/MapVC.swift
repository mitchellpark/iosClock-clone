//
//  Timer.swift
//  clockAppClone1
//
//  Created by Mitchell Park on 2/24/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapVC: UIViewController {
    var route: MKRoute?
    var destinations:[Venue] = []
    var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    var requestView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleNavBar()
        configureMapView()
        setAnnotations()
        setLocationManager()
    }
    
    func setLocationManager(){
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            print("Authorized.")
            startUpdating()
        }else if status == .notDetermined{
            print("Not determind.")
            locationManager.requestWhenInUseAuthorization()
        }else{
            print("Unclear.")
            configureRequestView()
        }
    }
    
    func startUpdating(){
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func configureRequestView(){
        view.addSubview(requestView)
        requestView.backgroundColor = .systemPink
        requestView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            requestView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            requestView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            requestView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            requestView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        let label = UILabel()
        requestView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: requestView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: requestView.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: requestView.frame.width),
            label.heightAnchor.constraint(equalToConstant: 200)
        ])
        label.textAlignment = .center
        label.text = "You need to change your settings."
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
    }
    
    func zoomToRegion(to coorindate: CLLocationCoordinate2D){
        let region = MKCoordinateRegion.init(center: mapView.annotations[0].coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        mapView.setRegion(region, animated: true)
        for map in mapView.annotations{
            print(map.subtitle! ?? "default")
        }
    }
    
    func styleNavBar(){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemPink
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController!.navigationBar.compactAppearance = appearance
        navigationController!.navigationBar.scrollEdgeAppearance = appearance
        navigationController!.navigationBar.standardAppearance = appearance
        navigationController!.navigationBar.tintColor = .white
        navigationItem.title = "Test your reaction time!"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "backward"), style: .plain, target: self, action: #selector(showSideVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "dot.circle"), style: .plain, target: self, action: #selector(pressQuit))
    }
    
    @objc func pressQuit(){
        let alertController = UIAlertController(title: "Exit App?", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Stay in app", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    //MARK: Annotations
    func setAnnotations(){
        mapView.mapType = .standard
        let fiorillos = Venue(title: "El Compa", locationName: "0,0", coordinate: CLLocationCoordinate2D(latitude: 2, longitude: 2))
        let chipotle = Venue(title: "Chipotle", locationName: "anywhere", coordinate: .init(latitude: 0.1, longitude: 0.1))
        let chickfila = Venue(title: "Chick Fil a", locationName: "A restaurant", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20))
        let innout = Venue(title: "innout", locationName: "(10,10)", coordinate: CLLocationCoordinate2D(latitude: 15, longitude: 15))
        mapView.addAnnotations([chipotle, innout, fiorillos, chickfila])
        mapView.addAnnotations([fiorillos, chipotle, innout])
        destinations.append(fiorillos)
        destinations.append(chipotle)
    }
    
    func getDirections(from:CLLocationCoordinate2D){
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.annotations[0].coordinate))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinations[0].coordinate))
        directionsRequest.transportType = .automobile
        directionsRequest.requestsAlternateRoutes = true
        
        let requestedRoute = MKDirections(request: directionsRequest)
        requestedRoute.calculate { [weak self](responseRes, error) in
            guard let strongSelf = self else {return}
            if let error = error{
                let alertController = UIAlertController(title: "Error:", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                strongSelf.navigationController?.present(alertController, animated: true, completion: nil)
            }else if let response = responseRes, response.routes.count>0{
                strongSelf.route = response.routes[0]
                strongSelf.mapView.addOverlay(response.routes[0].polyline)
                strongSelf.mapView.setVisibleMapRect(response.routes[0].polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60), animated: true)
            }
        }
    }
    
    @objc func showSideVC(){
        print("show side vc")
    }
    
    func configureMapView(){
        mapView = MKMapView()
        mapView.showsCompass = true
        mapView.showsScale = true
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        mapView.userTrackingMode = .followWithHeading
        
    }
    

}
extension MapVC: CLLocationManagerDelegate, MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if route == nil{
            return MKOverlayRenderer()
        }
        let polylineRender = MKPolylineRenderer(overlay: overlay)
        polylineRender.fillColor = .white
        polylineRender.strokeColor = .blue
        polylineRender.lineWidth = 5
        return polylineRender
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            startUpdating()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {return}
        if currentCoordinate == nil{
            zoomToRegion(to: latestLocation.coordinate)
            getDirections(from: latestLocation.coordinate)
        }
        currentCoordinate = latestLocation.coordinate
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Annotation was selected.")
    }
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        label.backgroundColor = .cyan
        label.text = "failed to load map."
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        view.addSubview(label)
        print(error)
    }
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        label.backgroundColor = .cyan
        label.text = "failed to load map."
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        view.addSubview(label)
        print(error)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotatedView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView")
        if annotatedView == nil{
            annotatedView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotationview")
        }
        annotatedView?.image = UIImage(systemName: "plus")
        annotatedView?.canShowCallout = true
        if let annot = annotatedView{
            print(annot)
        }
        return annotatedView
    }
}
