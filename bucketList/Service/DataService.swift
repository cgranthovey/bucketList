//
//  DataService.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/11/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import Firebase

class DataService{
    
    fileprivate static var _instance = DataService()
    static var instance: DataService{
        return _instance
    }
    
    var bucketListRef: CollectionReference{
        return Firestore.firestore().collection("BucketList")
    }

    
}
