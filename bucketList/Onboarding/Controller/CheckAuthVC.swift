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

    var userLoggedOut = false
    
    @IBOutlet weak var viewLoggedOut: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "UITabBarController") as? MainTBC{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else{
            performSegue(withIdentifier: "OnboardingVC", sender: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userLoggedOut{
            viewLoggedOut.isHidden = false
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { (timer) in
                self.performSegue(withIdentifier: "OnboardingVC", sender: nil)
            }
        } else{
            viewLoggedOut.isHidden = true
        }
    }
    


}




