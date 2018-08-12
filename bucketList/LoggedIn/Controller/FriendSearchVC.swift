//
//  FriendSearchVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/22/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


enum FriendStatus: String{
    case friend = "friend"
    case requestSent = "Request Sent"
    case requestReceived = "Request Received"
}


class FriendSearchVC: UIViewController {
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var btnFriends: UIButton!
    @IBOutlet weak var btnFind: UIButton!
    @IBOutlet weak var btnRequest: UIButton!
    
    var users = [User]()
    var lastDoc: DocumentSnapshot?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        btnFriends.backgroundColor = UIColor.orange
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgViewTapped(sender:)))
        
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
    }
//    let tap = UITapGestureRecognizer(target: self, action: #selector(imgViewTapped(sender:)))

    @objc func imgViewTapped(sender: UITapGestureRecognizer? = nil){
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        findFriends()
        searchView.isHidden = true
    }
    
    func updateBtnColor(activeBtn: UIButton){
        let btns: [UIButton] = [btnFriends, btnFind, btnRequest]
        for btn in btns{
            btn.backgroundColor = UIColor().rgb(red: 0, green: 0, blue: 0, alpha: 0.05)
        }
        activeBtn.backgroundColor = UIColor.orange
    }
    
    @IBAction func friendsBtnPress(_ sender: AnyObject){
        updateBtnColor(activeBtn: btnFriends)
        searchView.isHidden = true
        btnFriends.backgroundColor = UIColor.orange
    }
    
    @IBAction func findFriendsBtnPress(_ sender: AnyObject){
        updateBtnColor(activeBtn: btnFind)
        searchView.isHidden = false
    }
    
    @IBAction func friendRequestBtnPress(_ sender: AnyObject){
        updateBtnColor(activeBtn: btnRequest)
        searchView.isHidden = true
    }
    
    func findFriends(){
        let query = DataService.instance.currentUserFriends.whereField("status", isEqualTo: "friends")
        query.addSnapshotListener { (snapshot, error) in
            guard error == nil else{
                print("error finding friends", error)
                return
            }
            GetData.instance.retrieve(collection: DataService.instance.currentUserFriends, lastDoc: self.lastDoc, onComplete: { (items, lastDoc) in
                self.lastDoc = lastDoc
                for item in items{
                    if let dict = item as? Dictionary<String, AnyObject>{
                        if let uid = dict["uid"] as? String{
                            let user = User(data: dict, uid: uid)
                            self.users.append(user)
                        }
                    }
                }
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func searchBtnPress(_ sender: AnyObject){
        guard let text = tfSearch.text else{
            return
        }
        
        var query = DataService.instance.usersRef.whereField("email", isEqualTo: text)
        query.addSnapshotListener { (snapshot, error) in
            guard error == nil else{
                print("error - ", error!)
                return
            }
            print("query email")
            if let snapshot = snapshot{
                print("query email2 \(snapshot)")
                let documents = snapshot.documents
                for document in documents{
                    print("query email3 \(document.data())")
                    document.data()
                    let user = User(data: document.data(), uid: document.documentID)
                    self.users.append(user)
                }
                print("query email4 \(snapshot)")
                self.tableView.reloadData()
            }
        }
    }

}


extension FriendSearchVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellRequest") as? FriendSearchTblCell{
            cell.configure(user: users[indexPath.row])
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension FriendSearchVC: FriendSearchTblCellDelegate {
    func requestBtnPress(user: User){
        
        var batch = Firestore.firestore().batch()
        var currentUserRef = DataService.instance.currentUserDoc.collection("friends").document()
        var data = user.friendRequestInfo()
        data["created"] = FieldValue.serverTimestamp()
        data["status"] = FriendStatus.requestSent.rawValue
        batch.setData(data, forDocument: currentUserRef)
        var userRef = DataService.instance.usersRef.document(user.uid).collection("friends").document()
        var dataOtherUser = CurrentUser.instance.user.friendRequestInfo()
        dataOtherUser["created"] = FieldValue.serverTimestamp()
        dataOtherUser["status"] = FriendStatus.requestReceived.rawValue
        batch.setData(dataOtherUser, forDocument: userRef)
        batch.commit { (error) in
            guard error == nil else{
                print("batch friend request error")
                return
            }
            
        }

    }
}














