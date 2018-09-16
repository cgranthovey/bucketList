//
//  AddCategoriesVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/14/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class AddCategoriesVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var btnNext: UIButton!
    
    let option1 = txtImg.init(txt: "Travel", img: #imageLiteral(resourceName: "cat-airplane"))
    let option2 = txtImg.init(txt: "Nature", img: #imageLiteral(resourceName: "cat-tree"))
    let option3 = txtImg.init(txt: "Education", img: #imageLiteral(resourceName: "cat-books"))
    let option4 = txtImg.init(txt: "Sports", img: #imageLiteral(resourceName: "cat-soccer"))
    let option5 = txtImg.init(txt: "Social", img: #imageLiteral(resourceName: "cat-social"))
    let option6 = txtImg.init(txt: "Religion", img: #imageLiteral(resourceName: "cat-religious"))
    let option7 = txtImg.init(txt: "Exercise", img: #imageLiteral(resourceName: "cat-exercise"))
    let option8 = txtImg.init(txt: "Art", img: #imageLiteral(resourceName: "cat-art"))
    let option9 = txtImg.init(txt: "History", img: #imageLiteral(resourceName: "cat-history"))
    
    let collectionViewInsets = UIEdgeInsetsMake(0, 20, 0, 20)
    let collectionLineSpacing: CGFloat = 5
    
    lazy var priceOptions: [txtImg] = {
        return [option1, option2, option3, option4, option5, option6, option7, option8, option9]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate =  self
        collectionView.contentInset = collectionViewInsets
        collectionView.allowsSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.allowsMultipleSelection = true
    }
    
    @IBAction func nextBtnPress(_ sender: AnyObject){
        
    }
    
    
}

extension AddCategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImgLblCell{
            cell.configure(object: priceOptions[indexPath.row])
            let selectedView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            selectedView.backgroundColor = UIColor().extraLightGrey
            cell.selectedBackgroundView = selectedView
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImgLblCell{
            cell.imgViewChecked.isHidden = false
            cell.imgViewChecked.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
            UIView.animate(withDuration: 0.22, animations: {
                cell.imgViewChecked.transform = .identity
                cell.imgView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                cell.imgView.transform = CGAffineTransform(translationX: -10, y: 5)
            }) { (success) in
                
                //
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImgLblCell{
            
            UIView.animate(withDuration: 0.22, animations: {
                cell.imgViewChecked.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
                cell.imgView.transform = .identity
            }) { (success) in
                cell.imgViewChecked.isHidden = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return priceOptions.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insetWidth = collectionViewInsets.left + collectionViewInsets.right
        let width = (collectionView.frame.width - insetWidth) / 3
        let height = width * 0.85
        let size = CGSize(width: width, height: height)
        
        heightCollectionView.constant = height * 3 + collectionLineSpacing * 2
        
        return size
    }
}















