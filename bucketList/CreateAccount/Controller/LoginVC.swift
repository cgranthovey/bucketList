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
        self.view.removeBlurLoader(completionHandler: nil)
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
        print("loginUser1")
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
        print("loginUser2")
            guard error == nil else{
                print("loginUser3")
                self.view.removeBlurLoader(completionHandler: {
                    print("loginUser4")
                    self.okAlert(title: "Error", message: error!.customAuthError(submitType: AuthSubmitType.login))
                })
                return
            }
            print("loginUser5")
            let storboardMain = UIStoryboard(name: "Main", bundle: nil)
            
            if let vc = storboardMain.instantiateViewController(withIdentifier: "UITabBarController") as? UITabBarController{
                print("loginUser6")
//                if (self.navigationController == nil){
//                    
//                } else{
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
                self.present(vc, animated: true, completion: nil)
                

            }
        }
    }


}

extension LoginVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}














