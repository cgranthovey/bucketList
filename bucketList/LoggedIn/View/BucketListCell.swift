//
//  BucketListCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/19/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class BucketListCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(item: BucketItem){
        lblTitle.text = item.title
        if let details = item.details{
            lblDetails.text = details
        }
        if let address = item.addressPrimary{
            lblAddress.text = address
        }
        if let price = item.price{
            lblPrice.text = price
        }
    }
    
    

}
