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
import FirebaseStorage

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
    
    var currentUserGeoFirestore: GeoFirestore{
        var geo = currentUserDoc.collection("MyGeoHash")
        var geoFirestore = GeoFirestore(collectionRef: geo)
        return geoFirestore
    }
    
    var usersRef: CollectionReference{
        return Firestore.firestore().collection("users")
    }
    
    var currentUserDoc: DocumentReference{
        print("current user doc")
        print("current user doc \(CurrentUser.instance.user)")
        print("current user doc uid \(CurrentUser.instance.user.uid)")
        return Firestore.firestore().collection("users").document(CurrentUser.instance.user.uid)
    }
    var currentUserFriends: CollectionReference{
        return currentUserDoc.collection("friends")
    }
    
    
    //var storageProfile:
    let storage = Storage.storage()
    func storageUserRef() -> StorageReference{
        return storage.reference().child("users").child(CurrentUser.instance.user.uid)
    }
    


}
