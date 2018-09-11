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
        
        getData(lastDoc: nil) {
        }
        
        setUpPullTableLoader()
        setUpUI()
        print("my nav ", self.navigationController)
        self.tabBarController?.tabBar.hero.isEnabled = true
        self.tabBarController?.tabBar.layer.removeAllAnimations()
        self.hero.isEnabled = true
        self.navigationController?.hero.isEnabled = true



    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Landing VC2")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Landing VC3")

    }

    func setUpUI(){
     //   viewTop.backgroundColor = UIColor().primaryColor
    }
    var allItemsLoaded = false;
    var itemsReloaded = true;
    typealias Completion = () -> Void
    func getData(lastDoc: DocumentSnapshot?, onComplete: @escaping Completion){
        
        guard !allItemsLoaded else{
            print("getDataGuard1")
            return
        }
        print("getDataGuard2")
        GetData.instance.retrieve(collection: DataService.instance.bucketListRef, lastDoc: lastDoc) { (snapshots, lastDoc) in
            
            if self.itemsReloaded{
                self.bucketItems = []
                self.itemsReloaded = false
            }
            
            self.lastDoc = lastDoc
            if snapshots.documents.count == 0{
                self.allItemsLoaded = true
            }
            
            for item in snapshots.documents{
                let bucketItem = BucketItem(dict: item.data())
                self.bucketItems.append(bucketItem)
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
            self?.allItemsLoaded = false
            self?.itemsReloaded = true
            self?.getData(lastDoc: nil, onComplete: {
                self?.table.dg_stopLoading()
            })
        }, loadingView: loadingView)
        table.dg_stopLoading()
        table.dg_setPullToRefreshFillColor(UIColor().primaryColor)
        table.dg_setPullToRefreshBackgroundColor(UIColor().rgb(red: 246, green: 246, blue: 246, alpha: 1))
    }
    


}

extension LandingVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //creates top inset since cellInsets did not work.
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell0") as? UITableViewCell{
                cell.selectionStyle = .none

                return cell
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BucketListCell{
            cell.configure(item: bucketItems[indexPath.row - 1])
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bucketItems.count + 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "BucketDetails") as?
            BucketDetails{
            print("indexPath.row", indexPath.row)
            vc.bucketItem = bucketItems[indexPath.row - 1]
            self.navigationController?.hero.navigationAnimationType = .cover(direction: .up)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == bucketItems.count - 1{
            print("will display last cell")
            getData(lastDoc: lastDoc) {
            }
        }
    }
 

}
