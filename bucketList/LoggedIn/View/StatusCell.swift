//
//  StatusCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 10/3/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

protocol StatusCellDelegate{
    func statusBtnPress(btn: UIButton)
}

class StatusCell: UICollectionViewCell {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    
    var delegate: StatusCellDelegate!
    
    override func awakeFromNib() {
        btnStatus.titleLabel?.numberOfLines = 1
        btnStatus.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func setBtnStatus(status: ItemStatus, withAnimation: Bool = true){
        if withAnimation{
            btnStatus.setTitle(status.rawValue, for: .normal)
        } else{
            btnStatus.setTitleWithoutAnimation(title: status.rawValue)
        }
        
        switch status{
        case .toDo: btnStatus.setTitleColor(UIColor().darkerBlue, for: .normal)
        case .inProgress: btnStatus.setTitleColor(UIColor().primaryColor, for: .normal)
        case .complete: btnStatus.setTitleColor(UIColor().primaryGreen, for: .normal)
        }
    }
    
    
    
    func configure(bucketItem: BucketItem){
        if let price = bucketItem.price{
            lblPrice.text = price
        }
        if let time = bucketItem.completionTime{
            lblTime.text = time
        }
        print("bucket item status", bucketItem.status)
        setBtnStatus(status: bucketItem.status, withAnimation: false)
    }
    
    @IBAction func statusBtnPress(_ sender: AnyObject){
        delegate.statusBtnPress(btn: btnStatus)
    }
    
}














