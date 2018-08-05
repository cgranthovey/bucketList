//
//  DataService.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/11/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import Geofirestore

class DataService{
    
    fileprivate static var _instance = DataService()
    static var instance: DataService{
        return _instance
    }
    
    var bucketListRef: CollectionReference{
        return Firestore.firestore().collection("BucketList")
    }
    
    var geoFirestore: GeoFirestore{
        var geo = Firestore.firestore().collection("GeoHash")
        var geoFirestore = GeoFirestore(collectionRef: geo)
        return geoFirestore
    }
    
    var usersRef: CollectionReference{
        return Firestore.firestore().collection("users")
    }
    
    var currentUserDoc: DocumentReference{
        print("currentUserDoc", CurrentUser.instance.user)
        print("currentUserDoc2", CurrentUser.instance.user.uid)
        return Firestore.firestore().collection("users").document(CurrentUser.instance.user.uid)
    }
    var currentUserFriends: CollectionReference{
        return currentUserDoc.collection("friends")
    }
    
    

}
