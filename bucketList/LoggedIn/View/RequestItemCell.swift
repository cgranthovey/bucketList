//
//  RequestItemCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/26/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

protocol RequestItemCellDelegate{
    func friendRequest(accepted: Bool, friend: Friend)
}

class RequestItemCell: BaseCell {
    

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
    
    lazy var btnAccept: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.addTarget(self, action: #selector(RequestItemCell.acceptBtnPress), for: .touchUpInside)
        btn.setTitle("Accept", for: .normal)
        btn.backgroundColor = .orange
        btn.titleLabel?.textColor = .white
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont().primary(size: 16)
        return btn
    }()
    
    lazy var btnDecline: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.addTarget(self, action: #selector(RequestItemCell.declineBtnPress), for: .touchUpInside)
        btn.setTitle("Decline", for: .normal)
        btn.backgroundColor = UIColor.darkGray
        btn.titleLabel?.textColor = .white
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont().primary(size: 16)
        return btn
    }()
    
    var friend: Friend!
    var delegate: RequestItemCellDelegate?
    var isRequestReceived: Bool = false
    
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
        
        holderView.addSubview(btnAccept)
        btnAccept.translatesAutoresizingMaskIntoConstraints = false
        btnAccept.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: -10).isActive = true
        btnAccept.leftAnchor.constraint(equalTo: lblName.leftAnchor, constant: 0).isActive = true
        btnAccept.widthAnchor.constraint(equalToConstant: 90).isActive = true
        btnAccept.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        holderView.addSubview(btnDecline)
        btnDecline.translatesAutoresizingMaskIntoConstraints = false
        btnDecline.centerYAnchor.constraint(equalTo: btnAccept.centerYAnchor).isActive = true
        btnDecline.leftAnchor.constraint(equalTo: btnAccept.rightAnchor, constant: 20).isActive = true
        btnDecline.widthAnchor.constraint(equalToConstant: 90).isActive = true
        btnDecline.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func configure(friend: Friend){
        self.friend = friend
        
        if let urlStr = friend.profileURL{
            let url = URL(string: urlStr)
            imgView.sd_setImage(with: url, placeholderImage: nil, options: .progressiveDownload) { (img, error, cache, url) in
            }
        } else{
            imgView.image = nil
        }
        
        lblName.text = friend.fullName
        lblNameSecondary.isHidden = true
        btnAccept.isHidden = false
        
    }
    
    @objc func acceptBtnPress(){
        if let del = delegate{
            del.friendRequest(accepted: true, friend: friend)
        }
    }
    @objc func declineBtnPress(){
        if let del = delegate{
            del.friendRequest(accepted: false, friend: friend)
        }
    }
}
