//
//  LandingVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/6/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import Firebase


class LandingVC: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var bucketItems = [BucketItem]()
    var lastDoc: DocumentSnapshot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 150
        
        
        CurrentUser.instance.getCurrentUserData { (success) in
        }
        
        GetData.instance.retrieve(collection: DataService.instance.bucketListRef, lastDoc: lastDoc) { (items, lastDoc) in
            self.lastDoc = lastDoc
            for item in items{
                if let dict = item as? Dictionary<String, AnyObject>{
                    let bucketItem = BucketItem(dict: dict)
                    self.bucketItems.append(bucketItem)
                }
            }
            self.table.reloadData()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("LandingVC viewWillAppear")
    }
    


}

extension LandingVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BucketListCell{
            cell.configure(item: bucketItems[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bucketItems.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
