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
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var lblFilter: UILabel!
    @IBOutlet weak var btnFilter: UIButton!
    
    var bucketItems = [BucketItem]()
    var lastDoc: DocumentSnapshot?
    var hasDisplayedIndexPath: [Int] = [Int]()
    
    @IBAction func filterViewBtn(_ sender: AnyObject){
        
    }
    
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
        
        self.tabBarController?.tabBar.hero.isEnabled = true
        self.tabBarController?.tabBar.layer.removeAllAnimations()
//        self.hero.isEnabled = true
//        self.navigationController?.hero.isEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(LandingVC.newBucketItem), name: NSNotification.Name(rawValue: "newItem"), object: nil)
        
        getData(lastDoc: nil) {
        }
    }
    
    @IBAction func filterBtnTapped(_ sender: AnyObject){
        sortTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        viewFilter.backgroundColor = UIColor().mediumLightGrey//.primaryColor
        lblFilter.textColor = UIColor.black
        lblFilter.alpha = 0.54
        if let str = QueryService.instance.allQueryStr, str != ""{
            lblFilter.text = "Filtering - \(str)"
            viewFilter.isHidden = false
            setUpPullTableLoader(backgroundColor: UIColor().mediumLightGrey, spinnerColor: UIColor.gray)
        } else{
            setUpPullTableLoader(backgroundColor: UIColor().primaryColor, spinnerColor: UIColor.white)
            viewFilter.isHidden = true
        }
        
        let sortBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "sort"), style: .plain, target: self, action: #selector(LandingVC.sortTapped))
        navigationItem.rightBarButtonItems = [sortBtn]
        
        
//        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
//
//        if QueryService.instance.hasQuery{
//            lbl.text = "Query found no results."
//        } else{
//            lbl.text = "Query found no results."
//        }
//        lbl.alpha = 0.54
//        lbl.font = UIFont(name: "Arial", size: 25)
//        lbl.textAlignment = .center
//        lbl.numberOfLines = 0
//        tableView.backgroundView = lbl
    }
    
    @objc func newBucketItem(){
        lastDoc = nil
        allItemsLoaded = false
        itemsReloaded = true
        bucketItems = []
        getData(lastDoc: nil) {
        }
    }

    @objc func sortTapped(){
        performSegue(withIdentifier: "QueryVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QueryVC"{
            if let vc = segue.destination as? QueryVC{
                vc.delegate = self
            }
        }
    }
    
    var allItemsLoaded = false;
    var itemsReloaded = true;
    var noResultsFound = false
    var isLoading = false
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
        
        if let statusFilter = QueryService.instance.statusFilter{
            query = query.whereField("status", isEqualTo: statusFilter)
        }
        if let categoryFilter = QueryService.instance.categoryIsFilter{
            query = query.whereField(categoryFilter, isEqualTo: true)
        }
        if let priceFilter = QueryService.instance.priceFilter{
            query = query.whereField("price", isEqualTo: priceFilter)
        }
        if let timeFilter = QueryService.instance.timeFilter{
            query = query.whereField("completionTime", isEqualTo: timeFilter)
        }
        
        
        
        query = query.order(by: "created", descending: true)
        if let doc = lastDoc{
            query = query.start(afterDocument: doc)
        }
        print("calling Get data")
        shouldShowLoadingView()
        
        isLoading = true
        GetData.instance.retrieve(query: query)
        { (snapshots, lastDoc) in
            print("getDataGuard3, ", snapshots)
            self.isLoading = false
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
                print("nada found")
                self.noResultsFound = true
                self.allItemsLoaded = true
                self.showNoDocumentsLoaded()
            } else{
                self.noResultsFound = false
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
    
    var spinner: UIActivityIndicatorView!
    func shouldShowLoadingView(){
        if bucketItems.isEmpty{
            spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            spinner.alpha = 0
            spinner.center = table.center
            table.backgroundView = spinner
            
            UIView.animate(withDuration: 0.1) {
                self.spinner.alpha = 1
            }
        }
    }
    
    func showNoDocumentsLoaded(){
        if spinner != nil{
            UIView.animate(withDuration: 0.3, animations: {
                self.spinner.alpha = 0
            }) { (success) in
                self.spinner.removeFromSuperview()
                let noDataView = TableNoDataView(frame: CGRect(x: 0, y: 0, width: self.table.frame.width, height: self.table.frame.height))
                noDataView.delegate = self
                
                if QueryService.instance.hasQuery{
                    noDataView.lbl.text = "No Items Found"
                    noDataView.btn.setTitleWithoutAnimation(title: "Change Filter")
                } else{
                    noDataView.lbl.text = "No Items Found"
                    noDataView.btn.setTitleWithoutAnimation(title: "Create First Bucket Item")
                }
                
                
                self.table.backgroundView = noDataView
                noDataView.alpha = 0
                
                UIView.animate(withDuration: 0.3, animations: {
                    noDataView.alpha = 1
                }, completion: { (success) in
                    
                })

                
            }
        }
    }
    
    func setUpPullTableLoader(backgroundColor: UIColor, spinnerColor: UIColor){
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = spinnerColor
        
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
        table.dg_setPullToRefreshFillColor(backgroundColor)
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
        var numberOfSections = 1
        if bucketItems.count == 0 && isLoading == false && noResultsFound == true{
            numberOfSections = 0
        } else{
            tableView.backgroundView = nil
        }
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "BucketDetails") as?
            BucketDetails{
            vc.bucketItem = bucketItems[indexPath.row - 1]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.alpha = 0
//
//        print("willDisplay", indexPath.row)
//        print("hasDisplayedIP", hasDisplayedIndexPath)
//        if !hasDisplayedIndexPath.contains(indexPath.row){
//            print("willDisplay2", indexPath.row)
//            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
//                cell.alpha = 1
//            }) { (success) in
//            }
//            hasDisplayedIndexPath.append(indexPath.row)
//        }
//    }
}

extension LandingVC: QueryVCDelegate{
    func searchBtnPress(){
        itemsReloaded = true
        allItemsLoaded = false
        bucketItems = []
        table.reloadData()
        getData(lastDoc: nil) {

        }
    }
}

extension LandingVC: TableNoDataViewDelegate{
    func noDataBtnPress(){
        if QueryService.instance.hasQuery{
            sortTapped()
        } else{
            self.tabBarController?.selectedIndex = 1
        }
    }
}


class BtnTouchDarker: UIButton{
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor().mediumLessLightGrey : UIColor().mediumLightGrey
        }
    }
}









