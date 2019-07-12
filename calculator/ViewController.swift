//
//  ViewController.swift
//  calculator
//
//  Created by Sai Yashwant on 11/07/19.
//  Copyright © 2019 Random Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let calculations: Calculation = DefaultCalculationDelegate()
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        setOperator("+", withFunction: +)
    }
    @IBAction func subtractButtonPressed(_ sender: UIButton) {
        setOperator("-", withFunction: -)
    }
    @IBAction func multiplyButtonPressed(_ sender: UIButton) {
        setOperator("*", withFunction: *)
    }
    @IBAction func divideButtonPressed(_ sender: UIButton) {
        setOperator("/", withFunction: /)
    }
    @IBAction func equalsButtonPressed(_ sender: UIButton) {
        calculations.clearInputAndSave(true)
        resultLabel.text = calculations.resultNumber.roundedString
    }
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        calculations.clearInputAndSave(false)
        resultLabel.text = calculations.resultNumber.roundedString
    }
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel!.text!
        let buttonNumber = Int(buttonTitle)!
        calculations.handleInput(buttonNumber)
        
        resultLabel.text = calculations.resultNumber.roundedString
    }
    
    func setOperator(_ character: String, withFunction function: @escaping (Double, Double) -> (Double)) {
        let customOperator = DefaultOperator(forCharacter: character, withFunction: function)
        calculations.setOperator(customOperator)
        
        resultLabel.text = calculations.resultNumber.roundedString
    }
}
