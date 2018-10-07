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
        return UIColor(displayP3Red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    var lightGrey: UIColor{
        return rgb(red: 238, green: 238, blue: 238, alpha: 1)
    }
    var extraLightGrey: UIColor{
        return rgb(red: 246, green: 246, blue: 246, alpha: 1)
    }
    var mediumGrey: UIColor{
        return rgb(red: 189, green: 189, blue: 189, alpha: 1)
    }
    var deactiveDark: UIColor{
        return rgb(red: 91, green: 14, blue: 13, alpha: 1)
    }
    
    var primaryColor: UIColor{
        return rgb(red: 247, green: 180, blue: 68, alpha: 1)
    }
    var primaryBlue: UIColor{
        return rgb(red: 0, green: 178, blue: 255, alpha: 1)
    }
    var darkerBlue: UIColor{
        return rgb(red: 28, green: 137, blue: 200, alpha: 1)
    }
    var primaryGreen: UIColor{
        return rgb(red: 32, green: 163, blue: 0, alpha: 1)
    }
    var primaryBlueAlpha: UIColor{
        return rgb(red: 0, green: 178, blue: 255, alpha: 0.3)
    }
    
    var textBlack: UIColor{
        return rgb(red: 0, green: 0, blue: 0, alpha: 0.87)
    }
    var secondaryBlack: UIColor{
        return rgb(red: 0, green: 0, blue: 0, alpha: 0.54)
    }
    var disabledBlack: UIColor{
        return rgb(red: 0, green: 0, blue: 0, alpha: 0.38)
    }
    
}
