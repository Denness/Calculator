//
//  ViewController.swift
//  Calculator
//
//  Created by Mac on 18/02/2016.
//  Copyright © 2016 Denness. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userIsInTheMiddleOfTypingANumber: Bool = false

    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var display: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if (display.text!.rangeOfString(".") == nil) || ((digit.rangeOfString(".") == nil) && (display.text!.rangeOfString(".") != nil)  ){
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + digit
            }
            else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
            }
        }
    }
    
    @IBAction func clear() {
        displayValue = 0
        history.text = "0"
        operandStack.removeAll()
    }
    
    @IBAction func back() {
        if display.text!.characters.count >= 2 {
            display.text! = String(display.text!.characters.dropLast())
        }
        else {
            display.text! = "0"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func plusMinus() {
        if (display.text!.hasPrefix("−")) {
            display.text! = String(display.text!.characters.dropFirst())
        }
        else {
            display.text! = "−" + display.text!
        }
    }
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        history.text = history.text! + operation + " "
        switch operation {
        case "÷": performOperation { $1 / $0 }
        case "×": performOperation { $0 * $1 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "tan": performOperation { tan($0) }
        case "log": performOperation { log($0) }
        case "π": performOperation { $0 * M_PI }
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    @nonobjc
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        if history.text == "0" {
            history.text = display.text! + " "
        }
        else {
        history.text = history.text! + display.text! + " "
        }
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return (NSNumberFormatter().numberFromString(display.text!)!.doubleValue)
        }
        set {
            display.text = "\(newValue)"
            
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

