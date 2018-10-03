//
//  BtnOutline.swift
//  bucketList
//
//  Created by Christopher Hovey on 10/2/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class BtnOutline: UIButton {

    override func awakeFromNib() {
        layer.borderColor = UIColor().primaryColor.cgColor
        setTitleColor(UIColor().primaryColor, for: .normal)
        
        
        backgroundColor = UIColor.clear
        layer.borderWidth = 3
        layer.cornerRadius = 10
        clipsToBounds = true
    }

}
