//
//  LblArrowCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/15/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class LblArrowCell: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let lightBg = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        lightBg.backgroundColor = UIColor().lightGrey
        selectedBackgroundView = lightBg
        // Initialization code
    }

    func configure(str: String){
        lbl.text = str
    }

}
