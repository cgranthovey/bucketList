//
//  AddBucketMapVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/11/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import MapKit

protocol SearchResultDelegate{
    func zoomInAt(placemark: MKPlacemark, address: String)
}

class AddBucketMapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var resultSearchController: UISearchController?
    var searchBar = UISearchBar()
    var generalSpan: MKCoordinateSpan{
        get {
            return MKCoordinateSpanMake(0.15, 0.15)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setUpMap()
        setUpSearchTable()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationItem.titleView = resultSearchController?.searchBar
    }
    
    func setUpSearchTable(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "LocationSearchTableVC") as? LocationSearchTableVC{
            resultSearchController = UISearchController(searchResultsController: vc)
            resultSearchController?.searchResultsUpdater = vc
            resultSearchController?.hidesNavigationBarDuringPresentation = false
            resultSearchController?.dimsBackgroundDuringPresentation = true
            definesPresentationContext = true
            vc.mapView = mapView
            vc.delegate = self
            
            if let searchController = resultSearchController{
                searchBar = searchController.searchBar
                searchBar.sizeToFit()
                searchBar.placeholder = "Search or press to drop pin"
            }

        }
    }
    
    func setUpMap(){
        self.mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

}



extension AddBucketMapVC: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let reusePin = "pin"
        let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusePin) as? MKPinAnnotationView
        pinView?.pinTintColor = UIColor.orange
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

        let geocoder = CLGeocoder()
        let loc = CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
        geocoder.reverseGeocodeLocation(loc) { (placemarks, error) in
            if let error = error{
                print("geocoder error -", error)
            }
            if let places = placemarks{
                let pm = places[0]
                var addressString : String = ""
                print("country", pm.country)
                print("locality", pm.locality)
                print("subLocality", pm.subLocality)
                print("thoroughfare", pm.thoroughfare)
                print("postalCode", pm.postalCode)
                print("subThoroughfare", pm.subThoroughfare)
                if pm.subThoroughfare != nil {
                    addressString = addressString + pm.subThoroughfare! + " "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.isoCountryCode != nil {
                    addressString = addressString + pm.isoCountryCode! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                print("current address - ", addressString)
            }
        }
    }
}

extension AddBucketMapVC: SearchResultDelegate{
    func zoomInAt(placemark: MKPlacemark, address: String) {
        searchBar.text = address
    }
}

extension AddBucketMapVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first{
            currentLocation = location
            let region = MKCoordinateRegion(center: location.coordinate, span: generalSpan)
            mapView.setRegion(region, animated: true)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}












