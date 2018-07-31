//
//  User.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/22/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation

class User{
    
    var fname: String?
    var lname: String?
    var email: String?
    var profileURL: String?
    var uid: String!
    
    var fullName: String{
        return [fname, lname].compactMap{$0}.joined(separator: " ")
    }
    
    func friendRequestInfo()->Dictionary<String, Any>{
        let info: Dictionary<String, Any> = [
            "fname": fname as Any,
            "lname": lname as Any,
            "profileURL": profileURL as Any,
            "uid": uid as Any
        ]
        return info
    }
    
    init(data: Dictionary<String, Any>, uid: String){
        if let fname = data["fname"] as? String{
            self.fname = fname
        }
        if let lname = data["lname"] as? String{
            self.lname = lname
        }
        if let email = data["email"] as? String{
            self.email = email
        }
        if let profileURL = data["profileURL"] as? String{
            self.profileURL = profileURL
        }
        
        self.uid = uid
        
    }
}
