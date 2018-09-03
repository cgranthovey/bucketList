//
//  Button.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/3/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class AddNextBtn: UIButton {

    
    override func draw(_ rect: CGRect) {
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor().primaryBlue
        self.titleLabel?.font = UIFont().primary(size: 17)
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
