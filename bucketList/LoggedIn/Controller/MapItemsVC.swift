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
    var geoQuery: GFSRegionQuery?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMap()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        if let query = geoQuery{
//            query.removeAllObservers()
//        }
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
        geoQuery = DataService.instance.geoFirestore.query(inRegion: region)
        if let query = geoQuery{
            let geoQueryEnterHandle = query.observe(.documentEntered) { (key, location) in
                if let key = key, let location = location{

                }
            }
        }
//        let geoQueryExit = DataService.instance.geoFirestore.query(inRegion: region)
//        let geoQueryExitHandle = geoQueryExit.observe(.documentExited) { (key, location) in
//            if let key = key, let location = location{
//
//                let annotations = self.mapView.annotations
//
//                for annotation in annotations{
//                    if annotation.title == key{
//                        self.mapView.removeAnnotation(annotation)
//                        print("remove annotation")
//                    }
//                }
//            }
//        }
        
    }
    
    func getBucketItem(key: String, location: CLLocation){
        DataService.instance.bucketListRef.document(key).getDocument(completion: { (snapshot, error) in
            guard error == nil else{
                print("error getting document", error)
                return
            }
            if let snapshot = snapshot, let data = snapshot.data(){
                self.makeAnnotation(data: data, location: location)
            }
        })
    }
    
    func makeAnnotation(data: [String: Any], location: CLLocation ){
        let newPin = BucketMKPointAnnotation()
        let bucketItem = BucketItem.init(dict: data)
        newPin.bucketItem = bucketItem
        
        newPin.coordinate = location.coordinate
        if let title = bucketItem.title{
            newPin.title = title
        }
        if let subtitle = bucketItem.addressPrimary{
            newPin.subtitle = subtitle
        }
        self.mapView.addAnnotation(newPin)
        
    }
}

extension MapItemsVC: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let reusePin = "pin"
        
        let pinView: MKMarkerAnnotationView!
        if let pin = mapView.dequeueReusableAnnotationView(withIdentifier: reusePin) as? MKMarkerAnnotationView{
            pinView = pin
        } else{
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reusePin)
        }
        
        pinView?.markerTintColor = UIColor.green
        pinView?.canShowCallout = true
        
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setImage(#imageLiteral(resourceName: "diver"), for: .normal)
        //button.addTarget(self, action: #selector(AnnotationMapVC.annotationBtnTapped(_:)), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 1//currentBtnTag
        pinView?.tag = 2// currentBtnTag
        
        //self.dictEnterTagForEventKey[currentBtnTag] = myEvent!.key
        //currentBtnTag = currentBtnTag + 1
        let yellowView = UIView(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        view.backgroundColor = UIColor.yellow
        pinView?.detailCalloutAccessoryView = yellowView
        pinView?.leftCalloutAccessoryView = button
        
        print("left callout0 - ")

        if let pin = pinView{
            
            return pin
        }
        return nil
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











