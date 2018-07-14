//
//  AddBucketLocationVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/11/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class AddBucketLocationVC: UIViewController {
    
    @IBOutlet weak var tfLocation: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        tfLocation.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tfLocation.text = NewBucketItem.instance.item.location
    }

    @IBAction func nextBtnPress(_ sender: AnyObject){
        
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddBucketLocationVC: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        tfLocation.delegate = self
        if textField == tfLocation{
            NewBucketItem.instance.item.location = tfLocation.text!
        }
    }
}
