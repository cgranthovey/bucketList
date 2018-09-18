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
    @IBOutlet weak var btnSubmit: UIButton!
    var textViewOriginalHeight: CGFloat! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvDetails.delegate = self
        setUpUI()
        tvDetails.hero.isEnabled = true
        tvDetails.hero.id = "nextToTextView"
//        btnSubmit.hero.modifiers = [.fade, .scale(0.8), .translate(x: 0, y: 50, z: 0)]
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
        
        tvDetails.translatesAutoresizingMaskIntoConstraints = false
        tvDetails.isScrollEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddBucketDetailsVC.dismissKB))
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKB(){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textViewOriginalHeight = tvDetails.frame.height
    }

    @IBAction func submitBtnPress(_ sender: AnyObject){
        self.view.endEditing(true)
        let ref = DataService.instance.bucketListRef.document()
        ref.setData(NewBucketItem.instance.item.itemsToPost()){ error in
            guard error == nil else{
                print("error on submit ", error!)
                return
            }
            if let geoPoint = NewBucketItem.instance.item.getGeoPoint(){
                
                DataService.instance.currentUserGeoFirestore.setLocation(geopoint: geoPoint, forDocumentWithID: ref.documentID, completion: { (error) in
                    guard error == nil else{
                        print("geoPoint error set ", error!)
                        return
                    }
                    self.navigationController?.hero.modalAnimationType = .zoom
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
    func textViewDidChange(_ textView: UITextView) {
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height{
                let inset = textView.textContainerInset
                let width = textView.frame.width - inset.left - inset.right
                let size = CGSize(width: textView.frame.width, height: .infinity)
                let estimatedSize = textView.sizeThatFits(size)
                if estimatedSize.height >= textViewOriginalHeight{
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}














