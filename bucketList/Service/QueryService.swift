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
    var categoryFilter: String?
    var priceFilter: String?
    var timeFilter: String?
    
    
}
