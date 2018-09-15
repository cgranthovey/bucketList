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
        
        self.hero.isEnabled = true
        self.hero.tabBarAnimationType = .fade
        
        selectedIndex = 1
        
        let grayView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        grayView.backgroundColor = UIColor().extraLightGrey
        view.addSubview(grayView)
        
        var timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
            self.selectedIndex = 0
            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseIn, animations: {
                grayView.alpha = 0
            }, completion: { (success) in
                grayView.removeFromSuperview()
            })
        }
        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        if let vc = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsVC") as? SettingsVC{
            let profileItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "settings"), selectedImage: #imageLiteral(resourceName: "settings"))
            vc.tabBarItem = profileItem
            profileItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            self.viewControllers?.append(vc)
        }
        UITabBar.appearance().tintColor = UIColor().primaryColor
//        UITabBar.appearance().barTintColor = UIColor.white
//        UITabBar.appearance().backgroundColor = UIColor.white
//        self.tabBar.isTranslucent = true
        self.tabBar.barTintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        

    }

}
