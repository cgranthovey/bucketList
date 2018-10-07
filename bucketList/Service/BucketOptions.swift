//
//  BucketOptions.swift
//  bucketList
//
//  Created by Christopher Hovey on 10/6/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import Foundation

class BucketOptions{
    private static var _instance = BucketOptions()
    static var instance: BucketOptions{
        return _instance
    }
    
    //Category
    let categoryOption1 = txtImg.init(txt: "Travel", img: #imageLiteral(resourceName: "cat-airplane"))
    let categoryOption2 = txtImg.init(txt: "Nature", img: #imageLiteral(resourceName: "cat-tree"))
    let categoryOption3 = txtImg.init(txt: "Education", img: #imageLiteral(resourceName: "cat-books"))
    let categoryOption4 = txtImg.init(txt: "Sports", img: #imageLiteral(resourceName: "cat-soccer"))
    let categoryOption5 = txtImg.init(txt: "Social", img: #imageLiteral(resourceName: "cat-social"))
    let categoryOption6 = txtImg.init(txt: "Religion", img: #imageLiteral(resourceName: "cat-religious"))
    let categoryOption7 = txtImg.init(txt: "Exercise", img: #imageLiteral(resourceName: "cat-exercise"))
    let categoryOption8 = txtImg.init(txt: "Art", img: #imageLiteral(resourceName: "cat-art"))
    let categoryOption9 = txtImg.init(txt: "History", img: #imageLiteral(resourceName: "cat-history"))
    
    lazy var allCategories = {
        return [categoryOption1, categoryOption2, categoryOption3, categoryOption4, categoryOption5, categoryOption6, categoryOption7, categoryOption8, categoryOption9]
    }()
    
    //Price
    let priceFree = txtImg.init(txt: "Free", img: #imageLiteral(resourceName: "free"))
    let price2 = txtImg.init(txt: "< $15", img: #imageLiteral(resourceName: "coin"))
    let price3 = txtImg.init(txt: "< $50", img: #imageLiteral(resourceName: "coins"))
    let price4 = txtImg.init(txt: "< $100", img: #imageLiteral(resourceName: "notes"))
    let price5 = txtImg.init(txt: "< $500", img: #imageLiteral(resourceName: "notesBundle"))
    let price6 = txtImg.init(txt: "$500+", img: #imageLiteral(resourceName: "rich"))
    
    lazy var allPrices = {
        return [priceFree, price2, price3, price4, price5, price6]
    }()
    
    //Time
    lazy var allTimes = {
        return ["30 minutes", "2 Hours", "4 Hours", "Full Day", "Multiday", "Ongoing"]
    }()
    
    //Status
    let statusToDo = Status.init(status: .toDo, color: UIColor().darkerBlue)
    let statusInProgress = Status.init(status: .inProgress, color: UIColor().primaryColor)
    let statusComplete = Status.init(status: .complete, color: UIColor().primaryGreen)
    
    lazy var allStatuses = {
        return [statusToDo, statusInProgress, statusComplete]
    }()
    
    
    //All Types
    
}
