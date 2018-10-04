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
        print("back bbi", navigationItem.backBarButtonItem?.title)
        navigationItem.backBarButtonItem?.title = ""
        self.navigationController?.navigationItem.backBarButtonItem?.title = " "
//        viewChooseLocation.hero.id = "mainTransform"
//        btnNext.hero.id = "nextToTextView"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpUI()
        extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.hero.navigationAnimationType = .fade
    }

    @IBAction func nextBtnPress(_ sender: AnyObject){
        self.navigationController?.hero.navigationAnimationType = .fade
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddBucketDetailsVC") as? AddBucketDetailsVC{
            vc.hero.isEnabled = true
            vc.navigationController?.hero.navigationAnimationType = .fade
           // self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func chooseLocationBtnPress(_ sender: AnyObject){
        self.navigationController?.hero.navigationAnimationType = .cover(direction: .up)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddBucketMapVC"{
            if let vc = segue.destination as? AddBucketMapVC{
                vc.delegate = self
            }
        }
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

extension AddBucketLocationVC: AddBucketMapDelegate {
    func approvePress(){
        stackLabels.transform = CGAffineTransform(translationX: 0, y: 20)
        stackLabels.alpha = 0
        print("approve press1")
        UIView.animate(withDuration: 0.3, delay: 0.25, options: .curveEaseInOut, animations: {
            print("approve press2")
            self.stackLabels.transform = .identity
            self.stackLabels.alpha = 1
        }) { (success) in
        }
    }
}

extension AddBucketLocationVC: UITextFieldDelegate{

}
