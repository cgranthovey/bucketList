//
//  StatusVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 10/4/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

protocol StatusVCDelegate {
    func didSelectStatus(status: ItemStatus)
}

class StatusVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var statuses = [ItemStatus.toDo, ItemStatus.inProgress, ItemStatus.complete]
    var delegate: StatusVCDelegate!
    var bucketItem: BucketItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension StatusVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? StatusPopupCell{
            
            let selectedView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            selectedView.backgroundColor = UIColor().extraLightGrey
            
            let colorHeight: CGFloat = 4
            let colorInset: CGFloat = 0
            
            let colorSelectedView = UIView(frame: CGRect(x: colorInset, y: cell.frame.height - colorHeight + 2, width: cell.frame.width - colorInset, height: colorHeight))
            if statuses[indexPath.row] == .toDo{
                colorSelectedView.backgroundColor = UIColor().primaryBlue
            }
            if statuses[indexPath.row] == .inProgress{
                colorSelectedView.backgroundColor = UIColor().primaryColor
            }
            if statuses[indexPath.row] == .complete{
                colorSelectedView.backgroundColor = UIColor().primaryGreen
            }
            colorSelectedView.alpha = 0.5
            selectedView.addSubview(colorSelectedView)
            cell.selectedBackgroundView = selectedView
            
            cell.configure(text: statuses[indexPath.row].rawValue)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectStatus(status: statuses[indexPath.row])
        if let bucketID = bucketItem.id{
            DataService.instance.bucketListRef.document(bucketID).updateData(["status":statuses[indexPath.row].rawValue])
        }
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}









