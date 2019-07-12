//
//  Calculation.swift
//  calculator
//
//  Created by Venigalla, Sai on 12/07/19.
//  Copyright © 2019 Random Inc. All rights reserved.
//

import Foundation

protocol Calculation {
    var previousExpressions: [(expression: String, result: String)] { get set }
    var currentOperator: Operator? { get set }
    
    var leftNumber: Double? { get set }
    var rightNumber: Double? { get set }
    var resultNumber: Double { get }
    
    var expressionString: String { get }
    
    func handleInput(_ number: Int)
    func setOperator(_ newOperator: Operator)
    func clearInputAndSave(_ save: Bool)
}

protocol Operator {
    var character: String { get }
    var operate: (Double, Double) -> Double { get }
    init (forCharacter character: String, withFunction: @escaping (Double, Double) -> Double)
}

class DefaultCalculationDelegate : Calculation {
    
    var previousExpressions: [(expression: String, result: String)] = []
    var currentOperator: Operator?
    
    var leftNumber: Double?
    var rightNumber: Double?
    var resultNumber: Double {
        if let leftNumber = leftNumber {
            return rightNumber ?? leftNumber
        }
        return leftNumber ?? Double(previousExpressions.last?.result ?? "a") ?? 0.0
    }
    
    var expressionString: String {
        if let left = leftNumber?.roundedString {
            if let operatorChar = currentOperator?.character {
                let right = rightNumber?.roundedString ?? "0"
                return "\(left) \(operatorChar) \(right) = "
            }
            return "\(left) = "
        }
        return "0 = "
    }
    
    func handleInput(_ input: Int) {
        
        if expressionString == "" {
            leftNumber = nil
        }
        
        let useLeft = (currentOperator == nil)
        
        let optionalNumber = useLeft ? leftNumber : rightNumber
        var newNumber = optionalNumber ?? 0.0
        newNumber = (newNumber * 10) + Double(input)
        
        if useLeft { leftNumber = newNumber }
        else { rightNumber = newNumber }
    }
    
    func setOperator(_ newOperator: Operator) {
        if leftNumber == nil {
            leftNumber = Double(previousExpressions.last?.result ?? "a") ?? 0.0
        }
        
        if rightNumber != nil {
            clearInputAndSave(true)
            leftNumber = resultNumber
        }
        
        currentOperator = newOperator
    }
    
    func clearInputAndSave(_ save: Bool) {
        
        if !save {
            previousExpressions.append((expression: "cleared", result: ""))
        }
        
        let result = currentOperator?.operate(leftNumber ?? 0.0, rightNumber ?? 0.0)
        
        if leftNumber != nil || rightNumber != nil || currentOperator != nil {
            if let result = result {
                previousExpressions.append((expression: expressionString, result: "\(result)"))
            }
        }
        
        leftNumber = nil
        rightNumber = nil
        currentOperator = nil
    }
    
}

struct DefaultOperator : Operator {
    
    var character: String
    var operate: (Double, Double) -> Double
    
    init(forCharacter character: String, withFunction operate: @escaping (Double, Double) -> Double) {
        self.character = character
        self.operate = operate
    }
    
}


extension Double {
    
    var roundedString: String {
        let rounded = (self * 100).rounded() / 100
        let string = "\(rounded)"
        return string.hasSuffix(".0") ? "\(Int(self))" : string
    }
    
}
