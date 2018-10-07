//
//  CustomTF.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/25/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class CustomTF: UITextField {
    
    override func draw(_ rect: CGRect) {
        layer.borderColor = UIColor().mediumGrey.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        font = UIFont().primary(size: 16)
    }
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

}

class BottomLineTF: UITextField{
    override func awakeFromNib() {
    }
    
    var hasAddedToLine = false
    
    override func draw(_ rect: CGRect) {
        textColor = UIColor().secondaryBlack
        borderStyle = .none
        font = UIFont().primary(size: 25)
        adjustsFontSizeToFitWidth = false
        if !hasAddedToLine{
            hasAddedToLine = true
            print("adding line")
            self.addLineToView(position: .LINE_POSITION_BOTTOM, color: UIColor().secondaryBlack, width: 1.5)
            //self.addLineToView(position: .LINE_POSITION_BOTTOM, color: UIColor().disabledBlack, width: 1.5)
        }
    }
}

class BottomLineTFWhite: UITextField{
    override func awakeFromNib() {
    }
    
    var hasAddedToLine = false
    
    override func draw(_ rect: CGRect) {
        textColor = UIColor.white // UIColor().secondaryBlack
        borderStyle = .none
        font = UIFont().primary(size: 25)
        adjustsFontSizeToFitWidth = false
        if !hasAddedToLine{
            hasAddedToLine = true
            print("adding line")
            self.addLineToView(position: .LINE_POSITION_BOTTOM, color: UIColor.white, width: 1.5)
            //self.addLineToView(position: .LINE_POSITION_BOTTOM, color: UIColor().disabledBlack, width: 1.5)
        }
    }
}









