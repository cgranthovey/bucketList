//
//  SettingsTVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 8/5/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsTVC: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        
//        self.navigationController?.navigationBar.tit
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 3
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UITableViewCell{
            if let reuseId = cell.reuseIdentifier{
                if reuseId == "logOut"{
                    logOutAlert()
                }
            }
        }
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
