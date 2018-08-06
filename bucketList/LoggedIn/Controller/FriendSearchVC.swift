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
    
    var users = [User]()
    var lastDoc: DocumentSnapshot?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        findFriends()
        searchView.isHidden = true
    }
    
    @IBAction func friendsBtnPress(_ sender: AnyObject){
        searchView.isHidden = true
    }
    
    @IBAction func findFriendsBtnPress(_ sender: AnyObject){
        searchView.isHidden = false
    }
    
    @IBAction func friendRequestBtnPress(_ sender: AnyObject){
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

            
//            GetData.instance.retrieve(collection: DataService.instance.currentUserFriends, onComplete: { (<#[BucketItem]#>) in
//                <#code#>
//            })
//            if let snapshot = snapshot{
//                for snap in snapshot..
//
//                }
//            }
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
            if let snapshot = snapshot{
                let documents = snapshot.documents
                for document in documents{
                    document.data()
                    let user = User(data: document.data(), uid: document.documentID)
                    self.users.append(user)
                }
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














