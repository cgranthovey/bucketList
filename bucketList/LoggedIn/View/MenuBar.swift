//
//  MenuBar
//  bucketList
//
//  Created by Christopher Hovey on 8/12/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.red
        
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let cellId = "cellId"
    let images = [#imageLiteral(resourceName: "friendsWhite"), #imageLiteral(resourceName: "magnifier"), #imageLiteral(resourceName: "add-friend")]
    var leftLayoutConstraint: NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        print("override init called")
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            let selectedRow = IndexPath(row: 0, section: 0)
            self.collectionView.selectItem(at: selectedRow, animated: false, scrollPosition: .left)
        }
        
        setupHorizontalBar()
    }
    
    func setupHorizontalBar(){
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        leftLayoutConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        leftLayoutConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/CGFloat(images.count)).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cell for item called")
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MenuCell{
            cell.imageView.image = images[indexPath.row].withRenderingMode(.alwaysTemplate)
            cell.imageView.tintColor = UIColor.gray
            cell.isUserInteractionEnabled = true
            
//            cell.configure(img: images[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/CGFloat(images.count), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select", indexPath)
        if let cell = collectionView.cellForItem(at: indexPath) as? MenuCell{
            print("did select inside")
            cell.imageView.tintColor = UIColor.white
            
            let xVal = CGFloat(indexPath.row) * frame.width / CGFloat(images.count)
            self.leftLayoutConstraint?.constant = xVal

            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.layoutIfNeeded()
            }) { (success) in
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MenuCell{
            cell.imageView.tintColor = UIColor.gray
        }
    }
    
    
    

}

class MenuCell: BaseCell {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "friendsWhite")
        return iv
    }()
    
    
    
//    override var highlighted: Bool{
//        print("highlighted called")
//        didSet{
//            imageView.tintColor = highlighted ? UIColor.brown : UIColor.gray
//        }
//    }
//        override var selected: Bool{
//            print("highlighted called")
//            didSet{
//                imageView.tintColor = highlighted ? UIColor.brown : UIColor.gray
//            }
//        }
    
    
    
    
//    func configure(img: UIImage){
//        img.withRenderingMode(.alwaysTemplate)
//        imageView.image = img
//
//        imageView.tintColor = UIColor.darkGray
//    }
    
    override func setUpViews() {
        super.setUpViews()
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let xConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28)
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28)
        self.addConstraints([heightConstraint, widthConstraint, xConstraint, yConstraint])
        
        backgroundColor = UIColor.red
    }
    

    
}

class BaseCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init code has not been implemented")
    }
    
    
}









