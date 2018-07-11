//
//  String.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/1/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation

extension String{
    func containsWhiteSpace() -> Bool{
        let whiteSpace = NSCharacterSet.whitespaces
        if self.rangeOfCharacter(from: whiteSpace) != nil{
            return true
        } else{
            return false
        }
    }
}
