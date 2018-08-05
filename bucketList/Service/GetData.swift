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
    
    
    var limit = 10
    
    
    typealias Completion = (_ items: [Any], _ lastDoc: DocumentSnapshot?) -> Void
    func retrieve(collection: CollectionReference, lastDoc: DocumentSnapshot?, onComplete: @escaping Completion){
        if let doc = lastDoc{
            collection.start(afterDocument: doc).limit(to: limit).getDocuments { (snapshot, error) in
                guard error == nil else{
                    print("retrieve snapshot error1", error!)
                    return
                }
                let bucketInfo = self.getBucket(snapshot: snapshot)
                onComplete(bucketInfo.data, bucketInfo.lastDoc)
            }
            
        } else{
            collection.limit(to: 10).getDocuments { (snapshot, error) in
                guard error == nil else{
                    print("retrieve snapshot error2", error!)
                    return
                }
                let bucketInfo = self.getBucket(snapshot: snapshot)
                onComplete(bucketInfo.data, bucketInfo.lastDoc)
            }
        }
    }
    

    private func getBucket(snapshot: QuerySnapshot?)->(data: [Any], lastDoc: DocumentSnapshot?){
        var bucketItems = [Any]()
        var lastDoc: DocumentSnapshot?
        if let snapshot = snapshot{
            for item in snapshot.documents{
                //let bucketItem = BucketItem(dict: item.data())
                bucketItems.append(item.data())
                lastDoc = item
            }
        }
        return (bucketItems, lastDoc)
    }

}














