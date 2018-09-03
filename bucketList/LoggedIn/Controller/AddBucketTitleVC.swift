//
//  AddBucketTitleVC
//  bucketList
//
//  Created by Christopher Hovey on 7/11/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import Firebase
import Geofirestore
import Hero


class AddBucketTitleVC: UIViewController {
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        tfTitle.delegate = self
        tfPrice.delegate = self
        
        tfPrice.hero.id = "top"
        btnNext.hero.id = "next"
        self.navigationController?.hero.isEnabled = true
        self.navigationController?.hero.navigationAnimationType = .fade
    }
    
    @IBAction func nextBtnPress(_ sender: AnyObject){
        
    }
    
    func setUpUI(){
        tfTitle.text = NewBucketItem.instance.item.title
        tfPrice.text = NewBucketItem.instance.item.price
    }
    
}

extension AddBucketTitleVC: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfTitle{
            let title = tfTitle.text!
            NewBucketItem.instance.item.title = title
        }
        
        if textField == tfPrice{
            let price = tfPrice.text!
            NewBucketItem.instance.item.price = price
        }
    }
}
