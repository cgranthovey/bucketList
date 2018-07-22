//
//  MapItemsVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/21/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import MapKit
import Geofirestore
import GeoFire
import Firebase

class MapItemsVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnBack: UIButton!
    
    var locationManager = CLLocationManager()
    var hasUpdatedUserLocation = true
    var span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMap()
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpMap(){
        mapView.delegate = self
        mapView.showsUserLocation = true
//        mapView.mapType = .satellite
//        mapView.showsPointsOfInterest = true
        
//        mapView.convert(<#T##coordinate: CLLocationCoordinate2D##CLLocationCoordinate2D#>, toPointTo: <#T##UIView?#>)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func getGeoHash(region: MKCoordinateRegion){

        let geoQuery = DataService.instance.geoFirestore.query(inRegion: region)
        let geoQueryEnterHandle = geoQuery.observe(.documentEntered) { (key, location) in
            if let key = key, let location = location{
                let newPin = MKPointAnnotation()
                newPin.coordinate = location.coordinate
                newPin.title = key
                self.mapView.addAnnotation(newPin)
                print("got key - ")
            }
        }
        
        
    }
}

extension MapItemsVC: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let reusePin = "Pin"
        let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusePin) as? MKPinAnnotationView
        pinView?.pinTintColor = UIColor.orange
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        getGeoHash(region: mapView.region)
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        userLocation.coordinate
    }
}

extension MapItemsVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if hasUpdatedUserLocation{
            if let location = locations.first{
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.setRegion(region, animated: true)
                getGeoHash(region: region)
            }
            hasUpdatedUserLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error", error)
    }
}











