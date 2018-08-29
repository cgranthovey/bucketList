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
    var lightGrey: UIColor{
        return rgb(red: 238, green: 238, blue: 238, alpha: 1)
    }
    var mediumGrey: UIColor{
        return rgb(red: 189, green: 189, blue: 189, alpha: 1)
    }
    var deactiveDark: UIColor{
        return rgb(red: 91, green: 14, blue: 13, alpha: 1)
    }
    
}
