//
//  TextInput.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/9/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    func showError(){
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
    }
    
    func clearError(){
        self.layer.borderWidth = 0
    }
}

extension Array where Element: UITextField {
    typealias Completion = (_ error: Bool) -> Void
    func containsIncompleteField() -> Bool{
        var isIncomplete = false
        for item in self{
            if !item.hasText{
                item.layer.borderColor = UIColor.red.cgColor
                item.layer.borderWidth = 1
                item.layer.cornerRadius = 5
                isIncomplete = true
            }
        }
        return isIncomplete
    }
}
