//
//  DynamicCalculateTests.swift
//  SerfodiCalculatorTests
//
//  Created by Сергей Насыбуллин on 24.04.2024.
//

import XCTest
@testable import SerfodiCalculator

final class DynamicCalculateTests: XCTestCase {

    let calculate = DynamicCalculate()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
    func testCalculateResult() throws {
        let expression :[CalculationItem] = [
            .number(25), .operation(.add), .number(10)
        ]
        let result = try calculate.calculate(items: expression)
        XCTAssertEqual(35, result)
    }

    func testPriorityOperations() throws {
        let expression :[CalculationItem] = [
            .number(25), .operation(.add), .number(10), .operation(.multiply), .number(2)
        ]
        let result = try calculate.calculate(items: expression)
        XCTAssertEqual(45, result)
    }
    
    func testHangingPriorityTwoOperation() throws {
        let expression :[CalculationItem] = [
            .number(25), .operation(.subtract), .number(10), .operation(.divide)
        ]
        let result = try calculate.calculate(items: expression)
        XCTAssertEqual(10, result)
    }
    
    func testHangingPriorityZeroOperation() throws {
        let expression :[CalculationItem] = [
            .number(25), .operation(.subtract), .number(10), .operation(.add)
        ]
        let result = try calculate.calculate(items: expression)
        XCTAssertEqual(15, result)
    }
    
    
    
    
}
