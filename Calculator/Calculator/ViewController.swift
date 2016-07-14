//
//  ViewController.swift
//  Calculator
//
//  Created by 王傲云 on 16/6/4.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping:Bool = false
    
    @IBAction func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentInDisplay = display.text!
            display.text = textCurrentInDisplay + digit
        }
        else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        print("touched \(digit) digit")
    }
    
    var  displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    var saveProgram: CalculatorBrain.PropertyList?
    @IBAction func save(sender: UIButton) {
        saveProgram = brain.program
    }
    
    @IBAction func restore(sender: UIButton) {
        if saveProgram != nil {
            brain.program = saveProgram!
            displayValue = brain.result
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicaSymbol = sender.currentTitle {
            #if false
            if mathematicaSymbol == "π" {
//                display.text = String(M_PI)
                displayValue = M_PI
            }
            else if mathematicaSymbol == "√" {
                displayValue = sqrt(displayValue)
            }
            #endif
            brain.performOperation(mathematicaSymbol)
        }
        displayValue = brain.result
    }

}

