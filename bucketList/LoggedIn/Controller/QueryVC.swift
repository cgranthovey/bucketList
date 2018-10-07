//
//  QueryVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 10/5/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

protocol QueryVCDelegate{
    func searchBtnPress()
}

class QueryVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var allQueryOptions: [(String, Any)] = {
        return [("status",BucketOptions.instance.allStatuses), ("category", BucketOptions.instance.allCategories), ("price", BucketOptions.instance.allPrices), ("time", BucketOptions.instance.allTimes)]
        //return [BucketOptions.instance.allStatuses, BucketOptions.instance.allCategories, BucketOptions.instance.allPrices, BucketOptions.instance.allTimes]
    }()
    
    var sideInset: CGFloat = 20
    var interitemSpacing: CGFloat = 5
    var delegate: QueryVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(20, sideInset, 40, sideInset)
        
        collectionView.allowsMultipleSelection = true
        setUpSelected()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func setUpSelected(){
        for (section, item) in allQueryOptions.enumerated(){
            if item.0 == "status", let queryStatus = QueryService.instance.statusFilter{
                if let statuses = item.1 as? [Status]{
                    for (itemIndex, status) in statuses.enumerated(){
                        if queryStatus == status.status.rawValue{
                            let indexPath = IndexPath(item: itemIndex + 1, section: section)
                            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                        }
                    }
                }
            }
            if item.0 == "category", let queryCategory = QueryService.instance.categoryStrFilter{
                if let categories = item.1 as? [txtImg]{
                    for (itemIndex, category) in categories.enumerated(){
                        if queryCategory == category.txt{
                            let indexPath = IndexPath(item: itemIndex + 1, section: section)
                            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                        }
                    }
                }
            }
            if item.0 == "price", let queryPrice = QueryService.instance.priceFilter{
                if let prices = item.1 as? [txtImg]{
                    for (itemIndex, price) in prices.enumerated(){
                        if queryPrice == price.txt{
                            let indexPath = IndexPath(item: itemIndex + 1, section: section)
                            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                        }
                    }
                }
            }
            if item.0 == "time", let queryTime = QueryService.instance.timeFilter{
                if let times = item.1 as? [String]{
                    for (itemIndex, time) in times.enumerated(){
                        if queryTime == time{
                            let indexPath = IndexPath(item: itemIndex + 1, section: section)
                            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                        }
                    }
                }
            }
        }
    }

    @IBAction func clearBtnPress(_ sender: AnyObject){
        QueryService.instance.clear()
        collectionView.reloadData()
        delegate.searchBtnPress()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchBtnPress(_ sender: AnyObject){
        delegate.searchBtnPress()
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension QueryVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("number of sections", allQueryOptions.count)
        return allQueryOptions.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("all query options", allQueryOptions[section])
        
        if let options = allQueryOptions[section] as? (String, Any){
            if options.0 == "status", let statuses = options.1 as? [Status]{
                return statuses.count + 1
            }
            if options.0 == "category", let categories = options.1 as? [txtImg]{
                return categories.count + 1
            }
            if options.0 == "price", let prices = options.1 as? [txtImg]{
                return prices.count + 1
            }
            if options.0 == "time", let times = options.1 as? [String]{
                return times.count + 1
            }
            
        }
        
//        if let options = allQueryOptions[section] as? [Status]{
//            return options.count + 1
//        }
//        if let options = allQueryOptions[section] as? [txtImg]{
//            return options.count + 1
//        }
//        if let options = allQueryOptions[section] as? [String]{
//            return options.count + 1
//        }
        return 0
    }
    
    func getSelectedView(cell: UICollectionViewCell)->UIView{
        let selectedView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        selectedView.backgroundColor = UIColor().primaryBlueAlpha
        
        selectedView.alpha = 0.1
        cell.isUserInteractionEnabled = true
        return selectedView
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellHeader", for: indexPath) as? QueryHeaderCell{
                switch indexPath.section{
                case 0: cell.lbl.text = "Filter Status"
                case 1: cell.lbl.text = "Filter Category"
                case 2: cell.lbl.text = "Filter Price"
                case 3: cell.lbl.text = "Filter Time"
                default: cell.lbl.text = ""
                }
                cell.isUserInteractionEnabled = false
                return cell
            }
        }
        
        if let options = allQueryOptions[indexPath.section].1 as? [Status]{
            let itemStatus = options[indexPath.row - 1]
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellText", for: indexPath)
                as? QueryTxtCell{
                cell.lbl.text = itemStatus.status.rawValue
                cell.selectedBackgroundView = getSelectedView(cell: cell)
                cell.backgroundColor = UIColor().extraLightGrey
                return cell
            }
        }
        if let options = allQueryOptions[indexPath.section].1 as? [txtImg]{
            let txtImg = options[indexPath.row - 1]
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellImage", for: indexPath) as? QueryImgCell{
                cell.img.image = txtImg.img
                cell.lbl.text = txtImg.txt
                cell.selectedBackgroundView = getSelectedView(cell: cell)
                cell.backgroundColor = UIColor().extraLightGrey
                return cell
            }
        }
        if let options = allQueryOptions[indexPath.section].1 as? [String]{
            let txt = options[indexPath.row - 1]
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellText", for: indexPath) as? QueryTxtCell{
                cell.lbl.text = txt
                cell.selectedBackgroundView = getSelectedView(cell: cell)
                cell.backgroundColor = UIColor().extraLightGrey
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func selectOnlyOneCellFor(indexPath: IndexPath, collectionView: UICollectionView){
        if let items = collectionView.indexPathsForSelectedItems{
            for item in items{
                if item.section == indexPath.section{
                    collectionView.deselectItem(at: item, animated: false)
                }
            }
        }
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = allQueryOptions[indexPath.section]
        let indexPathRowMinusHeader = indexPath.row - 1
        if let status = option.1 as? [Status], option.0 == "status"{
            QueryService.instance.statusFilter = status[indexPathRowMinusHeader].status.rawValue
        }
        if let category = option.1 as? [txtImg], option.0 == "category"{
            QueryService.instance.categoryStrFilter = category[indexPathRowMinusHeader].txt
        }
        if let price = option.1 as? [txtImg], option.0 == "price"{
            QueryService.instance.priceFilter = price[indexPathRowMinusHeader].txt
        }
        if let time = option.1 as? [String], option.0 == "time"{
            QueryService.instance.timeFilter = time[indexPathRowMinusHeader]
        }
        selectOnlyOneCellFor(indexPath: indexPath, collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let option = allQueryOptions[indexPath.section]
        if option.0 == "status"{
            QueryService.instance.statusFilter = nil
        }
        if option.0 == "category"{
            QueryService.instance.categoryStrFilter = nil
        }
        if option.0 == "price"{
            QueryService.instance.priceFilter = nil
        }
        if option.0 == "time"{
            QueryService.instance.timeFilter = nil
        }
    }
}

extension QueryVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellMaxWidth = collectionView.frame.width - sideInset * 2
        if indexPath.row == 0{
            return CGSize(width: cellMaxWidth, height: 40)
        }
        
        if indexPath.section == 0{
            let threeCellsPerRow = (cellMaxWidth - interitemSpacing * 2) / 3
            return CGSize(width: threeCellsPerRow, height: threeCellsPerRow / 2)
        }
        if indexPath.section == 1{
            let fiveCellsPerRow = (cellMaxWidth - interitemSpacing * 3) / 4
            return CGSize(width: fiveCellsPerRow, height: fiveCellsPerRow)
        }
        if indexPath.section == 2{
            let width = (cellMaxWidth - interitemSpacing * 3) / 4
            return CGSize(width: width, height: width)
        }
        if indexPath.section == 3{
            let width = (cellMaxWidth - interitemSpacing * 2) / 3
            return CGSize(width: width, height: width / 2)
        }
        return CGSize(width: 10, height: 10)
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 10, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}














