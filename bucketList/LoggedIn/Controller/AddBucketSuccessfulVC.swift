//
//  AddBucketSuccessfulVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/12/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class AddBucketSuccessfulVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func homeBtnPress(_ sender: AnyObject){
        if let vc = self.navigationController?.viewControllers.filter({$0 is LandingVC}).first{
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
}
