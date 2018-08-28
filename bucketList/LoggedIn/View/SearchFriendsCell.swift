//
//  SearchFriendsCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/24/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class BtnSearch: UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor().rgb(red: 255, green: 87, blue: 34, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var isHighlighted: Bool{
        didSet{
            if (isHighlighted){
                self.backgroundColor = UIColor().rgb(red: 216, green: 67, blue: 21, alpha: 1)
            } else{
                self.backgroundColor = UIColor().rgb(red: 255, green: 87, blue: 34, alpha: 1)
            }
        }
    }
}

protocol SearchFriendsCellDelegate{
    func searchPress(tfEmail: UITextField)
}

class SearchFriendsCell: BaseCell {
    
    var delegate: SearchFriendsCellDelegate!
    let reuseID = "cell"
    var users: [User] = [User]()
    
    lazy var tfEmail: CustomTF = {
        let tf = CustomTF(frame: .zero)
        tf.placeholder = "Friend's Email"
        tf.keyboardType = .emailAddress
        tf.keyboardAppearance = .light
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()
    
    lazy var btnSearch: UIButton = {
        let btn = BtnSearch(frame: .zero)
        btn.setTitle("Search", for: .normal)
        btn.reversesTitleShadowWhenHighlighted = true
        btn.adjustsImageWhenHighlighted = true
        btn.titleLabel?.textColor = .white
        btn.titleLabel?.font = UIFont().primary(size: 16)
        return btn
    }()
    
    lazy var cvSearch: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect(x: 0, y: 130, width: self.frame.width, height: self.frame.height), collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        cv.backgroundColor = UIColor.white
        cv.alwaysBounceVertical = true
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override func setUpViews() {
        super.setUpViews()
        addSubview(cvSearch)
        cvSearch.register(SearchFriendsItemCell.self, forCellWithReuseIdentifier: reuseID)
        cvSearch.reloadData()
        
        self.addSubview(tfEmail)
        tfEmail.translatesAutoresizingMaskIntoConstraints = false
        tfEmail.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        tfEmail.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        tfEmail.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        tfEmail.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(btnSearch)
        btnSearch.translatesAutoresizingMaskIntoConstraints = false
        btnSearch.topAnchor.constraint(equalTo: tfEmail.bottomAnchor, constant: 20).isActive = true
        btnSearch.leftAnchor.constraint(equalTo: tfEmail.leftAnchor, constant: 0).isActive = true
        btnSearch.rightAnchor.constraint(equalTo: tfEmail.rightAnchor, constant: 0).isActive = true
        btnSearch.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnSearch.addTarget(self, action: #selector(btnSearchPress), for: .touchUpInside)
    }
    
    @objc func btnSearchPress(){
        print("btn search press")
        delegate.searchPress(tfEmail: tfEmail)
    }
}


extension SearchFriendsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("search friends cell count", users.count)
        return users.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("search friends cell cellForItemAt1")
        if let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for:
            indexPath) as? SearchFriendsItemCell{
            print("search friends cell cellForItemAt2")
            cell.delegate = self
            cell.configure(user: users[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 105)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension SearchFriendsCell: SearchFriendsItemCellDelegate{
    func requestSent(user: User, cell: SearchFriendsItemCell) {
        print("request sent", user.fullName)
        print("request sent uid", user.uid)
        let batch = Firestore.firestore().batch()
        
        
        let requesteeDoc = DataService.instance.usersRef.document(user.uid).collection("friends").document(CurrentUser.instance.user.uid)
        let requesterDoc = DataService.instance.currentUserFriends.document(user.uid)

        
        var dict2 = CurrentUser.instance.user.friendRequestInfo()
        dict2["status"] = FriendStatus.requestReceived.rawValue
        dict2["created"] = FieldValue.serverTimestamp()

        batch.setData(dict2, forDocument: requesteeDoc)
        
        //let requesterDoc = DataService.instance.currentUserFriends.document()
        var dict = user.friendRequestInfo()
        dict["status"] = FriendStatus.requestSent.rawValue
        dict["created"] = FieldValue.serverTimestamp()
        batch.setData(dict, forDocument: requesterDoc)
        
        print("request sent ")
        batch.commit { (error) in
            guard error == nil else{
                print("error is nil ", error?.localizedDescription)
                return
            }
            cell.btnRequest.setTitle("Request Sent", for: .normal)
            cell.btnRequest.isUserInteractionEnabled = false
        }
    }
    
    
}














