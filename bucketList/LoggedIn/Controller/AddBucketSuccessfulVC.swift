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
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NewBucketItem.instance.clearItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("newItem"), object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }

    @IBAction func homeBtnPress(_ sender: AnyObject){
        self.navigationController?.hero.modalAnimationType = .zoomOut
        if let vc = self.navigationController?.viewControllers.filter({$0 is AddBucketTitleVC}).first{
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
}
