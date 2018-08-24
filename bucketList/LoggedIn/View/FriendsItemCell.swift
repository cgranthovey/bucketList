//
//  FriendsItemCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/14/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class FriendsItemCell: BaseCell {
    
    
//    var lblName: UILabel!
    
    lazy var lblName: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.backgroundColor = UIColor.magenta
        return lbl
    }()
    
    override func setUpViews() {
        self.addSubview(lblName)
        lblName.translatesAutoresizingMaskIntoConstraints = false
//        let leftConstraint = NSLayoutConstraint(item: lblName, attribute: .leftMargin, relatedBy: .equal, toItem: self, attribute: .leftMargin, multiplier: 1, constant: 20)
        let bottomConstraint = NSLayoutConstraint(item: lblName, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10)
        
        let xConstraint = NSLayoutConstraint(item: lblName, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: lblName, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        let widthConstraint = NSLayoutConstraint(item: lblName, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        self.addConstraints([bottomConstraint, xConstraint, heightConstraint, widthConstraint])
    }
    
    func configure(user: User){
        lblName.text = user.fullName
//        lblName.backgroundColor = UIColor.orange
    }
    
}
