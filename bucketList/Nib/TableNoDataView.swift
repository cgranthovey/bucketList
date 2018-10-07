//
//  TableNoDataView.swift
//  bucketList
//
//  Created by Christopher Hovey on 10/7/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

protocol TableNoDataViewDelegate{
    func noDataBtnPress()
}

class TableNoDataView: UIView {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var delegate: TableNoDataViewDelegate!
    
    @IBAction func btnPress(_ sender: AnyObject){
        delegate.noDataBtnPress()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("TableNoDataView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}











