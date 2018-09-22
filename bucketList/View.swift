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
    
    func removeBlurLoader(completionHandler: CompletionHandler?){
        self.subviews.compactMap {  $0 as? UIVisualEffectView }.forEach {
            $0.fadeViewOut(completionHandler: {
                completionHandler?()
            })
        }
    }
    
    class LightLoaderContainer: UIView{
        
    }
    
    func showLightLoader(){
        
        let coverView = LightLoaderContainer(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        coverView.backgroundColor = UIColor.clear
        coverView.alpha = 0
        self.addSubview(coverView)
        
        let lightView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        lightView.backgroundColor = UIColor.black
        lightView.alpha = 0.3
        coverView.addSubview(lightView)
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.startAnimating()
        spinner.center = coverView.center
        coverView.addSubview(spinner)
        UIView.animate(withDuration: 0.3) {
            coverView.alpha = 1
        }
    }
    func removeLightLoader(completionHandler: CompletionHandler?){
        self.subviews.compactMap { $0 as? LightLoaderContainer }.forEach{
            $0.fadeViewOut(completionHandler: {
                completionHandler?()
            })
        }
    }
    
    
    
    
    
    enum LINE_POSITION {
        case LINE_POSITION_TOP
        case LINE_POSITION_BOTTOM
    }
    
    func addLineToView(position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .LINE_POSITION_TOP:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        default:
            break
        }
    }
    
    
}
