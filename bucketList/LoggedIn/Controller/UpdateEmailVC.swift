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
    
    @IBOutlet weak var tfCurrentEmail: UITextField!
    @IBOutlet weak var tfCurrentPassword: UITextField!
    @IBOutlet weak var tfNewEmail: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let email = CurrentUser.instance.user.email{
            tfCurrentEmail.text = email
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(UpdatePasswordVC.dropKB))
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func dropKB(){
        self.view.endEditing(true)
    }
    
    @IBAction func updatePasswordBtnPress(_ sender: AnyObject){
        let tfs: [UITextField] = [tfCurrentEmail, tfCurrentPassword, tfNewEmail]
        tfs.clearError()
        guard !tfs.containsIncompleteField() else{
            okAlert(title: "Error", message: "Fill in all field.")
            return
        }
        validateEmailPassword()
    }
    
    func validateEmailPassword(){
        print("validateEmailPassword")
        Auth.auth().signIn(withEmail: tfCurrentEmail.text!, password: tfCurrentPassword.text!) { (auth, error) in
            print("validateEmailPassword1")
            guard error == nil else{
                print("validateEmailPassword2")
                if let errorStr = error?.customAuthError(submitType: AuthSubmitType.validatingEmailPassword){
                    print("validateEmailPasswor3")
                    self.okAlert(title: "Error", message: errorStr)
                }
                return
            }
            print("validateEmailPassword4")
            self.updateEmail()
        }
    }
    
    func updateEmail(){
        
        //        Auth.auth().signIn(withEmail: currentUserEmail, password: tfCurrentPassword.text!) { (auth, error) in
        
        guard Auth.auth().currentUser != nil && Auth.auth().currentUser?.email != nil else{
            return
        }
        dropKB()
        self.view.showBlurLoader()
        
        
        Auth.auth().signIn(withEmail: Auth.auth().currentUser!.email!, password: tfNewEmail.text!) { (auth, error) in
            guard error == nil else{
                self.view.removeBlurLoader(completionHandler: {
                    
                    if let customError = error?.customAuthError(submitType: AuthSubmitType.updatingPassword){
                        self.okAlert(title: "Error", message: customError)
                    }
                })
                return
            }
            Auth.auth().currentUser?.updateEmail(to: self.tfNewEmail.text!, completion: { (error) in
                guard error == nil else{
                    self.view.removeBlurLoader(completionHandler: {
                        if let customError = error?.customAuthError(submitType: AuthSubmitType.updatingEmail){
                            self.okAlert(title: "Error", message: customError)
                        }
                    })
                    return
                }
                DataService.instance.currentUserDoc.updateData([
                    "email": self.tfNewEmail.text!
                    ], completion: { (error) in
                        self.view.removeBlurLoader(completionHandler: {
                            if (error != nil){
                                self.okAlert(title: "Error", message: "Error updating email, please try again.")
                            } else{
                                self.okAlert(title: "Success", message: "Email updated.")
                            }
                        })
                })
            })
        }
        
        
    }
    
    //    func showNeedLoginInfoAlert(){
    //        let alert = UIAlertController(title: "Error", message: "Current email and password is needed before updating.", preferredStyle: .alert)
    //        alert.addTextField { (tfPassword) in
    //            tfPassword.placeholder = "Password"
    //            tfPassword.isSecureTextEntry = true
    //        }
    //        alert.addTextField { (tfEmail) in
    //            tfEmail.placeholder = "Email"
    //        }
    //
    //        alert.addAction(UIAlertAction(title: "Validate", style: .default, handler: { (action) in
    //
    //        }))
    //        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    //        present(alert, animated: true, completion: nil)
    //    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
