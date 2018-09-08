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
    
    
    var limit = 20
    
    
    typealias Completion = (_ items: [Any], _ lastDoc: DocumentSnapshot?) -> Void
    func retrieve(collection: CollectionReference, lastDoc: DocumentSnapshot?, onComplete: @escaping Completion){
        
        let query = collection.order(by: "created", descending: true).limit(to: limit)
        
        if let doc = lastDoc{
            query.start(afterDocument: doc).getDocuments { (snapshot, error) in
                guard error == nil else{
                    print("retrieve snapshot error1", error!)
                    return
                }
                let bucketInfo = self.getBucket(snapshot: snapshot)
                onComplete(bucketInfo.data, bucketInfo.lastDoc)
            }
            
        } else{
            print("my query", query)
            query.getDocuments { (snapshot, error) in
                
                guard error == nil else{
                    print("retrieve snapshot error2", error!)
                    return
                }
                let bucketInfo = self.getBucket(snapshot: snapshot)
                print("my query2", bucketInfo)
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














