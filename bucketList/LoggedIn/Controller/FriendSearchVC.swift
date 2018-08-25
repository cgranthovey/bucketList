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
    var reuseIDSearch = "searchCell"
    var searchFriendsCell: SearchFriendsCell?

    @IBOutlet weak var cvFriendsHorizontal: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMenuBar()
        setUpCV()
    }
    
    func setUpCV(){
        cvFriendsHorizontal.delegate = self
        cvFriendsHorizontal.dataSource = self
        cvFriendsHorizontal.register(FriendsCell.self, forCellWithReuseIdentifier: reuseID)
        cvFriendsHorizontal.register(SearchFriendsCell.self, forCellWithReuseIdentifier: reuseIDSearch)
        cvFriendsHorizontal.isPagingEnabled = true
        
        if let flowLayout = cvFriendsHorizontal.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        mb.collectionView.isScrollEnabled = false
        mb.collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return mb
    }()
    
    private func setUpMenuBar(){
        
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        let constraint1 = NSLayoutConstraint(item: menuBar, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let constraint2 = NSLayoutConstraint(item: menuBar, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: menuBar, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: menuBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 85)
        view.addConstraints([constraint1, constraint2, topConstraint, heightConstraint])

    }
    
    func slideCV(index: Int){
        print("slide that - ", index)
        cvFriendsHorizontal.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dropKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dropKeyboard(){
        self.view.endEditing(true)
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
            })
        }
    }
}

extension FriendSearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 || indexPath.row == 2{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as? FriendsCell{
                print("the friends cell")
                let userA = User(data: ["fname":"Chris", "lname":"Hovey", "profileURL": "https://boygeniusreport.files.wordpress.com/2016/12/spider-man-homecoming.jpg?quality=98&strip=all"], uid: "24321")
                let userB = User(data: ["fname":"Tommy", "lname":"DoGood", "profileURL": "https://media.comicbook.com/2018/03/black-panther-chadwick-boseman-saturday-night-live-avengers-infi-1094187-1280x0.jpeg"], uid: "24321")
                let userC = User(data: ["fname":"Chris", "lname":"Hovey", "profileURL": "https://i.kinja-img.com/gawker-media/image/upload/s--2Lr4Npgo--/c_scale,f_auto,fl_progressive,q_80,w_800/rbbotmo6eoqks6kkh0kv.jpg"], uid: "24321")
                let userD = User(data: ["fname":"Tommy", "lname":"DoGood", "profileURL": "https://media.comicbook.com/2018/03/black-panther-chadwick-boseman-saturday-night-live-avengers-infi-1094187-1280x0.jpeg"], uid: "24321")
                cell.configure(users: [userA, userB, userC, userD])
                return cell
            }
        } else if indexPath.row == 1{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIDSearch, for: indexPath) as? SearchFriendsCell{
                cell.delegate = self
                searchFriendsCell = cell
                return cell
            }
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
    }
    
}

extension FriendSearchVC: SearchFriendsCellDelegate{
    func searchPress(tfEmail: UITextField) {
        let tfs: [UITextField] = [tfEmail]
        guard !tfs.containsIncompleteField() else {
            self.okAlert(title: "Error", message: "Please fill in email field.")
            return
        }
        
        let query = DataService.instance.usersRef.whereField("email", isEqualTo: tfEmail.text!)
        query.addSnapshotListener { (snapshot, error) in
            guard error == nil else{
                print("error retrieving user with email")
                return
            }
            print("the snapshot ", snapshot)
            guard snapshot != nil else{
                
                return
            }
            
            guard snapshot!.count > 0 else{
                print("could not find any friends")
                return
            }
            
            var users = [User]()
            for snap in snapshot!.documents{
                print("friends here!", snap.data())
                let user = User(data: snap.data(), uid: snap.documentID)
                users.append(user)
            }
            if let cell = self.searchFriendsCell{
                print("enter cell", users.count)
                for item in users{
                    print("item name - ", item.fullName)
                }
                cell.users = users
                cell.cowsGoMoo()
                cell.cvSearch.reloadData()
            }
        }
    }
    
    func searchPress(email: String?){
        
    }
}











