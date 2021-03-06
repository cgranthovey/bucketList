//
//  SettingsVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/15/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseAuth
import Hero

struct tblCellInfo{
    var text: String
    var vc: UIViewController
}

class SettingsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let updateName = tblCellInfo(text: "Update Name", vc: UpdateNameVC())
    var selectedIndexPath: IndexPath!
//    let settings2: [tblCellInfo] = [tblCellInfo.ini]
    let settings: [String] = ["Update Name", "Profile Image", "Change Password", "Change Email", "Log Out"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func logOutAlert(){
        let alert = UIAlertController(title: "Logout", message: "Are you sure you would like to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            print("logOut ok")
            do{
                print("logOut ok2", self.navigationController?.viewControllers.count)
//                if let vc = self.navigationController?.viewControllers.filter({$0 is CheckAuthVC}).first as? CheckAuthVC{
//                    vc.userLoggedOut = true
//
//                    print("logOut ok2.2")
//                }
                

                let storyboard = UIStoryboard(name: "CreateAccount", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController{
                    print("logOut ok3")
                    self.hero.isEnabled = true
                    self.hero.modalAnimationType = HeroDefaultAnimationType.zoomSlide(direction: .right)
                    vc.hero.isEnabled = true
                    self.present(vc, animated: true, completion: nil)
                }
//              self.navigationController?.popToRootViewController(animated: true)
                print("logOut ok4")
                
                try Auth.auth().signOut()
            } catch let error {
                print("error signing out", error)
            }
            print("after")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        if let ip = selectedIndexPath{
            tableView.deselectRow(at: ip, animated: false)
        }
    }

}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? LblArrowCell{
            cell.configure(str: settings[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? LblArrowCell{
            selectedIndexPath = indexPath
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            if cell.lbl.text! == "Update Name"{
                if let vc = storyboard.instantiateViewController(withIdentifier: "Update Name") as? UpdateNameVC{
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            if cell.lbl.text! == "Profile Image"{
                if let vc = storyboard.instantiateViewController(withIdentifier: "Profile Image") as? UpdateProfileVC{
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            if cell.lbl.text! == "Change Password"{
                if let vc = storyboard.instantiateViewController(withIdentifier: "Change Password") as? UpdatePasswordVC{
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            if cell.lbl.text! == "Change Email"{
                if let vc = storyboard.instantiateViewController(withIdentifier: "Change Email") as? UpdateEmailVC{
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            if cell.lbl.text! == "Log Out"{
                logOutAlert()
            }
        }
    }
}
