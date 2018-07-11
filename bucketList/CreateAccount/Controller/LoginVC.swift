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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginBtnPress(_ sender: AnyObject){
        loginUser(email: email.text!, password: password.text!)
        
        
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    func loginUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            guard error == nil else{
                self.showError(error: error!)
                print("Error logging in - ", error)
                print("Error code localized description - ", error?.localizedDescription)
                print("Error code debug description - ", error.debugDescription)
                return
            }
            
            print("login success! user - ", user)
        }
    }
    
    func showError(error: Error){
        print("the error custom - ", error.customLoginError())
        let alert = UIAlertController(title: "Error", message: error.customLoginError(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }


}
