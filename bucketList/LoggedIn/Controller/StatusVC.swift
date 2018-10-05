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
    
    var statuses = [ItemStatus.toDo, ItemStatus.inProgress, ItemStatus.completed]
    var delegate: StatusVCDelegate!

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
            cell.configure(text: statuses[indexPath.row].rawValue)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectStatus(status: statuses[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}









