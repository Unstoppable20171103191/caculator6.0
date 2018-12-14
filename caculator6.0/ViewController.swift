//
//  ViewController.swift
//  caculator6.0
//
//  Created by s20171103191 on 2018/12/14.
//  Copyright © 2018 s20171103191. All rights reserved.
//
import Foundation
class CaculatorBrain
{
    private enum Op{
        case Operand(Double)
        case UnaryOperation(String,(Double)-> Double)
        case BinaryOperation(String,(Double,Double) ->Double)
        
        var desciption: String{
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    private var opStack = [Op]()
    
    private var knownOps = [String :Op]()
    
    init(){
        knownOps["x"] = Op.BinaryOperation("x", *)
        knownOps["➗"] = Op.BinaryOperation("➗"){ $1 / $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["-"] = Op.BinaryOperation("-"){ $1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    private func evaluate(op: [Op]) ->(result: Double?,remainingOps: [Op])
    {
        if !op.isEmpty{
            var remainingOps = op
            let op = remainingOps.removeLast()
            
            switch op{
            case.Operand(let operand):
                return (operand,remainingOps)
            case.UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(op: remainingOps)
                
                if let operand = operandEvaluation.result{
                    return (operation(operand),operandEvaluation.remainingOps)
                    
                }
            case .BinaryOperation(_, let operation):
                let op1Evalution = evaluate(op: remainingOps)
                if let operand1 = op1Evalution.result{
                    let op2Evalution = evaluate(op: remainingOps)
                    if let operand2 = op2Evalution.result{
                        return (operation(operand1,operand2),op2Evalution.remainingOps)
                    }
                    
                    
                }
                
            }
            
        }
        return (nil,op)
    }
    func evaluate() -> Double? {
        let (result,_) = evaluate(op:opStack)
        print("\(opStack) = \(String(describing: result)) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand:Double) ->Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol:String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UITextField!
    var brain = CaculatorBrain()
    var userIsInTheMiddleOfTypingANumber:Bool = false
    @IBAction func appendDigit(_ sender: UIButton) {
        let digit = sender.currentTitle
        if userIsInTheMiddleOfTypingANumber{
            display.text = display.text! + digit!
        }else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
        print("digit = \(String(describing: digit))")
    }
    @IBAction func operate(_ sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter((Any).self)
            
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(symbol: operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }

    }
    @IBAction func enter(_ sender: Any) {
        var operandStack: Array<Double> = Array<Double>()
        _ = Array<Double>()
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        if let result = brain.pushOperand(operand: displayValue){
            displayValue = result
        }else {
            displayValue = 0
        }
    }
    var displayValue:Double{
        get {
            return NumberFormatter().number(from: display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

