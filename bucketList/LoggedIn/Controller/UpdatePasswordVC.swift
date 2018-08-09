//
//  UpdatePasswordVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/8/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseAuth

class UpdatePasswordVC: UIViewController {
    
    @IBOutlet weak var tfCurrentPassword: UITextField!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfRepeatNewPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func changePasswordBtnPress(_ sender: AnyObject){
        let tfs: [UITextField] = [tfCurrentPassword, tfNewPassword, tfRepeatNewPassword]
        guard !tfs.containsIncompleteField() else{
            okAlert(title: "Error", message: "Complete all fields")
            return
        }
        
        let checkIfGood = tfNewPassword.isGoodPassword(otherTF: tfRepeatNewPassword)
        guard checkIfGood.isGood else{
            if let error = checkIfGood.error{
                okAlert(title: "Error", message: error)
            }
            return
        }
        
        if let currentUserEmail = CurrentUser.instance.user.email{
            Auth.auth().signIn(withEmail: currentUserEmail, password: tfCurrentPassword.text!) { (auth, error) in
                guard error == nil else{
                    print("currentUserEmail error \(error!)")
                    if let customError = error?.customAuthError(submitType: AuthSubmitType.updatingPassword){
                        self.okAlert(title: "Error", message: customError)
                    }
                    return
                }
                
                Auth.auth().currentUser?.updatePassword(to: self.tfNewPassword.text!, completion: { (error) in
                    guard error == nil else{
                        print("update password error - \(error!)")
                        self.okAlert(title: "Error", message: "Error with updating password.")
                        if let customError = error?.customAuthError(submitType: AuthSubmitType.updatingPassword){
                            self.okAlert(title: "Error", message: customError)
                        }
                        return
                    }
                    print("success!")
                })
            }
        }
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    

}




