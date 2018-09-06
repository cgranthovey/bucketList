//
//  AddBucketLocationVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/11/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class AddBucketLocationVC: UIViewController {

    @IBOutlet weak var lblAddressPrimary: UILabel!
    @IBOutlet weak var lblAddressSecondary: UILabel!
    @IBOutlet weak var stackLabels: UIStackView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnChooseLocation: UILabel!
    @IBOutlet weak var viewChooseLocation: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true

        viewChooseLocation.hero.id = "mainTransform"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        print("add bucket map details", NewBucketItem.instance.item.details)

        setUpUI()
        print("add bucket map details 0.5", NewBucketItem.instance.item.details)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("add bucket map details 0.9", NewBucketItem.instance.item.details)

    }
    
    

    @IBAction func nextBtnPress(_ sender: AnyObject){
        print("add bucket map details2", NewBucketItem.instance.item.details)

        self.navigationController?.hero.navigationAnimationType = .fade
    }
    
    @IBAction func chooseLocationBtnPress(_ sender: AnyObject){
        self.navigationController?.hero.navigationAnimationType = .cover(direction: .up)
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.hero.navigationAnimationType = .fade
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpUI(){
        
        if let primary = NewBucketItem.instance.item.addressPrimary{
            btnChooseLocation.text = "Edit Location"
            lblAddressPrimary.text = primary
            lblAddressPrimary.isHidden = false
        } else{
            lblAddressPrimary.isHidden = true
        }
        if let secondary = NewBucketItem.instance.item.addressSeconary{
            lblAddressSecondary.text = secondary
            lblAddressSecondary.isHidden = false
        } else{
            lblAddressSecondary.isHidden = true
        }
        if lblAddressPrimary.isHidden && lblAddressSecondary.isHidden{
            stackLabels.isHidden = true
            btnNext.isHidden = true
        } else{
            stackLabels.isHidden = false
            btnNext.isHidden = false
        }
    }
}

extension AddBucketLocationVC: UITextFieldDelegate{

}
