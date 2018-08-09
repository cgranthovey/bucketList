
//
//  UpdateNameVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/6/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseFirestore

class UpdateNameVC: UIViewController {
    
    @IBOutlet weak var tfFName: UITextField!
    @IBOutlet weak var tfLName: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI(){
        if let fname = CurrentUser.instance.user.fname{
            tfFName.text = fname
        }
        if let lname = CurrentUser.instance.user.lname{
            tfLName.text = lname
        }
        
    }
    
    @IBAction func updateInfoPress(_ sender: AnyObject){
        let tfs: [UITextField] = [tfFName, tfLName]
        guard !tfs.containsIncompleteField() else{
            okAlert(title: "Error", message: "Fill in all fields.")
            return
        }
        tfs.clearError()
        DataService.instance.currentUserDoc.updateData(["fname": tfFName.text!, "lname": tfLName.text!])
    }



}
