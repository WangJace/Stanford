//
//  BlinkingFaceViewController.swift
//  FaceIt
//
//  Created by 王傲云 on 16/8/2.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class BlinkingFaceViewController: FaceViewController {
    var blinking: Bool = false {
        didSet {
            startBlink()
        }
    }
    
    private struct BlinkRate {
        static let CloseDuration = 0.4
        static let openDuration = 2.5
    }
    
    func startBlink() {
        if blinking {
            faceView.eyesOpen = false
            NSTimer.scheduledTimerWithTimeInterval(
                BlinkRate.CloseDuration,
                target: self,
                selector: #selector(BlinkingFaceViewController.endBlink),
                userInfo: nil,
                repeats: false)
        }
    }
    
    func endBlink() {
        faceView.eyesOpen = true
        NSTimer.scheduledTimerWithTimeInterval(
            BlinkRate.openDuration,
            target: self,
            selector: #selector(BlinkingFaceViewController.startBlink),
            userInfo: nil,
            repeats: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        blinking = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        blinking = false
    }
}
