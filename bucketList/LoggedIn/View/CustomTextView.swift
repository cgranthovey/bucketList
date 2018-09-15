//
//  CustomTextView.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/3/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        backgroundColor = UIColor().lightGrey
       // backgroundColor = UIColor.yellow
        font = UIFont().primary(size: 22)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor().extraLightGrey
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
