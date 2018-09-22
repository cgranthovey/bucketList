//
//  AddCompletionTimeVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/22/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class AddCompletionTimeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBottomDistance: NSLayoutConstraint!
    @IBOutlet weak var btnTopDistance: NSLayoutConstraint!
    @IBOutlet weak var collectionTopDistance: NSLayoutConstraint!
    
    var items = ["30 minutes", "2 Hours", "4 Hours", "Full Day", "Multiday", "Ongoing"]
    var itemLineSpacing: CGFloat = 10;
    var collectionLeftRightInset: CGFloat = 30;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.contentInset = UIEdgeInsetsMake(0, collectionLeftRightInset, 0, collectionLeftRightInset)
        
//        if let time = NewBucketItem.instance.item.completionTime{
//            print("will display2")
//            for (index, item) in items.enumerated(){
//                if item == time{
//                    let ip = IndexPath(row: index, section: 0)
//                    collectionView.selectItem(at: ip, animated: false, scrollPosition: .top)
//                }
//            }
//        }
    }

}
extension AddCompletionTimeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CompletionTimeCell{
            cell.configure(str: items[indexPath.row])
            let selectedView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            
            if let time = NewBucketItem.instance.item.completionTime{
                if time == items[indexPath.row]{
                    cell.isSelected = true
                }
            }
            
            
            
            selectedView.layer.borderColor = UIColor().primaryColor.cgColor
            selectedView.layer.borderWidth = 3.5
//            selectedView.backgroundColor = UIColor().primaryColor
            cell.selectedBackgroundView = selectedView
            

            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NewBucketItem.instance.item.completionTime = items[indexPath.row]
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CompletionTimeCell{
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }) { (success) in
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
                }, completion: { (success) in
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                        cell.transform = .identity
                    }, completion: { (success) in
                    })
                })
            }
            //cell.lbl.textColor = UIColor.white
        }
    }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? CompletionTimeCell{
//            cell.lbl.textColor = UIColor.black
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("will display1")
        if let time = NewBucketItem.instance.item.completionTime{
            print("will display2")
            if time == items[indexPath.row]{
                print("will display3")
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            }
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cvHeight = UIScreen.main.bounds.height - (UINavigationController().navigationBar.frame.height + UITabBarController().tabBar.frame.height + btnTopDistance.constant + btnBottomDistance.constant + collectionTopDistance.constant + btnNext.frame.height + UIApplication.shared.statusBarFrame.height)
        

        print("cvHeight", cvHeight)
        print("screenHeight", UIScreen.main.bounds.height)
        
//        let height = collectionView.frame.height
        let heightCellsTotal: CGFloat = cvHeight - CGFloat(itemLineSpacing * CGFloat(items.count - 1))
        let cellHeight = heightCellsTotal / CGFloat(items.count)
        let width = collectionView.frame.width - collectionLeftRightInset * 2
        
        return CGSize(width: width, height: cellHeight)
    }

    
    
    
}

















