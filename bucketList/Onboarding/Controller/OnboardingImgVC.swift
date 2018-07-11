//
//  OnboardingImgVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 6/28/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class OnboardingImgVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    
    var img: UIImage?{
        didSet{
            if let img = img{
                imgView?.image = img
            }
        }
    }
    var text: String?{
        didSet{
            if let text = text{
                lbl?.text = text
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let img = img{
            imgView.image = img
        }
        if let text = text{
            lbl.text = text
        }
    }


}
