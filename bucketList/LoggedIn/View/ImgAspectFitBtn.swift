//
//  ImgAspectFitBtn.swift
//  bucketList
//
//  Created by Christopher Hovey on 9/5/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit

class ImgAspectFitBtn: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        imageView?.contentMode = .scaleAspectFit
    }

}
