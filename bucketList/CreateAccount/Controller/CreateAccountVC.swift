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
import FirebaseFirestore

class CreateAccountVC: UIViewController {
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfFname: UITextField!
    
    var requiredFields: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()
        requiredFields = [tfPassword, tfEmail, tfFname]
        setUpDelegates()
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.viewTapped))
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func createAccount(_ sender: AnyObject){
        checkRequiredFields()
    }
    
    @IBAction func cancelVC(_ sender: AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkRequiredFields(){
        
        //Check All Fields
        guard !requiredFields.containsIncompleteField() else{
            self.okAlert(title: "Error", message: "Please enter all required fields.")
            return
        }
        
        //Password requirements
        guard tfPassword.text!.count >= 6 else{
            self.okAlert(title: "Error", message: "Password must contain 6 or more characters.")
            tfPassword.showError()
            return
        }
        guard !tfPassword.text!.containsWhiteSpace() else{
            self.okAlert(title: "Error", message: "Password can not include any spaces.")
            tfPassword.showError()
            return
        }
        
        signUpUser(email: tfEmail.text!, password: tfPassword.text!, name: tfFname.text!)
    }
    
    func signUpUser(email: String, password: String, name: String){
        self.view.showBlurLoader()
        print("signUpUser0")
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            guard err == nil && user != nil else{
                print("signUpUser0.4",err)
                self.view.removeBluerLoader(completionHandler: {
                    self.okAlert(title: "Error", message: err!.customAuthError(submitType: AuthSubmitType.createAccount))
                })
                return
            }

            let usersRef = DataService.instance.usersRef
            
            print("signUpUser1", user!.user.uid)
            
            var _ = usersRef.document(user!.user.uid).setData([
                "email": email,
                "fname": name,
                "created": FieldValue.serverTimestamp()
                ], completion: { (err) in
                    guard err == nil else{
                        self.view.removeBluerLoader(completionHandler: nil)
                        return
                    }
                    let storboardMain = UIStoryboard(name: "Main", bundle: nil)
                    if let vc = storboardMain.instantiateViewController(withIdentifier: "UITabBarController") as? UITabBarController{
                        self.present(vc, animated: true, completion: {
                            self.view.removeBluerLoader(completionHandler: nil)
                        })
                    }
                }
            )
        }
    }
    
    @objc func viewTapped(){
        self.view.endEditing(true)
    }
    
    func setUpDelegates(){
        tfEmail.delegate = self
        tfFname.delegate = self
        tfPassword.delegate = self
    }
}

//MARK: TF Delegate
extension CreateAccountVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}












