//
//  QueryService.swift
//  bucketList
//
//  Created by Christopher Hovey on 10/6/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation

class QueryService {
    
    fileprivate static var _instance = QueryService()
    static var instance: QueryService {
        return _instance
    }
    
    var statusFilter: String?
    var categoryStrFilter: String?
    
    var categoryIsFilter: String?{
        for item in BucketOptions.instance.allCategories{
            if item.txt == categoryStrFilter{
                return "is\(item.txt)"
            }
        }
        return nil
    }
    
    var priceFilter: String?
    var timeFilter: String?
    
    func clear(){
        statusFilter = nil
        categoryStrFilter = nil
        priceFilter = nil
        timeFilter = nil
    }
    
    
}
