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
    
    var users = [User]()
    var lastDoc: DocumentSnapshot?
    var reuseID = "cell"
    
    @IBOutlet weak var cvFriendsHorizontal: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMenuBar()
        setUpCV()
        
        
    }
    
    func setUpCV(){
        cvFriendsHorizontal.delegate = self
        cvFriendsHorizontal.dataSource = self
        cvFriendsHorizontal.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseID)
        
        cvFriendsHorizontal.isPagingEnabled = true
        
        if let flowLayout = cvFriendsHorizontal.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private func setUpMenuBar(){
        
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        let constraint1 = NSLayoutConstraint(item: menuBar, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let constraint2 = NSLayoutConstraint(item: menuBar, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: menuBar, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: menuBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        view.addConstraints([constraint1, constraint2, topConstraint, heightConstraint])

    }
    
    func slideCV(index: Int){
        cvFriendsHorizontal.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        findFriends()
//        searchView.isHidden = true
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
//                self.tableView.reloadData()
            })
        }
    }
    
//    @IBAction func searchBtnPress(_ sender: AnyObject){
//        guard let text = tfSearch.text else{
//            return
//        }
//
//        var query = DataService.instance.usersRef.whereField("email", isEqualTo: text)
//        query.addSnapshotListener { (snapshot, error) in
//            guard error == nil else{
//                print("error - ", error!)
//                return
//            }
//            print("query email")
//            if let snapshot = snapshot{
//                print("query email2 \(snapshot)")
//                let documents = snapshot.documents
//                for document in documents{
//                    print("query email3 \(document.data())")
//                    document.data()
//                    let user = User(data: document.data(), uid: document.documentID)
//                    self.users.append(user)
//                }
//                print("query email4 \(snapshot)")
//                self.tableView.reloadData()
//            }
//        }
//    }

}

extension FriendSearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colors: [UIColor] = [UIColor.red, UIColor.purple, UIColor.yellow]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as? UICollectionViewCell{
            cell.backgroundColor = colors[indexPath.row]
            
            
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        menuBar.leftLayoutConstraint?.constant = scrollView.contentOffset.x / 3
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("will end dragging \(targetContentOffset.move())")
        
        print("targetContentOffset \(targetContentOffset.move().x/self.view.frame.width)")
        let index = IndexPath(item: Int(targetContentOffset.move().x/self.view.frame.width), section: 0)
        menuBar.collectionView.selectItem(at: index, animated: true, scrollPosition: UICollectionViewScrollPosition.top)
//        menuBar.collectionView.deselectItem(at: <#T##IndexPath#>, animated: <#T##Bool#>)
        
    }
    
    
    
}


//extension FriendSearchVC: UITableViewDelegate, UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return users.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellRequest") as? FriendSearchTblCell{
//            cell.configure(user: users[indexPath.row])
//            cell.delegate = self
//            return cell
//        }
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
//}

//extension FriendSearchVC: FriendSearchTblCellDelegate {
//    func requestBtnPress(user: User){
//
//        var batch = Firestore.firestore().batch()
//        var currentUserRef = DataService.instance.currentUserDoc.collection("friends").document()
//        var data = user.friendRequestInfo()
//        data["created"] = FieldValue.serverTimestamp()
//        data["status"] = FriendStatus.requestSent.rawValue
//        batch.setData(data, forDocument: currentUserRef)
//        var userRef = DataService.instance.usersRef.document(user.uid).collection("friends").document()
//        var dataOtherUser = CurrentUser.instance.user.friendRequestInfo()
//        dataOtherUser["created"] = FieldValue.serverTimestamp()
//        dataOtherUser["status"] = FriendStatus.requestReceived.rawValue
//        batch.setData(dataOtherUser, forDocument: userRef)
//        batch.commit { (error) in
//            guard error == nil else{
//                print("batch friend request error")
//                return
//            }
//
//        }
//    }
//}














