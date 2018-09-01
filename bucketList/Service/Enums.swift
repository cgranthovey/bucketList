//
//  Enums.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/31/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation

enum FriendStatus: String{
    case friend = "Friend"
    case requestSent = "Request Sent"
    case requestReceived = "Request Received"
    case blocked = "Blocked"
}

enum AuthSubmitType{
    case login
    case createAccount
    case forgotPassword
    case updatingPassword
    case updatingEmail
    case validatingEmailPassword
}

enum UserCellBtnActions{
    case acceptRequest
    case declineRequest
    case block
    case cancelRequest
    case sendRequest
}
