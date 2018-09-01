//
//  UIFont.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/24/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import UIKit

extension UIFont{
    func primary(size: CGFloat?)->UIFont{
        
        return UIFont.init(name: "Arial", size: (size != nil) ? CGFloat(size!) : 12)!
    }
}
