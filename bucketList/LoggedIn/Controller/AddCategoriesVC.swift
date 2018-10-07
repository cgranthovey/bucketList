//
//  AddCategoriesVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/14/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

struct Status{
    var status: ItemStatus
    var color: UIColor
}



class AddCategoriesVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var btnNext: UIButton!
    
    let collectionViewInsets = UIEdgeInsetsMake(0, 20, 0, 20)
    let collectionLineSpacing: CGFloat = 5
    
    lazy var categoryOptions: [txtImg] = {
        return BucketOptions.instance.allCategories
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
    
    override func viewDidAppear(_ animated: Bool) {
        setUpUI()
    }
    
    @IBAction func nextBtnPress(_ sender: AnyObject){
        
    }
    
    func setUpUI(){
        for (index, item) in categoryOptions.enumerated(){
            switch item.img{
            case #imageLiteral(resourceName: "cat-airplane"): NewBucketItem.instance.item.isTravel ? selectItem(index: index) : nil;
            case #imageLiteral(resourceName: "cat-tree"): NewBucketItem.instance.item.isNature ? selectItem(index: index) : nil
            case #imageLiteral(resourceName: "cat-books"): NewBucketItem.instance.item.isEducation ? selectItem(index: index) : nil
            case #imageLiteral(resourceName: "cat-soccer"): NewBucketItem.instance.item.isSports ? selectItem(index: index) : nil
            case #imageLiteral(resourceName: "cat-social"): NewBucketItem.instance.item.isSocial ? selectItem(index: index) : nil
            case #imageLiteral(resourceName: "cat-religious"): NewBucketItem.instance.item.isReligion ? selectItem(index: index) : nil
            case #imageLiteral(resourceName: "cat-exercise"): NewBucketItem.instance.item.isExercise ? selectItem(index: index) : nil
            case #imageLiteral(resourceName: "cat-art"): NewBucketItem.instance.item.isArt ? selectItem(index: index) : nil
            case #imageLiteral(resourceName: "cat-history"): NewBucketItem.instance.item.isHistory ? selectItem(index: index) : nil
            default: print("no matching items")
            }
        }
    }
    
    func selectItem(index: Int){
        let ip = IndexPath(row: index, section: 0)
        if let cell = collectionView.cellForItem(at: ip) as? ImgLblCell{
            if !cell.isSelected{
                collectionView.selectItem(at: ip, animated: true, scrollPosition: .bottom)
                animateImgLblCell(cell: cell)
            }
        }
        
    }
    
    
    
    
}

extension AddCategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImgLblCell{
            cell.configure(object: categoryOptions[indexPath.row])
            let selectedView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            selectedView.backgroundColor = UIColor().extraLightGrey
            cell.selectedBackgroundView = selectedView
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        markIsCategory(index: indexPath.row, isBool: true)
        if let cell = collectionView.cellForItem(at: indexPath) as? ImgLblCell{
            animateImgLblCell(cell: cell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImgLblCell{
            markIsCategory(index: indexPath.row, isBool: false)
            UIView.animate(withDuration: 0.22, animations: {
                cell.imgViewChecked.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
                cell.imgView.transform = .identity
            }) { (success) in
                cell.imgViewChecked.isHidden = true
            }
        }
    }
    
    func markIsCategory(index: Int, isBool: Bool){
        switch categoryOptions[index].img {
        case #imageLiteral(resourceName: "cat-airplane"): NewBucketItem.instance.item.isTravel = isBool
        case #imageLiteral(resourceName: "cat-tree"): NewBucketItem.instance.item.isNature = isBool
        case #imageLiteral(resourceName: "cat-books"): NewBucketItem.instance.item.isEducation = isBool
        case #imageLiteral(resourceName: "cat-soccer"): NewBucketItem.instance.item.isSports = isBool
        case #imageLiteral(resourceName: "cat-social"): NewBucketItem.instance.item.isSocial = isBool
        case #imageLiteral(resourceName: "cat-religious"): NewBucketItem.instance.item.isReligion = isBool
        case #imageLiteral(resourceName: "cat-exercise"): NewBucketItem.instance.item.isExercise = isBool
        case #imageLiteral(resourceName: "cat-art"): NewBucketItem.instance.item.isArt = isBool
        case #imageLiteral(resourceName: "cat-history"): NewBucketItem.instance.item.isHistory = isBool
        default: print("item not found")
        }
    }
    
    func animateImgLblCell(cell: ImgLblCell){
        cell.imgViewChecked.isHidden = false
        cell.imgViewChecked.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        UIView.animate(withDuration: 0.22, animations: {
            cell.imgViewChecked.transform = .identity
            cell.imgView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            cell.imgView.transform = CGAffineTransform(translationX: -10, y: 5)
        }) { (success) in
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryOptions.count
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















