//
//  UIImageView.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/9/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import UIKit
import AVKit

extension UIImageView{
    var imageSize: CGSize{
        if let image = image{
            return AVMakeRect(aspectRatio: image.size, insideRect: bounds).size
        }
        return CGSize.zero
    }
}
