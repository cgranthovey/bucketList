//
//  AddBucketDetailsVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/11/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import Firebase

class AddBucketDetailsVC: UIViewController {

    @IBOutlet weak var tvDetails: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvDetails.delegate = self
    }
    
    func setUpUI(){
        tvDetails.text = NewBucketItem.instance.item.details
    }
    
    @IBAction func submit(_ sender: AnyObject){
        
        self.view.endEditing(true)
        DataService.instance.bucketListRef.addDocument(data: NewBucketItem.instance.item.allItems()) { (error) in
            if let error = error{
                print("error when submitting -", error)
            } else{
                self.performSegue(withIdentifier: "AddBucketDetailsVC", sender: nil)
            }
        }
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddBucketDetailsVC: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == tvDetails{
            NewBucketItem.instance.item.details = textView.text!
        }
    }
}
