//
//  FriendSearchTblCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/22/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage


protocol FriendSearchTblCellDelegate {
    func requestBtnPress(user: User)
}


class FriendSearchTblCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet weak var lblCurrentUser: UILabel!
    var user: User?
    var delegate: FriendSearchTblCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(user: User){
        btnRequest.isHidden = false
        lblCurrentUser.isHidden = true
        if let currentUser = Auth.auth().currentUser, let selectedUserID = user.uid{
            if currentUser.uid == selectedUserID{
                btnRequest.isHidden = true
                lblCurrentUser.isHidden = false
            }
        }
        
        if let img = user.profileURL{
            let url = URL(string: img)
            imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "profile"), options: [], completed: nil)
        }
        
        lblName.text = user.fullName
        self.user = user
    }
    
    @IBAction func requestBtnPress(_ sender: AnyObject){
        print("requestBtnPress1")
        if let user = user{
            delegate.requestBtnPress(user: user)
        }
    }

}
