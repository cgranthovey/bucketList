//
//  ViewCustom.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/3/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class NavView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {   
        super.init(coder: aDecoder)

        backgroundColor = UIColor().primaryColor

    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
