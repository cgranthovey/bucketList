//
//  NewBucketItem.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/11/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation

class NewBucketItem{
    
    fileprivate static var _instance = NewBucketItem()
    static var instance: NewBucketItem{
        return _instance
    }
    
    var item: BucketItem = BucketItem()
    
    func clearItem(){
        
        item = BucketItem()
    }
}
