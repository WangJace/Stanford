//
//  DropItViewController.swift
//  DropIt
//
//  Created by 王傲云 on 16/8/3.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController
{

    @IBOutlet weak var gameView: DropItView! {
        didSet {
            gameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addDrop(_:))))
            gameView.addGestureRecognizer(UIPanGestureRecognizer(target: gameView, action: #selector(DropItView.grabDrop(_:))))
            gameView.realGravity = true
        }
    }
    
    func addDrop(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            gameView.addDrop()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        gameView.animating = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        gameView.animating = false
    }
}
