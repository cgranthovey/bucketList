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
    
    var locationManager = CLLocationManager()
    var hasUpdatedUserLocation = true
    var span = MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 1.5)
    var geoQuery: GFSRegionQuery?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        self.tabBarController?.hero.tabBarAnimationType = .fade
        setUpMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let tb = tabBarController as? MainTBC{
            if let bucketItem = tb.bucketItem, let coord2D = bucketItem.coordinate2D(){
                print("maps vc - ", bucketItem.coordinate2D())
                let span = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
                let region = MKCoordinateRegion(center: coord2D, span: span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {

    }

    func setUpMap(){
        mapView.delegate = self
        mapView.showsUserLocation = true

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    

    var keysOfAnnotations = [String]()
    
    func getGeoHash(region: MKCoordinateRegion){
        geoQuery = DataService.instance.currentUserGeoFirestore.query(inRegion: region)
        
        if let query = geoQuery{
            let geoQueryEnterHandle = query.observe(.documentEntered) { (key, location) in
                guard key != nil else{
                    return
                }
                guard !self.keysOfAnnotations.contains(key!) else{
                    return
                }
                let count = query.totalObserverCount()
                
                self.keysOfAnnotations.append(key!)
                if let key = key, let location = location{
                    self.getBucketItem(key: key, location: location)
                }
            }
        }
    }
    
    func getBucketItem(key: String, location: CLLocation){
        DataService.instance.bucketListRef.document(key).getDocument(completion: { (snapshot, error) in
            guard error == nil else{
                print("error getting document", error)
                return
            }
            if let snapshot = snapshot, let data = snapshot.data(){
                self.makeAnnotation(data: data, location: location, id: snapshot.documentID)
            }
        })
    }
    
    func makeAnnotation(data: [String: Any], location: CLLocation, id: String){
        
        let newPin = BucketMKPointAnnotation()
        let bucketItem = BucketItem.init(dict: data, id: id)
        newPin.bucketItem = bucketItem
        
        newPin.coordinate = location.coordinate
        if let title = bucketItem.title{
            newPin.title = title
        }
        
        let pin = MKPointAnnotation()
//        if let subtitle = bucketItem.addressPrimary{
//            newPin.subtitle = subtitle
//        }
        self.mapView.addAnnotation(newPin)
        let count = self.mapView.annotations.count
    }
}

extension MapItemsVC: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        if let annotation = annotation as? BucketMKPointAnnotation, let bucketItem = annotation.bucketItem{

            let reusePin = "pin"
            let pinView: MKMarkerAnnotationView!
            if let pin = mapView.dequeueReusableAnnotationView(withIdentifier: reusePin) as? MKMarkerAnnotationView{
                pinView = pin
            } else{
                pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reusePin)
            }
            
            pinView?.markerTintColor = UIColor().primaryColor
           // pinView?.canShowCallout = true
            
            //button.addTarget(self, action: #selector(AnnotationMapVC.annotationBtnTapped(_:)), for: .touchUpInside)
            //        button.imageView?.contentMode = .scaleAspectFit
            //        button.tag = 1//currentBtnTag
            pinView?.tag = 2// currentBtnTag
            
            //self.dictEnterTagForEventKey[currentBtnTag] = myEvent!.key
            //currentBtnTag = currentBtnTag + 1
            
            let rightImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            rightImg.image = #imageLiteral(resourceName: "right-arrow")
            pinView?.rightCalloutAccessoryView = rightImg
            
            let tap = BucketTapGesture(target: self, action: #selector(self.toDetails(sender:)))
            
            pinView.addGestureRecognizer(tap)
            tap.bucketItem = bucketItem
            
            if let pin = pinView{
                return pin
            }
            return nil
        }
        return nil
    }
    
    @objc func toDetails(sender: BucketTapGesture){
        print("to details1")
        if let bucketItem = sender.bucketItem{
            print("to details2")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "BucketDetails") as?
                BucketDetails{
                print("to details3")
                vc.bucketItem = bucketItem
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if mapView.region.isRegionValid(){
            getGeoHash(region: mapView.region)
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
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
                print("didUpdateLocations ", region)
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

class BucketTapGesture: UITapGestureRecognizer{
    var bucketItem: BucketItem!
}









