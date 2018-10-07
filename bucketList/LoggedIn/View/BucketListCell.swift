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
    @IBOutlet weak var imgTravel: UIImageView!
    @IBOutlet weak var imgHistory: UIImageView!
    @IBOutlet weak var imgArt: UIImageView!
    @IBOutlet weak var imgExercise: UIImageView!
    @IBOutlet weak var imgReligion: UIImageView!
    @IBOutlet weak var imgSocial: UIImageView!
    @IBOutlet weak var imgSports: UIImageView!
    @IBOutlet weak var imgEducation: UIImageView!
    @IBOutlet weak var imgNature: UIImageView!
    @IBOutlet weak var stackCategories: UIStackView!
    
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
            lblDetails.isHidden = false
        } else{
            lblDetails.isHidden = true
        }
        if let address = item.addressPrimary{
            lblAddress.text = address
            lblAddress.isHidden = false
        } else {
            lblAddress.isHidden = true
        }
        
        lblPrice.text = item.status.rawValue
        if item.status == .complete{
            lblPrice.textColor = UIColor().primaryGreen
        } else if item.status == .inProgress {
            lblPrice.textColor = UIColor().primaryColor
        } else{
            lblPrice.textColor = UIColor().darkerBlue
        }
//        if let price = item.price{
//            lblPrice.text = price
//            lblPrice.isHidden = false
//        } else{
//            lblPrice.isHidden = true
//        }
        
        print("item is sports", item.isSports)
        print("item is education", item.isEducation)
        print("is travel", item.isTravel)
        
        if item.hasIsItem{
            if item.isTravel{imgTravel.isHidden = false} else{imgTravel.isHidden = true}
            if item.isHistory{imgHistory.isHidden = false} else{imgHistory.isHidden = true}
            if item.isArt{imgArt.isHidden = false} else{imgArt.isHidden = true}
            if item.isExercise{imgExercise.isHidden = false} else{imgExercise.isHidden = true}
            if item.isReligion{imgReligion.isHidden = false} else{imgReligion.isHidden = true}
            if item.isSocial{imgSocial.isHidden = false} else{imgSocial.isHidden = true}
            if item.isSports{imgSports.isHidden = false} else{imgSports.isHidden = true}
            if item.isEducation{imgEducation.isHidden = false} else{imgEducation.isHidden = true}
            if item.isNature{imgNature.isHidden = false} else{imgNature.isHidden = true}
        } else{
            stackCategories.isHidden = true
        }
        

        
//        item.isTravel = true ? imgTravel.isHidden = false : imgTravel.isHidden = true
//        item.isHistory = true ? imgHistory.isHidden = false : imgHistory.isHidden = true
//        item.isArt ? (imgArt.isHidden = false) : (imgArt.isHidden = true)
//        item.isExercise = true ? imgExercise.isHidden = false : imgExercise.isHidden = true
//        item.isReligion = true ? imgReligion.isHidden = false : imgReligion.isHidden = true
//        item.isSocial = true ? imgSocial.isHidden = false : imgSocial.isHidden = true
//        item.isSports = true ? imgSports.isHidden = false : imgSports.isHidden = true
//        item.isEducation = true ? imgEducation.isHidden = false : imgEducation.isHidden = true
//        item.isNature = true ? imgNature.isHidden = false : imgNature.isHidden = true
    }
    
    

}
