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
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCreate: UIButton!
    
    var requiredFields: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()
        requiredFields = [tfPassword, tfEmail, tfFname]
        setUpDelegates()
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.viewTapped))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateAccountVC.keyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateAccountVC.keyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateAccountVC.keyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        lblTitle.transform = CGAffineTransform(translationX: 0, y: 20)
        lblTitle.alpha = 0
        tfPassword.alpha = 0
        tfEmail.alpha = 0
        tfFname.alpha = 0
        btnCreate.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.lblTitle.transform = .identity
            self.lblTitle.alpha = 1
            self.tfPassword.alpha = 1
            self.tfEmail.alpha = 1
            self.tfFname.alpha = 1
            self.btnCreate.alpha = 1
        }) { (success) in
        }
        

        
        if let nav = self.navigationController{
            if nav.viewControllers.count > 1{
            }
        }
    }
    
    @objc func keyboardWillChange(notification: Notification){
        
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame{
                
                let btnBottomHeight = btnCreate.frame.origin.y + btnCreate.frame.height
                let screenHeight = UIScreen.main.bounds.height
                let btnCreateToBottom = screenHeight - btnBottomHeight
                
                let amountToAdjust = keyboardHeight.height - btnCreateToBottom
                if amountToAdjust > 0{
                    self.view.frame.origin.y = -amountToAdjust - GVar.instance.keyboardToButton
                }
                
            } else{
                self.view.frame.origin.y = 0
            }
        }
    }
    
    @IBAction func createAccount(_ sender: AnyObject){
        self.view.endEditing(true)

        checkRequiredFields()
    }
    
    @IBAction func cancelVC(_ sender: AnyObject){
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        } else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
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
                self.view.removeBlurLoader(completionHandler: {
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
                        self.view.removeBlurLoader(completionHandler: nil)
                        return
                    }
                    let storboardMain = UIStoryboard(name: "Main", bundle: nil)
                    if let vc = storboardMain.instantiateViewController(withIdentifier: "UITabBarController") as? UITabBarController{
                        self.present(vc, animated: true, completion: {
                            self.view.removeBlurLoader(completionHandler: nil)
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












