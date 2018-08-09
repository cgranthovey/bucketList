//
//  TextField.swift
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
    
    func isGoodPassword(otherTF: UITextField)-> (isGood: Bool, error: String?){
        self.layer.borderWidth = 0
        otherTF.layer.borderWidth = 0
        
        guard self.text != nil && otherTF.text != nil else{
            self.showError()
            return (isGood: false, error:"Fill in password field")
        }
        
        guard self.text!.count >= 6 else{
            self.showError()
            return (isGood: false, error:"Password must be at least 6 characters")
        }
        
        let characterSet = NSCharacterSet.whitespaces
        guard self.text!.rangeOfCharacter(from: characterSet) == nil else{
            self.showError()
            return (isGood: false, error:"Password may not have any spaces")
        }
        
        guard self.text! == otherTF.text! else{
            self.showError()
            otherTF.showError()
            return (isGood: false, error:"Passwords do not match")
        }
        

        
        return (isGood: true, error: nil)
    }
}

extension Array where Element: UITextField {
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
    func clearError(){
        for item in self{
            item.layer.borderWidth = 0
        }
    }
}
