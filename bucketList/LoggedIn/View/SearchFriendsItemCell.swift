//
//  SearchFriendsItemCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/25/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

protocol SearchFriendsItemCellDelegate{
    func requestSent(user: User, cell: SearchFriendsItemCell)
}

class SearchFriendsItemCell: BaseCell {
    
    lazy var imgView: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var lblName: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.font = UIFont().primary(size: 20)
        return lbl
    }()
    
    lazy var lblNameSecondary: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.font = UIFont().primary(size: 20)
        lbl.alpha = 0.54
        return lbl
    }()
    
    lazy var holderView: UIView = {
        let view = UIView(frame: CGRect(x: 20, y: 0, width: self.frame.width - 40, height: self.frame.height))
        return view
    }()
    
    lazy var btnRequest: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.addTarget(self, action: #selector(SearchFriendsItemCell.requestBtnPress), for: .touchUpInside)
        btn.setTitle("Send Request", for: .normal)
        btn.backgroundColor = .orange
        btn.titleLabel?.textColor = .white
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont().primary(size: 16)
        
        return btn
    }()
    
    var user: User!
    var delegate: SearchFriendsItemCellDelegate?
    
    override func setUpViews() {
        
        addSubview(holderView)
        holderView.backgroundColor = UIColor().lightGrey
        holderView.addSubview(imgView)
        let topAnchor: CGFloat = 10
        let bottomAnchor: CGFloat = 10
        
        let imgHeight = self.frame.height - topAnchor - bottomAnchor
        print("img height", imgHeight)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.leftAnchor.constraint(equalTo: holderView.leftAnchor, constant: 10).isActive = true
        imgView.topAnchor.constraint(equalTo: holderView.topAnchor, constant: topAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: imgHeight).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: imgHeight).isActive = true
        imgView.clipsToBounds = true

        holderView.addSubview(lblName)
        lblName.translatesAutoresizingMaskIntoConstraints = false
        lblName.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 20).isActive = true
        lblName.topAnchor.constraint(equalTo: imgView.topAnchor, constant: 10).isActive = true
        
        holderView.addSubview(lblNameSecondary)
        lblNameSecondary.translatesAutoresizingMaskIntoConstraints = false
        lblNameSecondary.leftAnchor.constraint(equalTo: lblName.rightAnchor, constant: 10).isActive = true
        lblNameSecondary.centerYAnchor.constraint(equalTo: lblName.centerYAnchor).isActive = true
        
        holderView.addSubview(btnRequest)
        btnRequest.translatesAutoresizingMaskIntoConstraints = false
        btnRequest.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: -10).isActive = true
        btnRequest.leftAnchor.constraint(equalTo: lblName.leftAnchor, constant: 0).isActive = true
        btnRequest.widthAnchor.constraint(equalToConstant: 120).isActive = true
        btnRequest.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func configure(user: User){
        self.user = user

        if let urlStr = user.profileURL{
            let url = URL(string: urlStr)
            imgView.sd_setImage(with: url, placeholderImage: nil, options: .progressiveDownload) { (img, error, cache, url) in
            }
        } else{
            imgView.image = nil
        }
        
        if user.uid == CurrentUser.instance.user.uid{
            lblName.text = user.fullName
            lblNameSecondary.text = "(You)"
            lblNameSecondary.isHidden = false
            btnRequest.isHidden = true
        } else{
            lblName.text = user.fullName
            lblNameSecondary.isHidden = true
            btnRequest.isHidden = false
        }
        
    }
    
    @objc func requestBtnPress(){
        if let del = delegate{
            del.requestSent(user: user, cell: self)
        }
    }
    
    
    
}
