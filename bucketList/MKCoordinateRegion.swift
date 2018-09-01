//
//  MKCoordinateRegion.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/21/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import MapKit

extension MKCoordinateRegion{
    
    func isRegionValid() -> Bool{
        
        let centerLatDegrees = self.center.latitude
        let topLatDegrees = centerLatDegrees + self.span.latitudeDelta / 2
        let bottomLatDegrees = centerLatDegrees - self.span.latitudeDelta / 2
        let centerLongDegrees = self.center.longitude
        let centerTop = CLLocationCoordinate2D(latitude: topLatDegrees, longitude: centerLongDegrees)
        let centerBottom = CLLocationCoordinate2D(latitude: bottomLatDegrees, longitude: centerLongDegrees)
        
        if CLLocationCoordinate2DIsValid(centerTop) && CLLocationCoordinate2DIsValid(centerBottom){
            return true
        } else{
            return false
        }
    }
}
