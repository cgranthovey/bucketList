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
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    var requiredFields = [UITextField]()

    override func viewDidLoad() {
        super.viewDidLoad()
        requiredFields = [password, email]
        password.delegate = self
        email.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dropKB))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        animateUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.removeBlurLoader(completionHandler: nil)
    }
    
    func animateUI(){
        lblTitle.transform = CGAffineTransform(translationX: 0, y: 20)
        lblTitle.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.lblTitle.transform = .identity
            self.lblTitle.alpha = 1
        }) { (success) in
        }
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
    
    @objc func dropKB(){
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillChange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        print("keyboardWillChange1", notification.name)
        
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            print("keyboardWillChange2", notification.name)
            let screenHeight = UIScreen.main.bounds.height
            let btnToBottomOfScreen = screenHeight - btnLogin.frame.origin.y - btnLogin.frame.height
            
            let amountToRaise = keyboardRect.height - btnToBottomOfScreen
            
            if amountToRaise > 0{
                view.frame.origin.y = -amountToRaise - GVar.instance.keyboardToButton
            }
        } else{
            print("keyboardWillChange3", notification.name)
            view.frame.origin.y = 0
        }
        
    }
    
    func loginUser(email: String, password: String){
        self.view.showBlurLoader()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else{
                self.view.removeBlurLoader(completionHandler: {
                    self.okAlert(title: "Error", message: error!.customAuthError(submitType: AuthSubmitType.login))
                })
                return
            }
            let storboardMain = UIStoryboard(name: "Main", bundle: nil)
            
            if let vc = storboardMain.instantiateViewController(withIdentifier: "UITabBarController") as? UITabBarController{
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














