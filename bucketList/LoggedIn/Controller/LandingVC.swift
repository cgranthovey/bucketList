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
import FirebaseAuth


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
        
        setUpPullTableLoader()
        self.tabBarController?.tabBar.hero.isEnabled = true
        self.tabBarController?.tabBar.layer.removeAllAnimations()
//        self.hero.isEnabled = true
//        self.navigationController?.hero.isEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(LandingVC.newBucketItem), name: NSNotification.Name(rawValue: "newItem"), object: nil)
        
        getData(lastDoc: nil) {
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let rightBarBtn = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(LandingVC.toggleTableHeader))
//        self.navigationController?.navigationItem.rightBarButtonItems = [rightBarBtn]

//            let cameraBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "sort"), landscapeImagePhone: #imageLiteral(resourceName: "sort"), style: .plain, target: self, action: #selector(LandingVC.sortTapped))
//            navigationItem.rightBarButtonItems = [cameraBtn]

        
        let sortBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "sort"), style: .plain, target: self, action: #selector(LandingVC.sortTapped))
        navigationItem.rightBarButtonItems = [sortBtn]
    }
    
    
    
    @objc func newBucketItem(){
        lastDoc = nil
        allItemsLoaded = false
        itemsReloaded = true
        print("newBucketItem")
        bucketItems = []
        getData(lastDoc: nil) {
            
        }
        
    }

    @objc func sortTapped(){
        performSegue(withIdentifier: "QueryVC", sender: nil)
    }
    var allItemsLoaded = false;
    var itemsReloaded = true;
    typealias Completion = () -> Void
    func getData(lastDoc: DocumentSnapshot?, onComplete: @escaping Completion){
        
        guard !allItemsLoaded else{
            print("getDataGuard1")
            return
        }

        var query = DataService.instance.bucketListRef.limit(to: 7)
        if let user = Auth.auth().currentUser{
            query = query.whereField("userID", isEqualTo: user.uid)
        }
        query = query.order(by: "created", descending: true)
        if let doc = lastDoc{
            query = query.start(afterDocument: doc)
        }
        print("calling Get data")
        GetData.instance.retrieve(query: query)
        { (snapshots, lastDoc) in
            print("getDataGuard3, ", snapshots)
//            guard self.itemsReloaded else{
//                return
//            }
            if self.itemsReloaded{
                print("in items reloaded")
                self.bucketItems = []
                self.itemsReloaded = false
            }
            
            self.lastDoc = lastDoc
            if snapshots.documents.count == 0{
                self.allItemsLoaded = true
            }
            
            for item in snapshots.documents{
                var bucketItem: BucketItem = BucketItem(dict: item.data())
                print("bucketItemTitle -", bucketItem.title)
                bucketItem.id = item.documentID
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

    
//    @objc func toggleTableHeader(){
////        table.headerView(forSection: <#T##Int#>)
//        let header = table.tableHeaderView!//.headerView(forSection: 0)
//        print("the header", header)
//
//        if (header.frame.height) > CGFloat(0) {
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
//                header.transform = CGAffineTransform(scaleX: 0, y: 0)
//            }) { (success) in
//            }
//        } else{
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
//                header.transform = CGAffineTransform(scaleX: 1, y: 0)
//            }) { (success) in
//            }
//        }
//
//    }


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
            
//            let selectedView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
//            selectedView.backgroundColor = UIColor().rgb(red: 250, green: 250, blue: 250, alpha: 1)
//            cell.selectedBackgroundView = selectedView
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
//            self.navigationController?.hero.navigationAnimationType = .push(direction: .right)
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
 

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
//        view.backgroundColor = UIColor.brown
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
//        label.center = view.center
//        label.textColor = UIColor.white
//        label.text = "Is this right?"
//
//        view.addSubview(label)
//        return view
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }

}



















