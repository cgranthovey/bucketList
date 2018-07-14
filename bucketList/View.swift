//
//  View.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/5/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func showBlurLoader(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame.size.height = 100
//        blurEffectView.frame.size.width = 100
//        blurEffectView.center = self.center
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        
        blurEffectView.alpha = 0
        self.addSubview(blurEffectView)
        
        
        UIView.animate(withDuration: 0.3) {
            blurEffectView.alpha = 1
        }
        
    }
    
    func fadeViewOut(completionHandler: CompletionHandler?){
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (success) in
            self.removeFromSuperview()
            completionHandler?()
        }
    }
    
    typealias CompletionHandler = () -> Void
    
    func removeBluerLoader(completionHandler: CompletionHandler?){
        self.subviews.compactMap {  $0 as? UIVisualEffectView }.forEach {
            //$0.removeFromSuperview()
            $0.fadeViewOut(completionHandler: {
                completionHandler?()
            })
//            $0.fadeViewOut()
//            if let handler = completionHandler{
//                handler()
//            }
            
//            UIView.animate(withDuration: 0.3, animations: {
//                $0.alpha = 0
//            }, completion: { (success) in
//                success.removeFromSuperview()
//            })
//
            
        }
    }
}
