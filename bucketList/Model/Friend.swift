//
//  Friend.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/26/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation

class Friend{
    var fname: String?
    var lname: String?
    var profileURL: String?
    var status: String?
    var id: String?
    
    var fullName: String{
        return [fname, lname].compactMap{$0}.joined(separator: " ")
    }
    
    init(data: Dictionary<String, Any>, id: String){
        if let fname = data["fname"] as? String{
            self.fname = fname
        }
        if let profileURL = data["profileURL"] as? String{
            self.profileURL = profileURL
        }
        if let status = data["status"] as? String{
            self.status = status
        }
        
        self.id = id
        
    }
    
}

