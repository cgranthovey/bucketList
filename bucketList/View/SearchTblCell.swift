//
//  SearchTblCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/14/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import MapKit

class SearchTblCell: UITableViewCell {

    @IBOutlet weak var primaryLbl: UILabel!
    @IBOutlet weak var secondaryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(location: MKLocalSearchCompletion){
        primaryLbl.text = location.title
        secondaryLbl.text = location.subtitle
    }

}
