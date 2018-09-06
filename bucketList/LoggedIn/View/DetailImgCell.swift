//
//  DetailImgCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/4/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class DetailImgCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    func configure(imgUrl: String){
        if let url = URL(string: imgUrl){
            imgView.sd_setImage(with: url, placeholderImage: nil, options: .progressiveDownload, progress: nil, completed: nil)
        }
    }
}
