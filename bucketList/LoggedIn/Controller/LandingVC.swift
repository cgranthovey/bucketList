//
//  LandingVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/6/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import Firebase
import DGElasticPullToRefresh
import FirebaseFirestore


class LandingVC: UIViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var viewTop: UIView!
    
    var bucketItems = [BucketItem]()
    var lastDoc: DocumentSnapshot?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 150
        
        
        table.contentInset = UIEdgeInsets(top: 0
            , left: 0, bottom: 75, right: 0)
        
        
        CurrentUser.instance.getCurrentUserData { (success) in
            
        }
        
        getData {
        }
        
        setUpPullTableLoader()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }

    func setUpUI(){
     //   viewTop.backgroundColor = UIColor().primaryColor
    }
    
    typealias Completion = () -> Void
    func getData(onComplete: @escaping Completion){
        
        print("get data doc \(lastDoc)")
        GetData.instance.retrieve(collection: DataService.instance.bucketListRef, lastDoc: lastDoc) { (items, lastDoc) in
            self.lastDoc = lastDoc
            self.bucketItems = []
            for item in items{
                if let dict = item as? Dictionary<String, AnyObject>{
                    let bucketItem = BucketItem(dict: dict)
                    self.bucketItems.append(bucketItem)
                }
            }
            self.table.reloadData()
            onComplete()
        }
    }
    
    func setUpPullTableLoader(){
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white

        table.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self?.lastDoc = nil

            self?.getData {
                self?.table.dg_stopLoading()
            }
            
        }, loadingView: loadingView)
        table.dg_stopLoading()
        table.dg_setPullToRefreshFillColor(UIColor().primaryColor)
        table.dg_setPullToRefreshBackgroundColor(UIColor().rgb(red: 246, green: 246, blue: 246, alpha: 1))
    }
    


}

extension LandingVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell0") as? UITableViewCell{
                cell.selectionStyle = .none

                return cell
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BucketListCell{
            cell.configure(item: bucketItems[indexPath.row])
            cell.selectionStyle = .none
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        print("did select at", indexPath.row)
        if let vc = storyboard.instantiateViewController(withIdentifier: "BucketDetails") as?
            BucketDetails{
            print("did select at 2", indexPath.row)
            vc.bucketItem = bucketItems[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0{
//            return 1
//        }
//        return
//    }    

}
