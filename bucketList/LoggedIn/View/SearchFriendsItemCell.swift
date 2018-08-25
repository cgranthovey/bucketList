//
//  SearchFriendsItemCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/25/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class SearchFriendsItemCell: BaseCell {
    
    var imgView: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var lblName: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.font = UIFont().primary(size: 20)
        return lbl
    }()
    
    override func setUpViews() {
        
        self.backgroundColor = UIColor().lightGrey
        
        self.addSubview(imgView)
        let topAnchor: CGFloat = 10
        let bottomAnchor: CGFloat = 10
        
        let imgHeight = self.frame.height - topAnchor - bottomAnchor
        print("img height", imgHeight)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: topAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: imgHeight).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: imgHeight).isActive = true
        imgView.clipsToBounds = true

        
        self.addSubview(lblName)
        lblName.translatesAutoresizingMaskIntoConstraints = false
        lblName.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 20).isActive = true
        lblName.topAnchor.constraint(equalTo: imgView.topAnchor, constant: 10).isActive = true
    }
    
    func configure(user: User){
        if let urlStr = user.profileURL{
            let url = URL(string: urlStr)
            imgView.sd_setImage(with: url, placeholderImage: nil, options: .progressiveDownload) { (img, error, cache, url) in
            }
        }
        lblName.text = user.fullName
    }
    
    
    
}
