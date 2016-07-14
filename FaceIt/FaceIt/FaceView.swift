//
//  FaceView.swift
//  FaceIt
//
//  Created by 王傲云 on 16/6/23.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    var scale: CGFloat = 0.90
    
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
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, widthRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: false)
        path.lineWidth = 5.0
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
    
    private func pathForEye(eye: Eye) -> UIBezierPath
    {
        let eyeRadius = skullRadius/Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye)
        return pathForCircleCenteredAtPoint(eyeCenter, widthRadius: eyeRadius)
    }
    
    private func pathForMouth() -> UIBezierPath
    {
        let mouthWidth = skullRadius/Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius/Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius/Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRectMake(skullCenter.x-mouthWidth/2, skullCenter.y+mouthOffset, mouthWidth, mouthHeight)
        
        let mouthCurvature: Double = 0.0 //1 full smile, -1 full frown
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPointMake(mouthRect.minX, mouthRect.minY)
        let end = CGPointMake(mouthRect.maxX, mouthRect.minY)
        let cp1 = CGPointMake(mouthRect.minX+mouthRect.width/3, mouthRect.minY+smileOffset)
        let cp2 = CGPointMake(mouthRect.maxX-mouthRect.width/3, mouthRect.minY+smileOffset)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 5.0
        return path
    }
    
    override func drawRect(rect: CGRect) {
        UIColor.blueColor().set()
        pathForCircleCenteredAtPoint(skullCenter, widthRadius: skullRadius).stroke()
        pathForEye(.Left).stroke()
        pathForEye(.Right).stroke()
        pathForMouth().stroke()
    }
}
