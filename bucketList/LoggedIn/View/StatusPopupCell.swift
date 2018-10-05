//
//  StatusPopupCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 10/4/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class StatusPopupCell: UITableViewCell {
    
    @IBOutlet weak var lbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(text: String){
        lbl.text = text
    }
    
}
