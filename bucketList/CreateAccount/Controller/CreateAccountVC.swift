//
//  CreateAccountVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/1/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import Firebase

class CreateAccountVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfFname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.viewTapped))
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func createAccount(_ sender: AnyObject){
        
        if let password = tfPassword.text, let email = tfEmail.text, let fname = tfFname.text{
            if password.containsWhiteSpace(){
                let alert = UIAlertController(title: "Error", message: "Password must not contain spaces.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            if password.count < 6{
                let alert = UIAlertController(title: "Error", message: "Password must contain at least 6 characters.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
        }
        guard let password = tfPassword.text, let email = tfEmail.text, let fname = tfFname.text else{
            return
        }
        signUpUser(email: email, password: password, name: fname)

    }
    
    func signUpUser(email: String, password: String, name: String){
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            guard err == nil else{
                print("user created error", err.debugDescription)
                return
            }
            
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
            ref = db.collection("users").addDocument(data: [
                "email": email,
                "fname": name
                ], completion: { (err) in
                    guard err == nil else{
                        return
                    }
                }
            )
        }
    }
    
    @IBAction func cancelVC(_ sender: AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func viewTapped(){
        self.view.endEditing(true)
    }
    
    func setUpUI(){
        tfEmail.delegate = self
        tfFname.delegate = self
        tfPassword.delegate = self
    }
    
    


}
