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
        let tap = UITapGestureRecognizer(target: self, action: #selector(UpdatePasswordVC.dropKB))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dropKB(){
        self.view.endEditing(true)
    }
    
    @IBAction func changePasswordBtnPress(_ sender: AnyObject){
        dropKB()
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
            self.view.showBlurLoader()
            Auth.auth().signIn(withEmail: currentUserEmail, password: tfCurrentPassword.text!) { (auth, error) in
                guard error == nil else{
                    print("currentUserEmail error \(error!)")
                    self.view.removeBlurLoader(completionHandler: {
                        
                        if let customError = error?.customAuthError(submitType: AuthSubmitType.updatingPassword){
                            self.okAlert(title: "Error", message: customError)
                            
                        }
                    })
                    return
                }
                
                Auth.auth().currentUser?.updatePassword(to: self.tfNewPassword.text!, completion: { (error) in
                    guard error == nil else{
                        print("update password error - \(error!)")
                        self.okAlert(title: "Error", message: "Error with updating password.")
                        self.view.removeBlurLoader(completionHandler: {
                            
                            if let customError = error?.customAuthError(submitType: AuthSubmitType.updatingPassword){
                                self.okAlert(title: "Error", message: customError)
                                
                            }
                        })
                        return
                    }
                    self.view.removeBlurLoader(completionHandler: {
                        self.okAlert(title: "Success", message: "Password successfully updated.")
                        print("success!")
                    })
                })
            }
        }
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}




