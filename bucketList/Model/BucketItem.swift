//
//  BucketItem.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/11/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import MapKit
import FirebaseCore
import Firebase
import FirebaseFirestore

class BucketItem{
    var title: String!
    var price: String?
    var location: String?
    var details: String?
    var addressPrimary: String?
    var addressSeconary: String?
    var pinLat: String?
    var pinLong: String?
    var created: String?
    var createdDate: Date?
    var id: String?
    var imgs: [String] = [String]()
    
    func addressFull() -> String?{
        let address = [addressPrimary, addressSeconary].compactMap{$0}.joined(separator: ", ")
        return address
    }
    
    func coordinate2D() -> CLLocationCoordinate2D?{
        guard let lat = pinLat, let long = pinLong else{
            return nil
        }
        guard let latDoub = Double(lat), let longDoub = Double(long) else{
            return nil
        }
        let coordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees.init(latDoub), CLLocationDegrees.init(longDoub))
        return coordinate2D
    }
    
    func getGeoPoint()->GeoPoint?{
        guard let lat = pinLat, let long = pinLong else{
            return nil
        }
        guard let latDoub = Double(lat), let longDoub = Double(long) else{
            return nil
        }
        return GeoPoint(latitude: latDoub, longitude: longDoub)
    }
    
    func clearAddress(){
        addressPrimary = nil
        addressSeconary = nil
        pinLat = nil
        pinLong = nil
    }
    
    init (dict: Dictionary<String, Any>?, id: String? = nil){
        if let dict = dict{
            title = dict["title"] as? String
            price = dict["price"] as? String
            location = dict["location"] as? String
            details = dict["details"] as? String
            addressPrimary = dict["addressPrimary"] as? String
            addressSeconary = dict["addressSecondary"] as? String
            pinLat = dict["pinLat"] as? String
            pinLong = dict["pinLong"] as? String

        }
        if let id = id{
            self.id = id
        }
    }
    
    
    
    func itemsToPost()->[String: Any]{
        var items: [String: Any] = [
            "title": title as Any,
            "price": price as Any,
            "location": location as Any,
            "details": details as Any,
            "addressPrimary": addressPrimary as Any,
            "addressSeconary": addressSeconary as Any,
            "pinLat": pinLat as Any,
            "pinLong": pinLong as Any
        ]
        
        
        
        items["created"] = FieldValue.serverTimestamp()
        if let geoLoc = getGeoPoint(){
            items["location"] = geoLoc
        }
        return items
    }

}
