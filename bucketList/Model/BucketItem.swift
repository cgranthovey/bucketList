//
//  BucketItem.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/11/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation

class BucketItem{
    var title: String!
    var price: String?
    var location: String?
    var details: String?
    
    func allItems()->[String: Any]{
        
        
        
        return [
            "title": title,
            "price": price,
            "location": location,
            "details": details
        ]
    }

}
