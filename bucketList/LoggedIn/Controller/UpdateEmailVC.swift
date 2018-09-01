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
        print("updateEmail0")
        Auth.auth().currentUser?.updateEmail(to: tfNewEmail.text!, completion: { (error) in
            print("updateEmail1", error)
            guard error == nil else{
                print("error updating email \(error.debugDescription)")
                
                guard error!.localizedDescription != "This operation is sensitive and requires recent authentication. Log in again before retrying this request." else{
                    print("updateEmail2")
                    //self.showNeedLoginInfoAlert()
                    return
                }
                print("updateEmail3")
                if let customError = error?.customAuthError(submitType: AuthSubmitType.updatingEmail){
                    print("updateEmail4")
                    self.okAlert(title: "Error", message: customError)
                }
                return
            }
            DataService.instance.currentUserDoc.updateData([
                "email": self.tfNewEmail.text!
            ], completion: { (error) in
                if (error != nil){
                    print("error pasting to db!")
                }
                
            })
            print("update success!")
        })
    }
    
    func showNeedLoginInfoAlert(){
        let alert = UIAlertController(title: "Error", message: "Current email and password is needed before updating.", preferredStyle: .alert)
        alert.addTextField { (tfPassword) in
            tfPassword.placeholder = "Password"
            tfPassword.isSecureTextEntry = true
        }
        alert.addTextField { (tfEmail) in
            tfEmail.placeholder = "Email"
        }
        
        alert.addAction(UIAlertAction(title: "Validate", style: .default, handler: { (action) in
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        
        present(alert, animated: true, completion: nil)
    }

    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }


}
