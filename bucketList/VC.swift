//
//  VC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/7/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func okAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
