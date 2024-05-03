//
//  CalculationItemParserTests.swift
//  SerfodiCalculatorTests
//
//  Created by Сергей Насыбуллин on 26.04.2024.
//

import XCTest
@testable import SerfodiCalculator

final class CalculationItemParserTests: XCTestCase {

    let parser = CalculationItemParser()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParsing1() {
        let expression: [CalculationItem] = [.number(1), .operation(.add), .number(2), .operation(.multiply), .number(3)]
        let final: [CalculationItem] = [.number(1), .number(2), .number(3), .operation(.multiply), .operation(.add),]
        let parsingE = parser.parsing(items: expression, isFinal: true)
        XCTAssertEqual(final, parsingE)
    }

    func testParsing2() {
        let expression: [CalculationItem] = [.number(1), .operation(.add), .number(2), .operation(.multiply), .number(3), .operation(.pow2)]
        let final: [CalculationItem] = [.number(1), .number(2), .number(3), .operation(.pow2), .operation(.multiply), .operation(.add),]
        let parsingE = parser.parsing(items: expression, isFinal: true)
        XCTAssertEqual(final, parsingE)
    }
    
    func testParsing3() {
        let expression: [CalculationItem] = [.number(1), .operation(.add), .number(2), .operation(.multiply), .number(3), .operation(.pow2), .operation(.multiply)]
        let final: [CalculationItem] = [.number(1), .number(2), .number(3), .operation(.pow2), .operation(.multiply), .operation(.add)]
        let parsingE = parser.parsing(items: expression, isFinal: true)
        XCTAssertEqual(final, parsingE)
    }
    
    func testParsing4() {
        let expression: [CalculationItem] = [.number(1), .operation(.pow2), .operation(.root2)]
        let final: [CalculationItem] = [.number(1), .operation(.pow2), .operation(.root2)]
        let parsingE = parser.parsing(items: expression, isFinal: true)
        XCTAssertEqual(final, parsingE)
    }
    
    func testParsingIsFinal1() {
        let expression: [CalculationItem] = [.number(1), .operation(.pow2), .operation(.root2)]
        let final: [CalculationItem] = [.number(1), .operation(.pow2), .operation(.root2)]
        let parsingE = parser.parsing(items: expression, isFinal: false)
        XCTAssertEqual(final, parsingE)
    }
    
    func testParsingIsFinal2() {
        let expression: [CalculationItem] = [.number(1), .operation(.add), .number(2), .operation(.multiply)]
        let final: [CalculationItem] = [.number(2)]
        let parsingE = parser.parsing(items: expression, isFinal: false)
        XCTAssertEqual(final, parsingE)
    }
    
    func testParsingIsFinal3() {
        let expression: [CalculationItem] = [.number(1), .operation(.add), .number(2), .operation(.pow2), .operation(.pow2)]
        let final: [CalculationItem] = [.number(2), .operation(.pow2), .operation(.pow2)]
        let parsingE = parser.parsing(items: expression, isFinal: false)
        XCTAssertEqual(final, parsingE)
    }
    
    func testParsingIsFinal4() {
        let expression: [CalculationItem] = [.number(1), .operation(.add), .number(2), .operation(.pow2), .operation(.pow2), .operation(.add), .number(3), .operation(.pow2), .operation(.pow2)]
        let final: [CalculationItem] = [.number(3), .operation(.pow2), .operation(.pow2)]
        let parsingE = parser.parsing(items: expression, isFinal: false)
        XCTAssertEqual(final, parsingE)
    }
    
    func testPointParsingIsFinal1() {
        let expression: [CalculationItem] = [.number(1), .operation(.add), .number(4), .operation(.multiply), .number(2), .operation(.pow2)]
        let final: [CalculationItem] = [.number(2), .operation(.pow2)]
        let parsingE = parser.parsing(items: expression, isFinal: false)
        XCTAssertEqual(final, parsingE)
    }
    
    func testPointParsingIsFinal2() {
        let expression: [CalculationItem] = [.number(2), .operation(.pow2), .operation(.pow2), .operation(.add), .number(4)]
        let final: [CalculationItem] = [.number(2), .operation(.pow2), .operation(.pow2), .number(4), .operation(.add)]
        let parsingE = parser.parsing(items: expression, isFinal: false)
        XCTAssertEqual(final, parsingE)
    }
    
    func testPointParsingIsFinal3() {
        let expression: [CalculationItem] = [.number(2), .operation(.pow2), .operation(.pow2), .operation(.add), .number(4), .operation(.pow2)]
        let final: [CalculationItem] = [.number(4), .operation(.pow2)]
        let parsingE = parser.parsing(items: expression, isFinal: false)
        XCTAssertEqual(final, parsingE)
    }
    
    
    
}
