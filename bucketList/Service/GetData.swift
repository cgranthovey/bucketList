//
//  GetData.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/19/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class GetData{
    fileprivate static var _instance = GetData()
    
    static var instance: GetData{
        return _instance
    }
    
    
    var limit = 7
    
    
    typealias Completion = (_ items: QuerySnapshot, _ lastDoc: DocumentSnapshot?) -> Void
    func retrieve(query: Query, onComplete: @escaping Completion){
        
        query.getDocuments { (snapshot, error) in
            
            guard error == nil && snapshot != nil else{
                print("retrieve snapshot error2", error!)
                return
            }
            onComplete(snapshot!, snapshot!.documents.last)
        }
        
//        let query = collection.order(by: "created", descending: true).limit(to: limit)
//
//
//
//
//        if let doc = lastDoc{
//            query.start(afterDocument: doc).getDocuments { (snapshot, error) in
//                guard error == nil && snapshot != nil else{
//                    print("retrieve snapshot error1", error!)
//                    return
//                }
//                onComplete(snapshot!, snapshot!.documents.last)
//            }
//        } else{
//            print("my query", query)
//            query.getDocuments { (snapshot, error) in
//
//                guard error == nil && snapshot != nil else{
//                    print("retrieve snapshot error2", error!)
//                    return
//                }
//                onComplete(snapshot!, snapshot!.documents.last)
//            }
//        }
    }
    

    private func getBucket(snapshot: QuerySnapshot?)->(data: [Any], lastDoc: DocumentSnapshot?){
        var bucketItems = [Any]()
        var lastDoc: DocumentSnapshot?
        if let snapshot = snapshot{
            for item in snapshot.documents{
                bucketItems.append(item.data())
                lastDoc = item
            }
        }
        return (bucketItems, lastDoc)
    }

}














