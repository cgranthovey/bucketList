//
//  ProfileVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/5/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    
    @IBOutlet weak var tfFName: UILabel!
    @IBOutlet weak var tfLName: UILabel!
    @IBOutlet weak var IVProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func signoutBtnPress(_ sender: AnyObject){
        do{
            if let vc = self.navigationController?.viewControllers.filter({$0 is CheckAuthVC}).first as? CheckAuthVC{
                vc.userLoggedOut = true
                self.navigationController?.popToViewController(vc, animated: true)
            }
            try Auth.auth().signOut()

        } catch let error{
            print("error signing out - \(error)")
        }
        
    }


}
