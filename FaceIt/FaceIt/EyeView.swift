//
//  EyeView.swift
//  FaceIt
//
//  Created by 王傲云 on 16/8/2.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class EyeView: UIView {
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    var _eyeOpen: Bool = true { didSet { setNeedsDisplay() } }
    var eyeOpen: Bool {
        get {
            return _eyeOpen
        }
        set {
            UIView.transitionWithView(
                self,
                duration: 0.2,
                options: [.TransitionFlipFromTop, .CurveLinear],
                animations: { 
                    self._eyeOpen = newValue
                },
                completion: nil)
            _eyeOpen = newValue
        }
    }
    
    override func drawRect(rect: CGRect) {
        var path: UIBezierPath!
        
        if eyeOpen {
            path = UIBezierPath(ovalInRect: bounds.insetBy(dx: lineWidth/2, dy: lineWidth/2))
        } else {
            path = UIBezierPath()
            path.moveToPoint(CGPoint(x: bounds.minX, y: bounds.midY))
            path.addLineToPoint(CGPoint(x: bounds.maxX, y: bounds.midY))
        }
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }
}
