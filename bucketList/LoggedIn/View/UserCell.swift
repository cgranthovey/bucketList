//
//  UserCell
//  bucketList
//
//  Created by Christopher Hovey on 8/26/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

protocol UserCellDelegate{
    func primaryBtnPress(user: User, btnAction: UserCellBtnActions?)
    func secondaryBtnPress(user: User, btnAction: UserCellBtnActions?)
}

class UserCell: BaseCell {
    
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
    
    lazy var btnPrimary: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.addTarget(self, action: #selector(UserCell.acceptBtnPress), for: .touchUpInside)
        btn.setTitle("Accept", for: .normal)
        btn.backgroundColor = .orange
        btn.titleLabel?.textColor = .white
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont().primary(size: 16)
        return btn
    }()
    
    lazy var btnSecondary: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.addTarget(self, action: #selector(UserCell.declineBtnPress), for: .touchUpInside)
        btn.setTitle("Decline", for: .normal)
        btn.backgroundColor = UIColor.darkGray
        btn.titleLabel?.textColor = .white
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont().primary(size: 16)
        return btn
    }()
    
    var user: User!
    var delegate: UserCellDelegate?
    var isRequestReceived: Bool = false
    var primaryBtnAction: UserCellBtnActions?
    var secondaryBtnAction: UserCellBtnActions?
    
    override func setUpViews() {
        
        addSubview(holderView)
        holderView.backgroundColor = UIColor().lightGrey
        holderView.addSubview(imgView)
        let topAnchor: CGFloat = 10
        let bottomAnchor: CGFloat = 10
        let imgHeight = self.frame.height - topAnchor - bottomAnchor

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
        
        holderView.addSubview(btnPrimary)
        btnPrimary.translatesAutoresizingMaskIntoConstraints = false
        btnPrimary.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: -10).isActive = true
        btnPrimary.leftAnchor.constraint(equalTo: lblName.leftAnchor, constant: 0).isActive = true
        btnPrimary.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        btnPrimary.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        holderView.addSubview(btnSecondary)
        btnSecondary.translatesAutoresizingMaskIntoConstraints = false
        btnSecondary.centerYAnchor.constraint(equalTo: btnPrimary.centerYAnchor).isActive = true
        btnSecondary.leftAnchor.constraint(equalTo: btnPrimary.rightAnchor, constant: 20).isActive = true
        btnSecondary.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        btnSecondary.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configure(user: User){
        print("friend type \(user.friendType)")
        primaryBtnAction = nil
        secondaryBtnAction = nil
        if let type = user.friendType{
            if type == .blocked{
                btnSecondary.isHidden = true
                btnPrimary.isHidden = true
                primaryBtnAction = UserCellBtnActions.block
                lblNameSecondary.isHidden = false
                lblNameSecondary.text = "(Blocked)"
            }
            if type == .friend{
                btnSecondary.isHidden = true
                btnPrimary.isHidden = true
                lblNameSecondary.isHidden = false
                lblNameSecondary.text = "(Friends)"
            }
            if type == .requestReceived{
                btnPrimary.setTitleWithoutAnimation(title: "Accept")
                btnSecondary.setTitleWithoutAnimation(title: "Decline")
                primaryBtnAction = UserCellBtnActions.acceptRequest
                secondaryBtnAction = UserCellBtnActions.declineRequest
                btnSecondary.isHidden = false
                btnPrimary.isHidden = false
                lblNameSecondary.isHidden = true
            }
            if type == .requestSent{
                btnPrimary.setTitleWithoutAnimation(title: "Cancel Request")
                primaryBtnAction = UserCellBtnActions.cancelRequest
                btnPrimary.isHidden = false
                btnSecondary.isHidden = true
                lblNameSecondary.isHidden = false
                lblNameSecondary.text = "(Request Sent)"
            }
        } else{
            btnPrimary.setTitleWithoutAnimation(title: "Send Request")
            primaryBtnAction = UserCellBtnActions.sendRequest
            btnPrimary.isHidden = false
            btnSecondary.isHidden = true
            lblNameSecondary.isHidden = true
        }

        self.user = user
        lblName.text = user.fullName
        
        if let urlStr = user.profileURL{
            let url = URL(string: urlStr)
            imgView.sd_setImage(with: url, placeholderImage: nil, options: .progressiveDownload) { (img, error, cache, url) in
            }
        } else{
            imgView.image = #imageLiteral(resourceName: "profile")
        }

    }
    
    @objc func acceptBtnPress(){
        if let del = delegate{
            del.primaryBtnPress(user: user, btnAction: primaryBtnAction)
        }
    }
    @objc func declineBtnPress(){
        if let del = delegate{
            del.secondaryBtnPress(user: user, btnAction: secondaryBtnAction)
        }
    }
}
