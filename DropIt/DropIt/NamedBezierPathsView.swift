//
//  NamedBezierPathsView.swift
//  DropIt
//
//  Created by 王傲云 on 16/8/3.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class NamedBezierPathsView: UIView {

    var bezierPaths = [String:UIBezierPath]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        for (_, path) in bezierPaths {
            path.stroke()
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
