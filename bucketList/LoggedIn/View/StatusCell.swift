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
    
    func configure(bucketItem: BucketItem){
        if let price = bucketItem.price{
            lblPrice.text = price
        }
        if let time = bucketItem.completionTime{
            lblTime.text = time
        }
        if let status = bucketItem.status{
            switch status{
                case ItemStatus.completed.rawValue: btnStatus.setTitleWithoutAnimation(title: ItemStatus.completed.rawValue)
                case ItemStatus.inProgress.rawValue: btnStatus.setTitleWithoutAnimation(title: ItemStatus.inProgress.rawValue)
                default: btnStatus.setTitleWithoutAnimation(title: ItemStatus.toDo.rawValue)
            }
        } else {
            btnStatus.setTitleWithoutAnimation(title: ItemStatus.toDo.rawValue)
        }
    }
    
    @IBAction func statusBtnPress(_ sender: AnyObject){
        delegate.statusBtnPress(btn: btnStatus)
    }
    
}














