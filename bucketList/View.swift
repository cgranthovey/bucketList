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
        var lightView: UIView!
        var spinner: UIView!
        var successImg: UIImageView!
        var failedLbl: UILabel!
    }
    
    func showLightLoader(){
        
        let coverView = LightLoaderContainer(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        coverView.backgroundColor = UIColor.clear
        coverView.alpha = 0
        self.addSubview(coverView)
        
        let lightView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        lightView.backgroundColor = UIColor.black
        lightView.alpha = 0.45
        coverView.addSubview(lightView)
        coverView.lightView = lightView
        
        let successImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        successImg.image = #imageLiteral(resourceName: "checked")
        successImg.alpha = 0
        successImg.center = coverView.center
        coverView.successImg = successImg
        coverView.addSubview(successImg)
        
        let failedLbl = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width - 15, height: 30))
        failedLbl.text = "Upload failed, try again."
        failedLbl.font = UIFont.init(name: "Arial", size: 11)
        failedLbl.center = coverView.center
        failedLbl.alpha = 0
        failedLbl.textColor = UIColor.white
        coverView.failedLbl = failedLbl
        coverView.addSubview(failedLbl)
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.startAnimating()
        spinner.center = coverView.center
        coverView.addSubview(spinner)
        coverView.spinner = spinner
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
    
    func failedViewOut(completionHandler: CompletionHandler?){
        self.subviews.compactMap { $0 as? LightLoaderContainer }.forEach{
            $0.failFadeViewOut(lightView: $0, completionHandler: {
                completionHandler?()
            })
        }
    }
    
    func successViewOut(completionHandler: CompletionHandler?){
        self.subviews.compactMap { $0 as? LightLoaderContainer }.forEach{
            $0.successFadeViewOut(lightView: $0, completionHandler: {
                completionHandler?()
            })
        }
    }
    
    private func failFadeViewOut(lightView: LightLoaderContainer, completionHandler: CompletionHandler?){
        UIView.animate(withDuration: 0.3, animations: {
            lightView.spinner.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: 0.3, animations: {
                lightView.failedLbl.alpha = 1
            }, completion: { (success) in
                completionHandler?()
            })
        }
    }
    
    private func successFadeViewOut(lightView: LightLoaderContainer, completionHandler: CompletionHandler?){
        
        UIView.animate(withDuration: 0.3, animations: {
            lightView.spinner.alpha = 0
        }) { (success) in
            lightView.successImg.transform = CGAffineTransform(translationX: 0, y: 20)
            UIView.animate(withDuration: 0.3, animations: {
                lightView.successImg.alpha = 1
                lightView.successImg.transform = .identity
            }, completion: { (success) in
                UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseInOut, animations: {
                    self.alpha = 0
                }, completion: { (success) in
                    self.removeFromSuperview()
                    completionHandler?()
                })
            })
        }
    }
    
    func hideLightView(){
        self.subviews.compactMap { $0 as? LightLoaderContainer }.forEach{
            $0.removeFromSuperview()
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
