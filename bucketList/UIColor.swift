//
//  UIColor.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/11/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor{
        return UIColor(displayP3Red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
}
