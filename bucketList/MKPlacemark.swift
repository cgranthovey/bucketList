//
//  MKPlacemark.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/13/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import MapKit

extension MKPlacemark{
//    func getAddress()->String{
//        let addressThorough = [subThoroughfare, thoroughfare].compactMap{$0}.joined(separator: " ")
//        let thoroughLocality = [addressThorough, locality].compactMap({$0}).joined(separator: ", ")
//        let fullAddress = [thoroughLocality, administrativeArea].compactMap({$0}).joined(separator: " ")
//        return fullAddress
//    }
    
    func getAddress() -> String{
        let firstSpace = (subThoroughfare != nil && thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (subThoroughfare != nil || thoroughfare != nil) && (subAdministrativeArea != nil || administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (subAdministrativeArea != nil && administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            subThoroughfare ?? "",
            firstSpace,
            // street name
            thoroughfare ?? "",
            comma,
            // city
            locality ?? "",
            secondSpace,
            // state
            administrativeArea ?? ""
        )
        return addressLine
    }
}
