//
//  CollectionViewCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/6/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell{
    class func fromNib<T: UICollectionViewCell>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
