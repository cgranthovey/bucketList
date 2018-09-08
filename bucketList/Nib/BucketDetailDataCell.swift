//
//  BucketDetailDataCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/6/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class BucketDetailDataCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnAddress: UIButton!
    
    @IBAction func addressBtnPress(_ sender: AnyObject){
        
    }
    
    func configure(item: BucketItem){
        print("item.title", item.title)
        lblTitle.text = item.title
        
        if let price = item.price, price == "" {
            lblPrice.text = price
            lblPrice.isHidden = false
        } else{
            lblPrice.isHidden = true
        }
        btnAddress.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        if let details = item.details{
            lblDescription.text = details
        }
        
        var addressDisplay = ""
        if let addressPrimary = item.addressPrimary, let addressSecondary = item.addressSeconary{
            addressDisplay = "\(addressPrimary)\n\(addressSecondary)"
        } else if let addressPrimary = item.addressPrimary{
            addressDisplay = addressPrimary
        } else if let addressSecondary = item.addressSeconary{
            addressDisplay = addressSecondary
        }
        if addressDisplay == ""{
            btnAddress.isHidden = true
        } else{
            btnAddress.isHidden = false
            btnAddress.setTitleWithoutAnimation(title: addressDisplay)
        }
    }
    
}
