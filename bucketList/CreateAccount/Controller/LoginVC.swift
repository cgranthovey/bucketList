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
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.removeBluerLoader(completionHandler: nil)
    }
    
    @IBAction func loginBtnPress(_ sender: AnyObject){
        guard !requiredFields.containsIncompleteField() else{
            self.okAlert(title: "Error", message: "Please enter all required fields.")
            return
        }
        loginUser(email: email.text!, password: password.text!)
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
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
            
            if let vc = storboardMain.instantiateViewController(withIdentifier: "UITabBarController") as? UITabBarController{
                self.navigationController?.pushViewController(vc, animated: true)

            }
        }
    }


}

extension LoginVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}














