//
//  OnboardingPageVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 6/27/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

struct onboardingStoryboard {
    static let name = "Onboarding"
    static let imgVC = "onboardingImgVC"
}

protocol OnboardingPageVCDelegate {
    func lastPage(_ reached: Bool)
}

class OnboardingPageVC: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        turnToPage(index: nextIndex)
        pageController.numberOfPages = infos.count
    }
    
    var infos: [(img: UIImage, text: String)] = []
    var pageController: UIPageControl!
    var direction = UIPageViewControllerNavigationDirection.forward
    var nextIndex = 0
    var onboardingDelegate: OnboardingPageVCDelegate!
    
    lazy var controllers: [UIViewController] = {
        let storyboard = UIStoryboard(name: onboardingStoryboard.name, bundle: nil)
        var controllers = [UIViewController]()
        for info in infos{
            let onboardingImgVC = storyboard.instantiateViewController(withIdentifier: onboardingStoryboard.imgVC)
            controllers.append(onboardingImgVC)
        }
        return controllers
    }()
    
    func turnToPage(index: Int){
        let controller = controllers[index]
        var direction = UIPageViewControllerNavigationDirection.forward
        if let currentVC = viewControllers?.first{
            let currentIndex = controllers.index(of: currentVC)
            
            if currentIndex! > index{
                direction = .reverse
            }
        }
        configureVC(vc: controller)
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
    func configureVC(vc: UIViewController){
        for (index, controller) in controllers.enumerated(){
            if vc == controller{
                if let vc = vc as? OnboardingImgVC{
                    vc.img = infos[index].img
                    vc.text = infos[index].text
                }
            }
        }
    }


}

extension OnboardingPageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of: viewController){
            if index > 0{
                return controllers[index - 1]
            }
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of: viewController){
            if index < controllers.count - 1{
                return controllers[index + 1]
            }
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.configureVC(vc: pendingViewControllers.first as! OnboardingImgVC)
        if let index = controllers.index(of: pendingViewControllers.first!){
            nextIndex = index
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed{
            self.configureVC(vc: previousViewControllers.first as! OnboardingImgVC)
        } else{
            if nextIndex == infos.count - 1{
                onboardingDelegate.lastPage(true)
            } else{
                onboardingDelegate.lastPage(false)
            }
            pageController.currentPage = nextIndex
        }
    }
    
    
    func goToNextPage(animated: Bool = true) {
        
        guard let currentViewController = self.viewControllers?.first as? OnboardingImgVC else { return }
        
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        configureVC(vc: nextViewController)
        nextIndex += 1
        pageController.currentPage = nextIndex
        
        if nextIndex == infos.count - 1{
            onboardingDelegate.lastPage(true)
        } else{
            onboardingDelegate.lastPage(false)
        }
        
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
    }
    
    func goToPreviousPage(animated: Bool = true) {
        onboardingDelegate.lastPage(false)
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: animated, completion: nil)
    }
}













