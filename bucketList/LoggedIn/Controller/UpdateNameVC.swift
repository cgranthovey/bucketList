
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
    
    override func viewWillAppear(_ animated: Bool) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UpdatePasswordVC.dropKB))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dropKB(){
        self.view.endEditing(true)
    }
    
    func setUpUI(){
        if let fname = CurrentUser.instance.user.fname{
            tfFName.text = fname
        }
        if let lname = CurrentUser.instance.user.lname{
            tfLName.text = lname
        }
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateInfoPress(_ sender: AnyObject){
        dropKB()
        let tfs: [UITextField] = [tfFName, tfLName]
        guard !tfs.containsIncompleteField() else{
            okAlert(title: "Error", message: "Fill in all fields.")
            return
        }
        self.view.showBlurLoader()
        tfs.clearError()
        DataService.instance.currentUserDoc.updateData( ["fname": tfFName.text!, "lname": tfLName.text!], completion: { (error) in
            self.view.removeBlurLoader(completionHandler: {
                
                guard error == nil else{
                    self.okAlert(title: "Error", message: "Error updating name, please try again later")
                    return
                }
                self.okAlert(title: "Success", message: "Name successfully updated.")
            })
        })
    }
}



