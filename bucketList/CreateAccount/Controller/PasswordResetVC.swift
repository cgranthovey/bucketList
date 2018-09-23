//
//  PasswordResetVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/7/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseAuth

class PasswordResetVC: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    var requiredFields: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()
        requiredFields = [tfEmail]
        tfEmail.delegate = self
    }
    
    @IBAction func passwordReset(_ sender: AnyObject){
        checkRequiredFields()
    }
    
    func checkRequiredFields(){
        guard !requiredFields.containsIncompleteField() else{
            self.okAlert(title: "Error", message: "Please enter an email address")
            return
        }
        signInUser()
    }
    
    func signInUser(){
        self.view.showBlurLoader()
        Auth.auth().sendPasswordReset(withEmail: tfEmail.text!) { (error) in
            self.view.removeBlurLoader(completionHandler: {
                guard error == nil else{
                    self.okAlert(title: "Error", message: error!.customAuthError(submitType: AuthSubmitType.forgotPassword))
                    return
                }
                let alert = UIAlertController(title: "Email Sent", message: "Check your email address to reset password.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Return to Login", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }

}

extension PasswordResetVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}









