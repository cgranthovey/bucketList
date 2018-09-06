//
//  DetailDataCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/4/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class DetailDataCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true

    }
    
    
    func configure(item: BucketItem){
        
        lblTitle.text = lblTitle.text
        
        if let price = item.price, price == "" {
            lblPrice.text = price
            lblPrice.isHidden = false
        } else{
            lblPrice.isHidden = true
        }
        btnAddress.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        if let details = item.details{
            lblDetails.text = details
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




















