//
//  FriendsItemCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/14/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class FriendsItemCell: BaseCell {
    
    
//    var lblName: UILabel!
    
    lazy var imgView: UIImageView = {
       let iv = UIImageView(frame: .zero)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var lblName: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.font = UIFont().primary(size: 17)
        return lbl
    }()
    
    override func setUpViews() {
        self.addSubview(lblName)
        
        let lblFromBottom: CGFloat = 3
        let lblHeight: CGFloat = 25.0
        let imgFromLbl: CGFloat = 3
        let imgFromTop: CGFloat = 10.0
        
        lblName.translatesAutoresizingMaskIntoConstraints = false
        lblName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1 * lblFromBottom).isActive = true
        lblName.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lblName.heightAnchor.constraint(equalToConstant: lblHeight).isActive = true

        self.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        let imgHeight = self.frame.height - lblFromBottom - lblHeight - imgFromTop - imgFromLbl
        let imgLeftSpace: CGFloat = (self.frame.height - imgHeight) / 2
        
//        imgView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: imgHeight).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: imgHeight).isActive = true
        imgView.leftAnchor.constraint(lessThanOrEqualTo: self.leftAnchor, constant: imgLeftSpace).isActive = true
        imgView.topAnchor.constraint(lessThanOrEqualTo: self.topAnchor, constant: imgFromTop).isActive = true

        
    }
    
    func configure(user: User){
        lblName.text = user.fullName
        if let urlStr = user.profileURL{
            let url = URL(string: urlStr)
            imgView.sd_setImage(with: url, placeholderImage: nil, options: .progressiveDownload) { (img, err, cache, url) in
            }
        }
        imgView.layer.cornerRadius = imgView.frame.width / 2
//        lblName.backgroundColor = UIColor.orange
    }
    
}
