//
//  LargeImageVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/8/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import Hero
import AVKit

class LargeImageVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!

    var newImg: UIImage!
    var imgURLString: String!
    var imgViewAnimate: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(LargeImageVC.handlePan(_:)))
        self.view.addGestureRecognizer(pan)
        self.view.isUserInteractionEnabled = true

        
        imgView.image = newImg
        let size = imgView.imageSize
        imgView.image = nil
        
        let yCoordinate = (view.frame.height - size.height) / 2
        let xCoordinate = (view.frame.width - size.width) / 2
        
        imgViewAnimate = UIImageView(frame: CGRect(x: xCoordinate, y: yCoordinate, width: size.width, height: size.height))
        imgViewAnimate.backgroundColor = UIColor().extraLightGrey
        view.addSubview(imgViewAnimate)
        imgViewAnimate.image = newImg
        imgViewAnimate.hero.id = "toLargeImg"
        imgViewAnimate.hero.modifiers = [HeroModifier.zPosition(5), HeroModifier.useGlobalCoordinateSpace]
        imgViewAnimate.addGestureRecognizer(pan)
        imgViewAnimate.isUserInteractionEnabled = true
    }

    @objc func dismissVC(){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let url = URL(string: imgURLString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: nil)
        let progress = translation.y / 2 / view.bounds.height
        
        switch sender.state{
        case .began:
            hero.dismissViewController()
        case .changed:
            Hero.shared.update(progress)
            let currentPosition = CGPoint(x: translation.x + imgViewAnimate.center.x, y: translation.y + imgViewAnimate.center.y)
            Hero.shared.apply(modifiers: [.position(currentPosition)], to: imgViewAnimate)
            
        default:
            if progress + sender.velocity(in: nil).y / view.bounds.height > 0.2{
                Hero.shared.finish()
            } else{
                Hero.shared.cancel()
            }
        }
    }


}
