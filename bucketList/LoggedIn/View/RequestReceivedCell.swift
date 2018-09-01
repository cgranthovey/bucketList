//
//  RequestReceivedCell
//  bucketList
//
//  Created by Christopher Hovey on 8/25/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseFirestore

class RequestReceivedCell: BaseCell {
    
    var friendRequests: [User] = [User]()
    var reuseID = "reuseIDRequest"
    
    lazy var requestCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        cv.alwaysBounceVertical = true
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    override func setUpViews() {
        addSubview(requestCollection)
        requestCollection.register(UserCell.self, forCellWithReuseIdentifier: reuseID)
        backgroundColor = UIColor.cyan
        
        DataService.instance.currentUserFriends.order(by: "created", descending: false).whereField("status", isEqualTo: FriendStatus.requestReceived.rawValue).addSnapshotListener { (snapshot, error) in
            guard error == nil else{
                return
            }
            if let snapshot = snapshot{
                for doc in snapshot.documents{
                    let friend: User = User(data: doc.data(), uid: doc.documentID)
                    self.friendRequests.append(friend)
                }
            }
            if self.friendRequests.count == 0{
                let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
                backgroundView.backgroundColor = .white
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
                label.text = "No Friend Requests"
                label.font = UIFont().primary(size: 20)
                label.textAlignment = .center
                self.requestCollection.backgroundView = label
            }
            self.requestCollection.reloadData()
        }
    }
}

extension RequestReceivedCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendRequests.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as? UserCell{
            cell.delegate = self
            cell.configure(user: friendRequests[indexPath.row])
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

extension RequestReceivedCell: UserCellDelegate{
    func primaryBtnPress(user: User, btnAction: UserCellBtnActions?) {
        guard user.uid != nil else{
            return
        }
        let batch = Firestore.firestore().batch()
        let currentUserRequestRef: DocumentReference = DataService.instance.currentUserFriends.document(user.uid!)
        batch.updateData(["status": FriendStatus.friend.rawValue], forDocument: currentUserRequestRef)
        
        let otherUserRequestRef: DocumentReference = DataService.instance.usersRef.document(user.uid!).collection("friends").document(CurrentUser.instance.user.uid)
        batch.updateData(["status": FriendStatus.friend.rawValue], forDocument: otherUserRequestRef)
        batch.commit { (error) in
            guard error == nil else{
                print("error setting status as friends", error?.localizedDescription)
                return
            }
        }
    }
    
    func secondaryBtnPress(user: User, btnAction: UserCellBtnActions?) {
        guard user.uid != nil else{
            return
        }
        let batch = Firestore.firestore().batch()
        let currentUserRequestRef: DocumentReference = DataService.instance.currentUserFriends.document(user.uid!)
        batch.deleteDocument(currentUserRequestRef)
        let otherUserRequestRef: DocumentReference = DataService.instance.usersRef.document(user.uid!).collection("friends").document(CurrentUser.instance.user.uid)
        batch.deleteDocument(otherUserRequestRef)
        
        batch.commit { (error) in
            guard error == nil else{
                print("error deleting request occured")
                return
            }
        }
    }

}









