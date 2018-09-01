//
//  OnboardingVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 6/28/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    var onboardingPageVC: OnboardingPageVC?
    var onLastPage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextBtn(_ sender: AnyObject){
        if onLastPage{
            toLogin()
        } else{
            if let vc = onboardingPageVC{
                vc.goToNextPage(animated: true)
            }
        }
    }
    

    @IBAction func skipBtn(_ sender: AnyObject){
        toLogin()
    }
    
    func toLogin(){
        let loginStoryboard = UIStoryboard(name: "CreateAccount", bundle: nil)
        if let createAccountVC = loginStoryboard.instantiateViewController(withIdentifier: "CreateAccountVC") as? CreateAccountVC{
            createAccountVC.modalTransitionStyle = .flipHorizontal
            self.navigationController?.pushViewController(createAccountVC, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "onboardingPageVC"{
            if let destVC = segue.destination as? OnboardingPageVC{
                onboardingPageVC = destVC
                destVC.pageController = pageControl
                destVC.onboardingDelegate = self
                destVC.infos = [
                    (img: #imageLiteral(resourceName: "hiking"), text: "Jot down your list of Summer Adventures ideas.  \nAnything goes."),
                    (img: #imageLiteral(resourceName: "drawing"), text: "Plan dates, map locations, and estimate costs of activites"),
                    (img: #imageLiteral(resourceName: "hope"), text: "Share bucket list with friends"),
                    (img: #imageLiteral(resourceName: "skydiving"), text:  "\"Say Yes, and you'll figure it out afterwards\" \n-Tina Fey")
                ]
            }
        }
    }


}

extension OnboardingVC: OnboardingPageVCDelegate{
    func lastPage(_ reached: Bool){
        let endTitle = "Get Started"
        if reached{
            onLastPage = true
            nextBtn.setTitle(endTitle, for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                let expand = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                let lower = CGAffineTransform.init(translationX: 0, y: 10)
                self.nextBtn.transform = expand.concatenating(lower)
                self.nextBtn.backgroundColor = UIColor.orange
                self.skipBtn.alpha = 0
            }) { (success) in
                self.skipBtn.isUserInteractionEnabled = false
            }
        } else{
            onLastPage = false
            if nextBtn.titleLabel!.text! == endTitle{
                nextBtn.setTitle("Next", for: .normal)

                UIView.animate(withDuration: 0.3, animations: {
                    self.nextBtn.transform = CGAffineTransform.identity
                    self.nextBtn.backgroundColor = UIColor(red: 37/255, green: 176/255, blue: 1, alpha: 1.0)
                    self.skipBtn.alpha = 1
                }) { (success) in
                    self.skipBtn.isUserInteractionEnabled = true
                }
            }
        }
    }
}














