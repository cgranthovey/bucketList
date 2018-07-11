//
//  LoginVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 6/29/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseCore

class LoginVC: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    var requiredFields = [UITextField]()

    override func viewDidLoad() {
        super.viewDidLoad()
        requiredFields = [password, email]
        password.delegate = self
        email.delegate = self
    }
    
    @IBAction func loginBtnPress(_ sender: AnyObject){
        guard !requiredFields.containsIncompleteField() else{
            self.okAlert(title: "Error", message: "Please enter all required fields.")
            return
        }
        loginUser(email: email.text!, password: password.text!)
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    func loginUser(email: String, password: String){
        self.view.showBlurLoader()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            guard error == nil else{
                self.view.removeBluerLoader(completionHandler: {
                    self.okAlert(title: "Error", message: error!.customAuthError(submitType: AuthSubmitType.login))
                })
                return
            }

            let storboardMain = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storboardMain.instantiateViewController(withIdentifier: "LandingVC") as? LandingVC{
                self.present(vc, animated: true, completion: {
                    self.view.removeBluerLoader(completionHandler: nil)
                })
            }
        }
    }


}

extension LoginVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}














