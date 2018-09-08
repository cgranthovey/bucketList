//
//  BucketDetails.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/4/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class BucketDetails: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images: [String] = [String]()
    var bucketItem: BucketItem?
    var spaceBetweenCells: CGFloat = 10
    
    lazy var holderDetailDataCell: DetailDataCell = {
        let cell = DetailDataCell()
        return cell
    }()
    
    var sizingNibNew = Bundle.main.loadNibNamed("ItemDataCell", owner: ItemDataCell.self, options: nil) as? NSArray
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "ItemDataCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ItemDataCell")
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        
        if let item = bucketItem{
            images = item.imgs
        }

        images = ["https://www.myyosemitepark.com/.image/ar_16:9%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cg_faces:center%2Cq_auto:good%2Cw_960/MTQ4NjQxMDIxOTQzNjIxMjk5/yosemite-falls-river_dp_1600.jpg", "https://media-cdn.tripadvisor.com/media/photo-s/0d/f4/e0/b6/yosemite-national-park.jpg"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }


}

extension BucketDetails: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0, let bucketItem = bucketItem{
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemDataCell", for: indexPath) as? ItemDataCell{
                cell.configure(item: bucketItem)
                return cell
            }
        }
        if indexPath.row > 0{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DetailImgCell{
                cell.configure(imgUrl: images[indexPath.row - 1])
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spaceBetweenCells
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spaceBetweenCells
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "LargeImageVC") as? LargeImageVC{
            vc.imgURLString = images[indexPath.row - 1]
            if let cell = collectionView.cellForItem(at: indexPath){
                cell.hero.id = "toLargeImg"
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0{
            print("in it all")
            let width = self.view.frame.width - CGFloat(20)// / 3.0

            if let item = bucketItem{
                let requiredWidth = collectionView.bounds.size.width
                let targetSize = CGSize(width: requiredWidth, height: 0)
                let newCell: ItemDataCell = .fromNib()
                newCell.configure(item: item)
                let layoutAttributes = collectionViewLayout.layoutAttributesForItem(at: indexPath)
                layoutAttributes?.frame.size = targetSize
                let adequateSize = newCell.preferredLayoutAttributesFitting(layoutAttributes!)
                return CGSize(width: self.collectionView.bounds.width, height: adequateSize.frame.height)
                

//                let sizingNewNib: ItemDataCell = .fromNib()
//
//                sizingNewNib.configure(item: item)
//                let requiredWidth = collectionView.bounds.size.width
//                let targetSize = CGSize(width: requiredWidth, height: 0)
//                let adequateSize = sizingNewNib.systemLayoutSizeFitting(targetSize)
//                print("the adequate size", adequateSize)
//                return adequateSize
            }

            
            return CGSize(width: width, height: width)
        }
        print("in it all2", UICollectionViewFlowLayoutAutomaticSize.height)
        print("in it all2", collectionView.contentInset)
        let inset = collectionView.contentInset.right + collectionView.contentInset.left
        let width = collectionView.frame.width / 2 - spaceBetweenCells / 2 - inset / 2
        
        return CGSize(width: width, height: width)
    }

}
















