//
//  FriendsCell.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/13/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import UIKit

class FriendsCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .init(x: 0, y: 40, width: self.frame.width, height: self.frame.height - 40), collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"

    override func setUpViews() {
        super.setUpViews()
        
        backgroundColor = .purple
        
        addSubview(collectionView)
        
        collectionView.register(FriendsItemCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.reloadData()
    }
    
    var users: [User] = []
    
    func configure(users: [User]){
        self.users = users
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? FriendsItemCell{
            cell.backgroundColor = .lightGray
            cell.configure(user: users[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    var interitemSpacing: CGFloat = 5
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = collectionView.frame.width/2 - interitemSpacing
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    
}












