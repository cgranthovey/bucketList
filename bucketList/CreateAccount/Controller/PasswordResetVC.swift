//
//  PasswordResetVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/7/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseAuth
import Hero

class PasswordResetVC: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    var requiredFields: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()
        requiredFields = [tfEmail]
        tfEmail.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dropKB))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PasswordResetVC.keyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PasswordResetVC.keyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PasswordResetVC.keyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblTitle.transform = CGAffineTransform(translationX: 0, y: 20)
        lblTitle.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.lblTitle.transform = .identity
            self.lblTitle.alpha = 1
        }) { (success) in
        }
    }
    
    @IBAction func passwordReset(_ sender: AnyObject){
        checkRequiredFields()
    }
    
    @objc func dropKB(){
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillChange(notification: Notification){
        if let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame{
                let submitBtnBottomY = btnSubmit.frame.origin.y + btnSubmit.frame.height
                let toBottom = UIScreen.main.bounds.height - submitBtnBottomY
                let distanceToAdjust = keyboardRect.height - toBottom
                
                print("distance to adjust", distanceToAdjust)
                print("keyboardRect.height", keyboardRect.height)
                print("submitBtnBottom", toBottom)
                
                if distanceToAdjust > 0{
                    self.view.frame.origin.y = -distanceToAdjust - GVar.instance.keyboardToButton
                }
            } else{
                self.view.frame.origin.y = 0
            }
        }
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









