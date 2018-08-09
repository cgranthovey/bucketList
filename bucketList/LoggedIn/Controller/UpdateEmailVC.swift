//
//  UpdateEmailVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/8/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseAuth

class UpdateEmailVC: UIViewController {
    
    @IBOutlet weak var tfPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func updatePasswordBtnPress(_ sender: AnyObject){
        let tfs: [UITextField] = [tfPassword]
        guard !tfs.containsIncompleteField() else{
            okAlert(title: "Error", message: "Fill in email field.")
            return
        }
        
        Auth.auth().currentUser?.updateEmail(to: tfPassword.text!, completion: { (error) in
            guard error == nil else{
                print("error updating email \(error)")
                if let customError = error?.customAuthError(submitType: AuthSubmitType.updatingEmail){
                    self.okAlert(title: "Error", message: customError)
                }
                return
            }
            print("update success!")
        })
    }

    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }


}
