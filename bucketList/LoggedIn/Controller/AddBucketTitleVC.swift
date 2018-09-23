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
    @IBOutlet weak var btnNext: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        tfTitle.delegate = self
        
//        btnNext.hero.id = "mainTransform"
        self.navigationController?.hero.isEnabled = true
        self.navigationController?.hero.navigationAnimationType = .fade
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddBucketTitleVC.dismissKB))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpUI()
    }
    
    @objc func dismissKB(){
        self.view.endEditing(true)
    }
    
    @IBAction func nextBtnPress(_ sender: AnyObject){
        NotificationCenter.default.post(name: NSNotification.Name("newItem"), object: nil)

        guard tfTitle.hasText else{
            okAlert(title: "Error", message: "Complete title field.")
            return
        }
        dismissKB()
    }
    
    func setUpUI(){
        tfTitle.text = NewBucketItem.instance.item.title
    }
}

extension AddBucketTitleVC: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfTitle{
            let title = tfTitle.text!
            NewBucketItem.instance.item.title = title
        }
    }
}
