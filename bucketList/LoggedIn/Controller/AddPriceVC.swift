//
//  AddPriceVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/12/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit



class AddPriceVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var btnNext: UIButton!
    
    let optionFree = txtImg.init(txt: "Free", img: #imageLiteral(resourceName: "free"))
    let option2 = txtImg.init(txt: "< $15", img: #imageLiteral(resourceName: "coin"))
    let option3 = txtImg.init(txt: "< $50", img: #imageLiteral(resourceName: "coins"))
    let option4 = txtImg.init(txt: "< $100", img: #imageLiteral(resourceName: "notes"))
    let option5 = txtImg.init(txt: "< $500", img: #imageLiteral(resourceName: "notesBundle"))
    let option6 = txtImg.init(txt: "$500+", img: #imageLiteral(resourceName: "rich"))
    
    let collectionViewInsets = UIEdgeInsetsMake(0, 20, 0, 20)
    let collectionLineSpacing: CGFloat = 5
    
    lazy var priceOptions: [txtImg] = {
        return [optionFree, option2, option3, option4, option5, option6]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate =  self
        collectionView.contentInset = collectionViewInsets
        collectionView.allowsSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationItem.setHidesBackButton(true, animated: true)
//        if let price = NewBucketItem.instance.item.price{
//            for (index, item) in priceOptions.enumerated(){
//                if item.txt == price{
//                    if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)){
//                        cell.isSelected = true
//                    }
//
//                }
//            }
//
//        }
        

        //self.navigationController?.navigationItem.title = "Price"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let price = NewBucketItem.instance.item.price{
            for (index, item) in priceOptions.enumerated(){
                if item.txt == price{
                    if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? ImgLblCell{

                        if cell.isSelected == false{
                            animateCellSelected(cell: cell)
                            collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .bottom)
                        }

                    }
                    
                }
            }
            
        }
    }

    @IBAction func nextBtnPress(_ sender: AnyObject){
        
    }


}

extension AddPriceVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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
        
        NewBucketItem.instance.item.price = priceOptions[indexPath.row].txt
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ImgLblCell{
            animateCellSelected(cell: cell)
        }
    }
    
    func animateCellSelected(cell: ImgLblCell){
        cell.imgViewChecked.isHidden = false
        cell.imgViewChecked.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        UIView.animate(withDuration: 0.22, animations: {
            cell.imgViewChecked.transform = .identity
            cell.imgView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            cell.imgView.transform = CGAffineTransform(translationX: -10, y: 5)
        }) { (success) in
            
            
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
        
        heightCollectionView.constant = height * 2 + collectionLineSpacing
        
        return size
    }
}















