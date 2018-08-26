//
//  RequestReceivedCell
//  bucketList
//
//  Created by Christopher Hovey on 8/25/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class RequestReceivedCell: BaseCell {
    
    var users: [User] = [User]()
    
    lazy var requestCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), collectionViewLayout: layout)
        cv.alwaysBounceVertical = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    override func setUpViews() {
        print("request set up views")
        backgroundColor = UIColor.cyan
        
        DataService.instance.currentUserFriends.order(by: "created", descending: false).whereField("status", isEqualTo: FriendStatus.requestReceived.rawValue).addSnapshotListener { (snapshot, error) in
            guard error == nil else{
                return
            }
            if let snapshot = snapshot{
                for doc in snapshot.documents{
                    let user: User = User(data: doc.data(), uid: doc.documentID)
                    users.append(user)
                }
            }
        }
    }
}

extension RequestReceivedCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}

















