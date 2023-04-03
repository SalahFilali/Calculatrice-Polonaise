//
//  CalculatriceViewModel.swift
//  CalculatricePolonaise
//
//  Created by Salah Filali on 26/1/2023.
//

import Foundation
import Combine
import SwiftUI

class CalculatriceViewModel:ObservableObject {
    
    @Published var value = ""
    @Published var currentOperation: Operation = .none
    @Published var workingSpaceText = ""
    @Published var runningNumber = 0
    @Published var errorMessage: String = ""
    @Published var isShowingError = false
    
    func didTap(button: CalculatorButton) {
        switch button {
        case .add, .subtract, .mutliply, .divide, .decimal, .power:
            self.didTapOperatorButton(button)
        case .factorial:
            let currentValue = Int(self.value) ?? 0
            if let result = self.factorial(currentValue) {
                self.value = "\(result)"
                self.runningNumber = Int(self.value) ?? 0
                self.workingSpaceText = self.value
            }
        case .equal:
            self.didTapEqual()
        case .clear:
            self.clear()
        default:
            let number = button.rawValue
            self.workingSpaceText.append(number)
            if self.value == "0" {
                value = number
            }
            else {
                self.value = "\(self.value)\(number)"
            }
        }
    }
    
    func clear() {
        self.value = ""
        self.workingSpaceText = ""
        self.runningNumber = 0
    }
    
    internal func factorial(_ number: Int) -> Int? {
        if number == 0 {
            return 1
        } else {
            if number >= 20 || number <= -20{
                self.errorMessage = "Taille d'entier dépassé!"
                self.isShowingError = true
                return nil
            }
            return number * factorial(number - 1)!
        }
    }
    
    
    internal func didTapEqual() {
        let runningValue = self.runningNumber
        let currentValue = Int(self.value) ?? 0
        switch self.currentOperation {
        case .add:
            self.makeAddOperation(with: runningValue, to: currentValue)
        case .subtract:
            self.makeSubstractOperation(with: runningValue, from: currentValue)
        case .multiply:
            self.makeMultiplyOperation(with: runningValue, to: currentValue)
        case .divide:
            self.makeDivideOperation(runningValue, by: currentValue)
        case .power:
            self.makePowerOperation(base: runningValue, exponent: currentValue)
        case .none:
            break
        }
        self.currentOperation = .none
    }
    
    internal func makeAddOperation(with runningValue: Int, to currentValue: Int) {
        if self.currentOperation == .none && runningValue != 0 {
            self.value = "\(runningValue)"
        }else {
            let result = runningValue &+ currentValue
            if (runningValue > 0 && currentValue > 0 && result < 0) || (runningValue < 0 && currentValue < 0 && result > 0) {
                self.errorMessage = "Taille d'entier dépassé!"
                self.isShowingError = true
            }else {
                self.value = "\(result)"
            }
        }
        
    }
    
    internal func makeSubstractOperation(with runningValue: Int, from currentValue: Int) {
        if self.currentOperation == .none && runningValue != 0 {
            self.value = "\(runningValue)"
        }else {
            let (result, overflow) = currentValue.subtractingReportingOverflow(runningValue)
            if overflow {
                self.errorMessage = "Taille d'entier dépassé!"
            } else {
                self.value = "\(result)"
            }
        }
    }
    
    internal func makeMultiplyOperation(with runningValue: Int, to currentValue: Int) {
        if self.currentOperation == .none && runningValue != 0{
            self.value = "\(runningValue)"
        }else {
            let result = runningValue &* currentValue
            if (runningValue > 0 && currentValue > 0 && result < 0) || (runningValue < 0 && currentValue < 0 && result > 0) {
                self.errorMessage = "Taille d'entier dépassé!"
                self.isShowingError = true
            }else {
                self.value = "\(result)"
            }
        }
    }
    
