//
//  AddBucketMapVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/11/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore

protocol SearchResultDelegate{
    func zoomInAt(region: MKCoordinateRegion, addressPrimary: String, addressSecondary: String)
}

class AddBucketMapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pinIV: UIImageView!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var resultSearchController: UISearchController?
    var searchBar = UISearchBar()
    
    var addressPrimary: String?
    var addressSecondary: String?
    var pinLat: String?
    var pinLong: String?
    var showingSearchedPin = false
    var showSearchText = false
    
    var generalSpan: MKCoordinateSpan{
        get {
            return MKCoordinateSpanMake(1.5, 1.5)
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
        btnBack.imageView?.contentMode = .scaleAspectFit
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationItem.titleView = nil
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        approveBtn.alpha = 0
        approveBtn.isEnabled = false
    }
    
    @IBAction func approvePinBtnPress(_ sender: AnyObject){
        if let primary = addressPrimary, let lat = pinLat, let long = pinLong{
            NewBucketItem.instance.item.addressPrimary = primary
            if let secondary = addressSecondary{
                NewBucketItem.instance.item.addressSeconary = secondary
            }
            
            NewBucketItem.instance.item.pinLat = lat
            NewBucketItem.instance.item.pinLong = long
            self.navigationController?.hero.navigationAnimationType = .uncover(direction: .down)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func clearPinBtnPress(_ sender: AnyObject){
        clearAnnotations()
        showingSearchedPin = false
        NewBucketItem.instance.item.clearAddress()
        searchBar.text = ""
        self.pinIV.isHidden = false
        self.pinIV.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        UIView.animate(withDuration: 0.3) {
            self.approveBtn.alpha = 0
            self.approveBtn.isEnabled = false
        }
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
            self.pinIV.transform = .identity
        }) { (success) in
            
        }
    }
    
    @IBAction func centerUserBtnPress(_ sender: AnyObject){
        let span = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
        print("coord0")
        if currentLocation != nil{
            print("coord", currentLocation!.coordinate)
            let region = MKCoordinateRegion(center: currentLocation!.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.hero.navigationAnimationType = .uncover(direction: .down)
        self.navigationController?.popViewController(animated: true)
    }
    
    func clearAnnotations(){
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
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
    
    override func viewDidAppear(_ animated: Bool) {
        if let addressFull = NewBucketItem.instance.item.addressFull(){
            searchBar.text = addressFull

            
            if searchBar.text != nil && !searchBar.text!.isEmptyOrWhitespace(){
                UIView.animate(withDuration: 0.3, animations: {
                    self.approveBtn.alpha = 1
                }) { (success) in
                    self.approveBtn.isEnabled = true
                }
            }
        }
    }
    
    func setUpMap(){
        
        if let coordinate2D = NewBucketItem.instance.item.coordinate2D(), let primary = NewBucketItem.instance.item.addressPrimary{
            pinIV.isHidden = true
            let span = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
            let region = MKCoordinateRegion(center: coordinate2D, span: span)
            mapView.setRegion(region, animated: true)
            showingSearchedPin = true
            addAnnotations(coord: coordinate2D, addressPrimary: primary)
            if let addressFull = NewBucketItem.instance.item.addressFull(){
                searchBar.text = addressFull
            }
        }

        
        self.mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func animateInApproveBtn(txtView: UISearchBar, delay: TimeInterval){
        print("animate it2", txtView.text)
        if txtView.text != nil && !txtView.text!.isEmptyOrWhitespace() && self.approveBtn.alpha == 0{
            print("animate it2")
            self.approveBtn.transform = CGAffineTransform(translationX: -20, y: 0)
            
            UIView.animate(withDuration: 0.4, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.approveBtn.transform = .identity
                self.approveBtn.alpha = 1
            }, completion: { (success) in
                self.approveBtn.isEnabled = true
            })
        }
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
        
        guard mapView.region.isRegionValid() else{
           return
        }
        
        let loc = CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
        geocoder.reverseGeocodeLocation(loc) { (placemarks, error) in
            if let error = error{
                print("geocoder error -", error)
                
            }
            if let places = placemarks{
                let pm = places[0]
                var addressString : String = ""
//                print("country", pm.country)
//                print("locality", pm.locality)
//                print("subLocality", pm.subLocality)
//                print("thoroughfare", pm.thoroughfare)
//                print("postalCode", pm.postalCode)
//                print("subThoroughfare", pm.subThoroughfare)
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

                if self.showingSearchedPin == false && self.showSearchText{
                    
                    self.searchBar.text = addressString
                    self.pinLat = "\(loc.coordinate.latitude)"
                    self.pinLong = "\(loc.coordinate.longitude)"
                    self.addressPrimary = addressString
//                    addressPrimary =
                    self.animateInApproveBtn(txtView: self.searchBar, delay: 0)

                }
                self.showSearchText = true
                
            }
        }
    }
}

extension AddBucketMapVC: SearchResultDelegate{
    func zoomInAt(region: MKCoordinateRegion, addressPrimary: String, addressSecondary: String) {
        searchBar.text = addressPrimary + ", " + addressSecondary
        
        addAnnotations(coord: region.center, addressPrimary: addressPrimary)
        
        self.addressPrimary = addressPrimary
        self.addressSecondary = addressSecondary
        self.pinLat = "\(region.center.latitude)"
        self.pinLong = "\(region.center.longitude)"
        showingSearchedPin = true
        self.pinIV.isHidden = true
        print("my region1 - ", region)
        let span = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)

        let regionNewSpan = MKCoordinateRegion(center: region.center, span: span)
        
        mapView.setRegion(regionNewSpan, animated: true)
        animateInApproveBtn(txtView: searchBar, delay: 0.5)
    }
    
    func addAnnotations(coord: CLLocationCoordinate2D, addressPrimary: String){
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        
        let annotation = MKPointAnnotation()
        annotation.title = addressPrimary
        annotation.coordinate = coord
        self.mapView.addAnnotation(annotation)
    }
}

extension AddBucketMapVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("didUpdateLoc1")
        if let location = locations.first, NewBucketItem.instance.item.coordinate2D() == nil{
            print("didUpdateLoc2")
            currentLocation = location
            let region = MKCoordinateRegion(center: location.coordinate, span: generalSpan)
            mapView.setRegion(region, animated: true)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}












