//
//  AddBucketDetailsVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/11/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import Geofirestore

class AddBucketDetailsVC: UIViewController {

    @IBOutlet weak var tvDetails: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvDetails.delegate = self
        setUpUI()
        
    }
    
    func setUpUI(){
        print("setUpUI()1", NewBucketItem.instance.item.details)
        if NewBucketItem.instance.item.details == nil || NewBucketItem.instance.item.details?.isEmptyOrWhitespace() == true{
            print("setUpUI()2")
            tvDetails.text = "Add any other details here."
            tvDetails.textColor = UIColor().disabledBlack
        } else{
            tvDetails.text = NewBucketItem.instance.item.details
        }
        
        
    }
    
    @IBAction func submitBtnPress(_ sender: AnyObject){
        self.view.endEditing(true)
        print("submit1")
        let ref = DataService.instance.bucketListRef.document()
        
        ref.setData(NewBucketItem.instance.item.itemsToPost()){ error in
        print("submit2")
            guard error == nil else{
                print("error on submit ", error!)
                return
            }
            print("submit3")
            if let geoPoint = NewBucketItem.instance.item.getGeoPoint(){
                print("submit4")
                DataService.instance.currentUserGeoFirestore.setLocation(geopoint: geoPoint, forDocumentWithID: ref.documentID, completion: { (error) in
                    print("submit5")
                    guard error == nil else{
                        print("geoPoint error set ", error!)
                        return
                    }
                    print("submit6")
                    self.performSegue(withIdentifier: "AddBucketDetailsVC", sender: nil)
                })
            }
        }

    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        
        print("tv details.text", tvDetails.text!)
        NewBucketItem.instance.item.details = tvDetails.text!

        self.navigationController?.popViewController(animated: true)
    }
}

extension AddBucketDetailsVC: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("should begin")
        textView.text = ""
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("did begin")
        tvDetails.textColor = UIColor().secondaryBlack
        textView.text = ""
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == tvDetails{
            NewBucketItem.instance.item.details = textView.text!
        }
    }
}
