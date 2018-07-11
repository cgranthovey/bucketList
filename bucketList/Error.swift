//
//  Error.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/6/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation

enum AuthSubmitType{
    case login
    case createAccount
    case forgotPassword
}

extension Error{
    
    func customAuthError(submitType: AuthSubmitType) -> String{
        print("custom create error - ", self.localizedDescription)

        switch self.localizedDescription {
        case "The email address is badly formatted.":
            return "The email address is badly formatted."
        case "The email address is already in use by another account.":
            return "The email address is already in use by another account."
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
            return "A user with this email could not be found."
        case "The password is invalid or the user does not have a password.":
            return "Invalid password."
            
        default:
            if submitType == .createAccount{
                return "Error creating account."
            } else if submitType == .forgotPassword{
                return "Error sending password reset."
            } else if submitType == .login{
                return "Error logging in."
            }
            return "Error occurred."
        }
    }
    
    
    
}
