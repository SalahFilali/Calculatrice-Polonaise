//
//  CalculatorButton.swift
//  CalculatricePolonaise
//
//  Created by Salah Filali on 1/2/2023.
//

import Foundation
import SwiftUI

enum CalculatorButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case mutliply = "x"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case factorial = "!"
    case power = "^"

    var buttonColor: Color {
        switch self {
        case .add, .subtract, .mutliply, .divide, .equal:
            return .orange
        case .clear, .power, .factorial:
            return Color(.lightGray)
        default:
            return Color(.darkGray)
        }
    }
   
}