    internal func makeDivideOperation(_ runningValue: Int, by currentValue: Int) {
        if self.currentOperation == .none && runningValue != 0{
            self.value = "\(runningValue)"
        }else {
            if currentValue == 0 {
                self.errorMessage = "Division par 0 impossible!"
                self.isShowingError = true
            }else {
                self.value = "\(Double(runningValue / currentValue))"
            }
        }
    }
    
    internal func power(_ base: Double, _ exponent: Int) -> Double? {
        if exponent == 0 {
            return 1
        } else if exponent > 0 {
            var result = 1.0
            for _ in 1...exponent {
                guard !result.isInfinite && !result.isNaN else {
                    return nil
                }
                result *= base
            }
            return result
        } else {
            return 1 / power(base, -exponent)!
        }
    }
    
    internal func makePowerOperation(base runningValue: Int, exponent currentValue: Int) {
        if self.currentOperation == .none && runningValue != 0{
            self.value = "\(runningValue)"
        }else {
            if let result = self.power(Double(runningValue), currentValue) {
                self.value = "\(result)"
                self.runningNumber = Int(self.value) ?? 0
                self.workingSpaceText = self.value
            }else {
                self.errorMessage = "Taille d'entier dépassé!"
                self.isShowingError = true
            }
        }
    }
    
    
    internal func lastWorkingSpaceTextIsAnOperator() -> Bool {
        if let lastChar = workingSpaceText.last {
            if lastChar == "+" || lastChar == "-" || lastChar == "÷" || lastChar == "x" || lastChar == "." || lastChar == "^"{
                return true
            }
        }
        return false
    }
    
    internal func numberAlreadyHaveADecimalOperator(_ number: String) -> Bool {
        var workingSpaceNumber = number
        while !workingSpaceNumber.isEmpty {
            if let lastChar = workingSpaceNumber.last {
                if lastChar == "+" || lastChar == "-" || lastChar == "÷" || lastChar == "x" || lastChar == "^"  {
                    return false
                }
                if lastChar == "." {
                    return true
                }
            }
            workingSpaceNumber.removeLast()
        }
        return false
    }
    
    internal func updateWorkingSpaceTextForButton(_ button: CalculatorButton) {
        if button == .decimal {
            self.updateWorkingSpaceTextForDecimalOperatorButton()
        }
        else {
            if lastWorkingSpaceTextIsAnOperator() {
                self.workingSpaceText.removeLast()
            }
            self.workingSpaceText.append(button.rawValue)
        }
    }
    
    internal func updateValueTextForButton(_ button: CalculatorButton) {
        if button == .decimal {
            self.updateValueTextForDecimalOperatorButton()
        }
        else{
            if value != "" {
                if let number = Int(self.value) {
                    self.runningNumber = number
                }
            }
            self.value = ""
        }
    }
    
    internal func updateWorkingSpaceTextForDecimalOperatorButton() {
        if !lastWorkingSpaceTextIsAnOperator() {
            if !self.numberAlreadyHaveADecimalOperator(workingSpaceText) {
                self.workingSpaceText.append(".")
            }
        }
    }
    
    internal func updateValueTextForDecimalOperatorButton() {
        if !lastWorkingSpaceTextIsAnOperator() {
            if value != "" {
                if let number = Int(self.value) {
                    self.runningNumber = number
                }
                if !self.numberAlreadyHaveADecimalOperator(value) {
                    value.append(".")
                }
            }
        }
    }
    
    internal func didTapOperatorButton(_ button: CalculatorButton) {
        switch button {
        case .add:
            self.currentOperation = .add
        case .subtract:
            self.currentOperation = .subtract
        case .mutliply:
            self.currentOperation = .multiply
        case .divide:
            self.currentOperation = .divide
        case .power:
            self.currentOperation = .power
        default:
            self.currentOperation = .none
        }
        updateValueTextForButton(button)
        updateWorkingSpaceTextForButton(button)
    }
    
}


