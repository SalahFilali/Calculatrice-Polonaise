//
//  CalculatricePolonaiseTests.swift
//  CalculatricePolonaiseTests
//
//  Created by Salah Filali on 26/1/2023.
//

import XCTest
@testable import CalculatricePolonaise

final class CalculatricePolonaiseTests: XCTestCase {
    
    var sut: CalculatriceViewModel!
    
    func testDivisionBy0ShowError() {
        //given
        sut = CalculatriceViewModel()
        
        //when
        sut.currentOperation = .divide
        sut.makeDivideOperation(6, by: 0)
        
        //then
        XCTAssertEqual(sut.errorMessage, "Division par 0 impossible!")
    }
    
    func testAddResultGreaterThanIntShowError() {
        //given
        sut = CalculatriceViewModel()
        
        //when
        sut.currentOperation = .add
        sut.makeAddOperation(with: 1, to: Int.max)
        
        //then
        XCTAssertEqual(sut.errorMessage, "Taille d'entier dépassé!")
    }
    
    func testMultiplyResultGreaterThanIntShowError() {
        //given
        sut = CalculatriceViewModel()
        
        //when
        sut.currentOperation = .multiply
        sut.makeMultiplyOperation(with: Int.max, to: 2)
        
        //then
        XCTAssertEqual(sut.errorMessage, "Taille d'entier dépassé!")
    }
    
    func testSubstractResultGreaterThanIntShowError() {
        //given
        sut = CalculatriceViewModel()
        
        //when
        sut.currentOperation = .subtract
        sut.makeSubstractOperation(with: Int.min, from: 0)
        
        //then
        XCTAssertEqual(sut.errorMessage, "Taille d'entier dépassé!")
    }
    
    func testFactorialResultGreaterThanIntShowError() {
        //given
        sut = CalculatriceViewModel()
        
        //when
        _ = sut.factorial(22)
        
        //then
        XCTAssertEqual(sut.errorMessage, "Taille d'entier dépassé!")
    }
    
    func testPowerResultGreaterThanIntShowError() {
        //given
        sut = CalculatriceViewModel()
        
        //when
        sut.currentOperation = .power
        sut.makePowerOperation(base: Int.max, exponent: 99)//makeSubstractOperation(with: Int.min, from: 0)
        
        //then
        XCTAssertEqual(sut.errorMessage, "Taille d'entier dépassé!")
    }
    
    func testTappingAddButtonUpdatesOperationToAdd() {
        //given
        sut = CalculatriceViewModel()
        
        //when
        sut.didTap(button: .add)
        
        //then
        XCTAssertEqual(sut.currentOperation, .add)
    }

    func testTappingMinusButtonUpdatesOperationToSubstract() {
        //given
        sut = CalculatriceViewModel()
        
        //when
        sut.didTap(button: .subtract)
        
        //then
        XCTAssertEqual(sut.currentOperation, .subtract)
    }
    
    func testTappingDivideButtonUpdatesOperationToDivide() {
        //given
        sut = CalculatriceViewModel()
        
        //when
        sut.didTap(button: .divide)
        
        //then
        XCTAssertEqual(sut.currentOperation, .divide)
    }
    
    func testTappingMultiplyButtonUpdatesOperationToMultiply() {
        //given
        sut = CalculatriceViewModel()
        
        //when
        sut.didTap(button: .mutliply)
        
        //then
        XCTAssertEqual(sut.currentOperation, .multiply)
    }
    
    func testTappingPowerButtonUpdatesOperationToPower() {
        //given
        sut = CalculatriceViewModel()
        
        //when
        sut.didTap(button: .power)
        
        //then
        XCTAssertEqual(sut.currentOperation, .power)
    }
    
    func testTappingPowerOperationResult() {
        //given
        sut = CalculatriceViewModel()
        
        //when
        let result = sut.power(3, 2)
        
        //then
        XCTAssertEqual(result, 9)
    }
    
    func testZeroFactorialResult() {
        //given
        sut = CalculatriceViewModel()
        sut.value = "0"
        //when
        sut.didTap(button: .factorial)
        
        //then
        XCTAssertEqual(sut.value, "1")
    }
    
    func testFactorialResult() {
        //given
        sut = CalculatriceViewModel()
        sut.value = "4"
        //when
        sut.didTap(button: .factorial)
        
        //then
        XCTAssertEqual(sut.value, "24")
    }
    
    func testTappingClearButton() {
        //given
        sut = CalculatriceViewModel()
        
        //when
        sut.didTap(button: .clear)
        
        //then
        XCTAssertEqual(sut.value, "")
        XCTAssertEqual(sut.workingSpaceText, "")
        XCTAssertEqual(sut.runningNumber, 0)
    }
    
    func testTappingNumberButtonUpdatesValue() {
        //given
        sut = CalculatriceViewModel()
        
        //when
        sut.didTap(button: .four)
        
        //then
        XCTAssertEqual(sut.value, "4")
        XCTAssertEqual(sut.workingSpaceText, "4")
    }

    func testTappingDecimalButtonUpdatesValue() {
        //given
        sut = CalculatriceViewModel()
        sut.value = "3"
        //when
        sut.didTap(button: .decimal)
        
        //then
        XCTAssertEqual(sut.value, "3.")
    }
    
    func testTappingDecimalButtonDoesntUpdatesValueWhenNumberEndsWithDecimalOperator() {
        //given
        sut = CalculatriceViewModel()
        sut.value = "3."
        //when
        sut.didTap(button: .decimal)
        
        //then
        XCTAssertEqual(sut.value, "3.")
    }
    
    func testTappingDecimalButtonDoesntUpdatesValueWhenNumberAlreadyHasDecimalOperator() {
        //given
        sut = CalculatriceViewModel()
        sut.value = "3.2"
        //when
        sut.didTap(button: .decimal)
        
        //then
        XCTAssertEqual(sut.value, "3.2")
    }
    
    func testTappingEqualButtonAfterAddOperationUpdatesValue() {
        //given
        sut = CalculatriceViewModel()
        sut.value = "34"
        sut.runningNumber = 6
        sut.currentOperation = .add
        //when
        sut.didTap(button: .equal)
        
        //then
        XCTAssertEqual(sut.value, "40")
    }
    
    func testTappingEqualButtonAfterSubstractOperationUpdatesValue() {
        //given
        sut = CalculatriceViewModel()
        sut.value = "34"
        sut.runningNumber = 6
        sut.currentOperation = .subtract
        //when
        sut.didTap(button: .equal)
        
        //then
        XCTAssertEqual(sut.value, "28")
    }
    
    func testTappingEqualButtonAfterMultiplyOperationUpdatesValue() {
        //given
        sut = CalculatriceViewModel()
        sut.value = "34"
        sut.runningNumber = 2
        sut.currentOperation = .multiply
        //when
        sut.didTap(button: .equal)
        
        //then
        XCTAssertEqual(sut.value, "68")
    }
    
    func testTappingEqualButtonAfterDivideOperationUpdatesValue() {
        //given
        sut = CalculatriceViewModel()
        sut.value = "2"
        sut.runningNumber = 34
        sut.currentOperation = .divide
        //when
        sut.didTap(button: .equal)
        
        //then
        XCTAssertEqual(sut.value, "17.0")
    }
    
    func testTappingEqualButtonAfterPowerOperationUpdatesValue() {
        //given
        sut = CalculatriceViewModel()
        sut.value = "3"
        sut.runningNumber = 2
        sut.currentOperation = .power
        //when
        sut.didTap(button: .equal)
        
        //then
        XCTAssertEqual(sut.value, "8.0")
    }
}
