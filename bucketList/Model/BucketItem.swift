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
import FirebaseAuth

enum ItemStatus: String{
    case toDo = "To Do"
    case inProgress = "In Progress"
    case complete = "Complete"
}

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
    var completionTime: String?
    var status: ItemStatus = .toDo
    
    var isTravel: Bool = false
    var isNature: Bool = false
    var isEducation: Bool = false
    var isSports: Bool = false
    var isSocial: Bool = false
    var isReligion: Bool = false
    var isExercise: Bool = false
    var isArt: Bool = false
    var isHistory: Bool = false
    
    lazy var isItems: [Bool] = {
        return [isTravel, isNature, isEducation, isSports, isSocial, isReligion, isExercise, isArt, isHistory]
    }()
    
    lazy var hasIsItem: Bool = {
        let items = [isTravel, isNature, isEducation, isSports, isSocial, isReligion, isExercise, isArt, isHistory]
        for item in items{
            if item == true{
                return true
            }
        }
        return false
    }()
    
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

            if let travel = dict["isTravel"] as? Bool{
                isTravel = travel
            }
            if let nature = dict["isNature"] as? Bool{
                isNature = nature
            }
            if let education = dict["isEducation"] as? Bool{
                isEducation = education
            }
            if let sports = dict["isSports"] as? Bool{
                isSports = sports
            }
            if let social = dict["isSocial"] as? Bool{
                isSocial = social
            }
            if let religion = dict["isReligion"] as? Bool{
                isReligion = religion
            }
            if let exercise = dict["isExercise"] as? Bool{
                isExercise = exercise
            }
            if let art = dict["isArt"] as? Bool{
                isArt = art
            }
            if let history = dict["isHistory"] as? Bool{
                isHistory = history
            }
            if let status = dict["status"] as? String{
                if status == ItemStatus.inProgress.rawValue{
                    self.status = .inProgress
                } else if status == ItemStatus.complete.rawValue{
                    self.status = .complete
                } else{
                    self.status = .toDo
                }
            }
            completionTime = dict["completionTime"] as? String
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
            "pinLong": pinLong as Any,
            "completionTime": completionTime as Any,
            "userID": CurrentUser.instance.user.uid
        ]
        
        isTravel ? items["isTravel"] = true : Void()
        isNature ? items["isNature"] = true : Void()
        isEducation ? items["isEducation"] = true : Void()
        isSports ? items["isSports"] = true : Void()
        isSocial ? items["isSocial"] = true : Void()
        isReligion ? items["isReligion"] = true : Void()
        isExercise ? items["isExercise"] = true : Void()
        isArt ? items["isArt"] = true : Void()
        isHistory ? items["isHistory"] = true: Void()
        
        items["status"] = status.rawValue
        
        items["created"] = FieldValue.serverTimestamp()
        if let geoLoc = getGeoPoint(){
            items["location"] = geoLoc
        }
        return items
    }

}
