//
//  SettingsVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/15/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseAuth

struct tblCellInfo{
    var text: String
    var vc: UIViewController
}

class SettingsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let updateName = tblCellInfo(text: "Update Name", vc: UpdateNameVC())
    
//    let settings2: [tblCellInfo] = [tblCellInfo.ini]
    let settings: [String] = ["Update Name", "Update Profile Image", "Change Password", "Change Email", "Log Out"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func logOutAlert(){
        let alert = UIAlertController(title: "Logout", message: "Are you sure you would like to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            do{
                if let vc = self.navigationController?.viewControllers.filter({$0 is CheckAuthVC}).first as? CheckAuthVC{
                    vc.userLoggedOut = true
                }
                self.navigationController?.popToRootViewController(animated: true)
                try Auth.auth().signOut()
            } catch {
                print("error signing out")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
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
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            if cell.lbl.text! == "Update Name"{
                if let vc = storyboard.instantiateViewController(withIdentifier: "Update Name") as? UpdateNameVC{
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            if cell.lbl.text! == "Update Profile Image"{
                if let vc = storyboard.instantiateViewController(withIdentifier: "Update Profile Image") as? UpdateProfileVC{
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
