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

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
//        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
//            let width = self.collectionView.frame.size.width / CGFloat(3.0)
//            flowLayout.itemSize = CGSize(width: width, height: width)
//        }
        
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


}

extension BucketDetails: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cv1")
        if indexPath.row == 0, let bucketItem = bucketItem{
            print("cv2")
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellDetails", for: indexPath) as? DetailDataCell{
                cell.configure(item: bucketItem)
                return cell
            }
        }
        if indexPath.row > 0{
            print("cv3")
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DetailImgCell{
                print("cv4")
                cell.configure(imgUrl: images[indexPath.row - 1])
                print("cv5")
                return cell
            }
        }
        return UICollectionViewCell()
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.row > 0{
//            print("in it all")
//            let width = self.view.frame.width / 3.0
//            return CGSize(width: width, height: width)
//        }
//        print("in it all2", UICollectionViewFlowLayoutAutomaticSize.height)
//        print("in it all2", collectionView.contentInset)
//        return CGSize(width: collectionView.frame.size.width, height: UICollectionViewFlowLayoutAutomaticSize.height)
//    }
//
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        <#code#>
//    }
}
















