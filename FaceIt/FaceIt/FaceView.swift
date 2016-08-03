//
//  FaceView.swift
//  FaceIt
//
//  Created by 王傲云 on 16/6/23.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

@IBDesignable

class FaceView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet { self.setNeedsDisplay() } }
    @IBInspectable
    var mouthCurvature: Double = 0.0 { didSet { self.setNeedsDisplay() } }
    @IBInspectable
    var eyesOpen: Bool = false { didSet { leftEye.eyeOpen = eyesOpen; rightEye.eyeOpen = eyesOpen } }
    @IBInspectable
    var eyeBrowTilt: Double = 0.5 { didSet { self.setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blueColor() { didSet { self.setNeedsDisplay(); leftEye.color = color; rightEye.color = color } }
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet { self.setNeedsDisplay(); leftEye.lineWidth = lineWidth; rightEye.lineWidth = lineWidth } }
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Changed,.Ended:
            scale *= recognizer.scale;
            recognizer.scale = 1;
        default:
            break;
        }
    }
    
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height)/2 * scale
    }
    
    private var skullCenter: CGPoint {
        return CGPointMake(bounds.midX, bounds.midY)
    }
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 5
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, widthRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint
    {
        let eyeOffset = skullRadius/Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left:
            eyeCenter.x -= eyeOffset
        case .Right:
            eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private lazy var leftEye: EyeView = self.createEye()
    private lazy var rightEye: EyeView = self.createEye()
    
    private func createEye() -> EyeView {
        let eye = EyeView()
        eye.opaque = false
        eye.color = color
        eye.lineWidth = lineWidth
        self.addSubview(eye)
        return eye
    }
    
    private func positionEye(eye: EyeView, center: CGPoint) {
        let size = skullRadius / Ratios.SkullRadiusToEyeRadius * 2
        eye.frame = CGRect(origin: CGPointZero, size: CGSize(width: size, height: size))
        eye.center = center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        positionEye(leftEye, center: getEyeCenter(.Left))
        positionEye(rightEye, center: getEyeCenter(.Right))
    }
    
//    private func pathForEye(eye: Eye) -> UIBezierPath
//    {
//        let eyeRadius = skullRadius/Ratios.SkullRadiusToEyeRadius
//        let eyeCenter = getEyeCenter(eye)
//        if eyesOpen {
//            return pathForCircleCenteredAtPoint(eyeCenter, widthRadius: eyeRadius)
//        }
//        else {
//            let path = UIBezierPath()
//            path.moveToPoint(CGPoint(x: eyeCenter.x-eyeRadius, y: eyeCenter.y))
//            path.addLineToPoint(CGPoint(x: eyeCenter.x+eyeRadius, y: eyeCenter.y))
//            path.lineWidth = lineWidth
//            return path
//        }
//    }
    
    static let SkullRadiusToBrowOffset: CGFloat = 5
    
    private func pathForBrow(eye: Eye) -> UIBezierPath
    {
        var tilt = eyeBrowTilt
        switch eye {
        case .Left: tilt *= -1.0
        case .Right: break
        }
        var browCenter = getEyeCenter(eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius/2
        let browStart = CGPoint(x: browCenter.x-eyeRadius, y: browCenter.y-tiltOffset)
        let browEnd = CGPoint(x: browCenter.x+eyeRadius, y: browCenter.y+tiltOffset)
        let path = UIBezierPath()
        path.moveToPoint(browStart)
        path.addLineToPoint(browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForMouth() -> UIBezierPath
    {
        let mouthWidth = skullRadius/Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius/Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius/Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRectMake(skullCenter.x-mouthWidth/2, skullCenter.y+mouthOffset, mouthWidth, mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPointMake(mouthRect.minX, mouthRect.minY)
        let end = CGPointMake(mouthRect.maxX, mouthRect.minY)
        let cp1 = CGPointMake(mouthRect.minX+mouthRect.width/3, mouthRect.minY+smileOffset)
        let cp2 = CGPointMake(mouthRect.maxX-mouthRect.width/3, mouthRect.minY+smileOffset)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    override func drawRect(rect: CGRect) {
        color.set()
        pathForCircleCenteredAtPoint(skullCenter, widthRadius: skullRadius).stroke()
//        pathForEye(.Left).stroke()
//        pathForEye(.Right).stroke()
        pathForMouth().stroke()
        pathForBrow(.Left).stroke()
        pathForBrow(.Right).stroke()
    }
}
