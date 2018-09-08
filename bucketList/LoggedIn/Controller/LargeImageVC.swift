//
//  LargeImageVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/8/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class LargeImageVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    var imgURLString: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("largeImageVC")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear0")
        let url = URL(string: imgURLString)
      //  self.hero.isEnabled = true
       // imgView.hero.id = "toLargeImg"
        print("viewWillAppear", imgURLString)
        imgView.sd_setHighlightedImage(with: url, options: .progressiveDownload, completed: { (img, err, cache, url) in
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}
