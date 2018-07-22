//
//  GetData.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/19/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import Firebase

class GetData{
    fileprivate static var _instance = GetData()
    
    static var instance: GetData{
        return _instance
    }
    
    var lastDoc: DocumentSnapshot?
    var limit = 10
    
    
    typealias Completion = (_ items: [BucketItem]) -> Void
    func retrieve(onComplete: @escaping Completion){
        if let doc = lastDoc{
            Firestore.firestore().collection("BucketList").start(afterDocument: doc).limit(to: limit).getDocuments { (snapshot, error) in
                guard error == nil else{
                    print("retrieve snapshot error", error!)
                    return
                }
                let bucket = self.getBucket(snapshot: snapshot)
                onComplete(bucket)
            }
            
        } else{
            Firestore.firestore().collection("BucketList").limit(to: 10).getDocuments { (snapshot, error) in
                guard error == nil else{
                    print("retrieve snapshot error", error!)
                    return
                }
                let bucket = self.getBucket(snapshot: snapshot)
                onComplete(bucket)
            }
        }
    }
    

    private func getBucket(snapshot: QuerySnapshot?)->[BucketItem]{
        var bucketItems = [BucketItem]()
        if let snapshot = snapshot{
            for item in snapshot.documents{
                let bucketItem = BucketItem(dict: item.data())
                bucketItems.append(bucketItem)
                self.lastDoc = item
            }
        }
        return bucketItems
    }

}














