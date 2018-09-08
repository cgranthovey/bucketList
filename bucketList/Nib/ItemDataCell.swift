//
//  ItemDataCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/6/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class ItemDataCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.autoresizingMask = .flexibleHeight
    }
    
    override func layoutSubviews() {
        layoutIfNeeded()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let originalFrame = self.frame
        let originalMaxWidth = self.lblPrice.preferredMaxLayoutWidth
        
        var frame = self.frame
        frame.size = layoutAttributes.size
        self.frame = frame
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        self.lblPrice.preferredMaxLayoutWidth = self.lblDescription.bounds.size.width
        
        let computedSize = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        let targetSize = layoutAttributes.size
        let newSize = CGSize(width: targetSize.width, height: computedSize.height)
        layoutAttributes.size = newSize
        self.frame = originalFrame
        self.lblDescription.preferredMaxLayoutWidth =  originalMaxWidth
        
        return layoutAttributes
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnAddress: UIButton!
    
    @IBAction func addressBtnPress(_ sender: AnyObject){
        
    }
    
    func configure(item: BucketItem){
        print("item.title", item.title)
        print("item.details", item.details)
        print("item.addressFull", item.addressFull())
        print("item.price", item.price)
        
        lblTitle.text = item.title
        
        if let price = item.price, price != "" {
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
