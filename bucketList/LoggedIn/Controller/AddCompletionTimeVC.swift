//
//  AddCompletionTimeVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/22/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

class CategoryOptions{
    private static var _instance = CategoryOptions()
    static var instance: CategoryOptions{
        return _instance
    }
    
    let option1 = txtImg.init(txt: "Travel", img: #imageLiteral(resourceName: "cat-airplane"))
    let option2 = txtImg.init(txt: "Nature", img: #imageLiteral(resourceName: "cat-tree"))
    let option3 = txtImg.init(txt: "Education", img: #imageLiteral(resourceName: "cat-books"))
    let option4 = txtImg.init(txt: "Sports", img: #imageLiteral(resourceName: "cat-soccer"))
    let option5 = txtImg.init(txt: "Social", img: #imageLiteral(resourceName: "cat-social"))
    let option6 = txtImg.init(txt: "Religion", img: #imageLiteral(resourceName: "cat-religious"))
    let option7 = txtImg.init(txt: "Exercise", img: #imageLiteral(resourceName: "cat-exercise"))
    let option8 = txtImg.init(txt: "Art", img: #imageLiteral(resourceName: "cat-art"))
    let option9 = txtImg.init(txt: "History", img: #imageLiteral(resourceName: "cat-history"))
    
    lazy var allOptions = {
        return [option1, option2, option3, option4, option5, option6, option7, option8, option9]
    }()
    
}


import UIKit

class AddCompletionTimeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBottomDistance: NSLayoutConstraint!
    @IBOutlet weak var btnTopDistance: NSLayoutConstraint!
    @IBOutlet weak var collectionTopDistance: NSLayoutConstraint!
    
    lazy var items: [String] = {
        return BucketOptions.instance.allTimes
        }()
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
        
        if let time = NewBucketItem.instance.item.completionTime, time == items[indexPath.row]{
            NewBucketItem.instance.item.completionTime = nil
            collectionView.deselectItem(at: indexPath, animated: true)
        } else{
            NewBucketItem.instance.item.completionTime = items[indexPath.row]
            print("did SELECT")
            if let cell = collectionView.cellForItem(at: indexPath) as? CompletionTimeCell{
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    cell.transform = CGAffineTransform(scaleX: 1.04, y: 1.04)
                }) { (success) in
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                        cell.transform = .identity
                    })
                }
            }
        }
        

    }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        print("did deselect")

////        if let cell = collectionView.cellForItem(at: indexPath) as? CompletionTimeCell{
////            cell.lbl.textColor = UIColor.black
////        }
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

















