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
    @IBOutlet weak var btnAddLocation: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        btnAddLocation.hero.id = "top"
        btnNext.hero.id = "next"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        setUpUI()
    }

    @IBAction func nextBtnPress(_ sender: AnyObject){
        
    }
    
    @IBAction func backBtnPress(_ sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpUI(){
        
        if let primary = NewBucketItem.instance.item.addressPrimary{
            btnAddLocation.setTitleWithoutAnimation(title: "Edit Location")
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
    }
}

extension AddBucketLocationVC: UITextFieldDelegate{

}
