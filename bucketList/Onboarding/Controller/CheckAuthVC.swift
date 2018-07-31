//
//  CheckAuthVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/11/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseAuth

class CheckAuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "UITabBarController") as? UITabBarController{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else{
            performSegue(withIdentifier: "UITabBarController", sender: nil)
        }
        
    }


}
