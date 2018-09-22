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
        isUserInteractionEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ItemDataCell.tapped))
        addGestureRecognizer(tap)
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 500, height: 1000)
    }
    
    @objc func tapped(){
        print("tapped")
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
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBAction func addressBtnPress(_ sender: AnyObject){
        print("address btn press!")

    }
    
    func configure(item: BucketItem){
        print("item.title", item.title)
        print("item.details", item.details)
        print("item.addressFull", item.addressFull())
        print("item.price", item.price)
        
        
        if let price = item.price, price != "" {
            lblPrice.text = price
            lblPrice.isHidden = false
        } else{
            lblPrice.isHidden = true
        }
        
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
        } else{
        }

    }

}
