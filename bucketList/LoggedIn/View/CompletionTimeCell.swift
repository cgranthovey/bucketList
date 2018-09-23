//
//  CompletionTimeCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/22/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class CompletionTimeCell: UICollectionViewCell {
    @IBOutlet weak var lbl: UILabel!
    
    func configure(str: String){
        lbl.text = str
    }
}
