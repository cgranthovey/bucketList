//
//  lblArrowCell.swift
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
        // Initialization code
    }

    func configure(str: String){
        lbl.text = str
    }

}
