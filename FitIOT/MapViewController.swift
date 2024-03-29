//
//  MapViewController.swift
//  FitIOT
//
//  Created by sanou abou on 15/10/2019.
//  Copyright © 2019 sanou abou. All rights reserved.
//
import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    
    var db = Database()
    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate=self
        locationManager.delegate = self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        retriveCurrentLocation()
        print(myIndex)
    }
    
    
    func retriveCurrentLocation(){
        let status = CLLocationManager.authorizationStatus()
        
        if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
            // show alert to user telling them they need to allow location data to use some feature of your app
            return
        }
        
        // if haven't show location permission dialog before, show it to user
        if(status == .notDetermined){
            locationManager.requestWhenInUseAuthorization()
            
            // if you want the app to retrieve location data even in background, use requestAlwaysAuthorization
            // locationManager.requestAlwaysAuthorization()
            return
        }
        
        // at this point the authorization status is authorized
        // request location data once
        // locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
        // start monitoring location data and get notified whenever there is change in location data / every few seconds, until stopUpdatingLocation() is called
        // locationManager.startUpdatingLocation()
    }
    func updateMap(with coordinate: CLLocationCoordinate2D) {
        
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
        
        
        let annotation = Annotation(title: "You are here", locationName: "Here", coordinate: coordinate)
        mapView.addAnnotation(annotation)
        
    }
    
    func updateMap(with coordinate: CLLocationCoordinate2D,route : MKPolyline) {
        
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addOverlay(route)
    }
    
    
}


extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location manager authorization status change")
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
        case .restricted:
            print("parental control setting disallow location data")
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // .requestLocation will only pass one location to the locations array
        // hence we can access it by taking the first element of the array
        if let location = locations.last {
            //print("\(location.coordinate.latitude)")
            //print("\(location.coordinate.longitude)")
            updateMap(with: location.coordinate)
        }
        
     
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendrer = MKPolylineRenderer(overlay: overlay)
        rendrer.strokeColor=UIColor.red
        return rendrer
    
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
  
    
    
    
    
    
    
}
