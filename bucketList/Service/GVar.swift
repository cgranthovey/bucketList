//
//  GVar.swift
//  bucketList
//
//  Created by Christopher Hovey on 10/2/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import UIKit

class GVar{
    
    fileprivate static var _instance = GVar()
    static var instance: GVar{
        return _instance
    }
    
    var keyboardToButton: CGFloat{
        return 7
    }
    
}
