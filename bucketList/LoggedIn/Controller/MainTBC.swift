//
//  MainTBC.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/5/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class MainTBC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        if let vc = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsNav") as? UINavigationController{
            let profileItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "settings"), selectedImage: #imageLiteral(resourceName: "settings"))
            vc.tabBarItem = profileItem
            self.viewControllers?.append(vc)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

}
