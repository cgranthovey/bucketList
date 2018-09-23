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
    
    override func awakeFromNib() {
        
        
    }
    
    func configure(imgUrl: Any){
        if let imgUrl = imgUrl as? String{
            if let url = URL(string: imgUrl){
                imgView.sd_setImage(with: url, placeholderImage: nil, options: .progressiveDownload, progress: nil, completed: nil)
            }
        }
        if let img = imgUrl as? UIImage{
            imgView.image = img
        }
        hideLightView()
    }
    
    func showUploading(){
        showLightLoader()
    }
    
    func uploadFail(){
        failedViewOut {
            print("failed view out!")
        }
    }
    
    func uploadSuccess(){
        successViewOut {
            print("uploadSuccess2!")
        }
    }
    
}
