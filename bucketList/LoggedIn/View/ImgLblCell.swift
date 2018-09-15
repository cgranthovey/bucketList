//
//  ImgLblCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/12/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

struct txtImg {
    var txt: String
    var img: UIImage
}

class ImgLblCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var imgViewChecked: UIImageView!
    
    func configure(object: txtImg){
        imgView.image = object.img
        lbl.text = object.txt
        imgViewChecked.isHidden = true
    }
}
