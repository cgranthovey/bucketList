//
//  DetailsCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/20/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

protocol DetailsCellDelegate{
    func goToAddress(bucketItem: BucketItem)
}

class DetailsCell: UICollectionViewCell {
    
    @IBOutlet weak var btnAddress: UIButton!
    
    override func awakeFromNib() {
        btnAddress.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        btnAddress.titleLabel?.numberOfLines = 0
    }
    
    var bucketItem: BucketItem!
    var delegate: DetailsCellDelegate?
    func configure(item: BucketItem){
        bucketItem = item
        if let address = item.addressFull(){
            btnAddress.setTitleWithoutAnimation(title: address)
        }
    }
    
    @IBAction func addressBtnPress(_ sender: AnyObject){
        print("address press")
        if let del = delegate{
            del.goToAddress(bucketItem: bucketItem)
        }
    }
}
