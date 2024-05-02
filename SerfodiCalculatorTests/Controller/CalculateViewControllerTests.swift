//
//  CalculateVeiwController.swift
//  SerfodiCalculatorTests
//
//  Created by Сергей Насыбуллин on 24.04.2024.
//

import XCTest
@testable import SerfodiCalculator

final class CalculateViewControllerTests: XCTestCase {

    var sut: ViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        sut = vc as? ViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTappingCellSendsNotification() {
        let tableView = sut.historyVC.table
        let calculation = Calculation(expression: [.number(0)], result: 0)
        sut.dataProvider.addCalculate(calculation)
        
        expectation(forNotification: NSNotification.Name("DidSelectRowAtNotification"), object: nil) { notification in
            guard let taskFromNotification = notification.userInfo?["indexPath"] as? IndexPath else {
                return false
            }
            return taskFromNotification == IndexPath(row: 0, section: 0)
        }
        tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        waitForExpectations(timeout: 1)
    }

    func testWhenViewIsLoadedDataProviderIsNotNil() {
           XCTAssertNotNil(sut.dataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDelegateIsSet() {
        XCTAssertTrue(sut.historyVC.table.delegate is CoreDataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDataSourceIsSet() {
        XCTAssertTrue(sut.historyVC.table.dataSource is CoreDataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDelegateEqualeTableViewDataSource() {
        XCTAssertEqual(sut.historyVC.table.delegate as? CoreDataProvider,
                       sut.historyVC.table.dataSource as? CoreDataProvider
        )
    }
    
    func testSimpleInput() throws {
        let expression:[CalculationItem] = [.number(123)]
        sut.number("1")
        sut.number("2")
        sut.number("3")
        sut.calculator.equal(result: 123) { items in
            XCTAssertEqual(items, expression)
        }
    }
    
    func testSimpleInputExpressin() throws {
        let expression:[CalculationItem] = [.number(123), .operation(.add), .number(321)]
        sut.number("1")
        sut.number("2")
        sut.number("3")
        sut.operating(.add)
        sut.number("3")
        sut.number("2")
        sut.number("1")
        sut.calculator.equal(result: 123) { items in
            XCTAssertEqual(items, expression)
        }
    }
    
    func testChangeOperation1P() throws {
        let expression:[CalculationItem] = [.number(123), .operation(.subtract), .number(321)]
        sut.number("1")
        sut.number("2")
        sut.number("3")
        sut.operating(.add)
        sut.operating(.subtract)
        sut.number("3")
        sut.number("2")
        sut.number("1")
        
        sut.calculator.equal(result: 123) { items in
            XCTAssertEqual(items, expression)
        }
    }
    
    func testChangeOperation2P() throws {
        let expression:[CalculationItem] = [.number(2), .operation(.add), .number(3), .operation(.subtract), .number(9)]
        sut.number("2")
        sut.operating(.add)
        sut.number("3")
        sut.operating(.multiply)
        sut.operating(.subtract)
        sut.number("9")
        sut.calculator.equal(result: 123) { items in
            XCTAssertEqual(items, expression)
        }
    }
    
    func testSimpleInputOperationUnary() throws {
        let expression:[CalculationItem] = [.number(123), .operation(.pow2), .operation(.pow2), .operation(.pow3)]
        sut.number("1")
        sut.number("2")
        sut.number("3")
        sut.operating(.pow2)
        sut.operating(.pow2)
        sut.operating(.pow3)
        sut.calculator.equal(result: 123) { items in
            XCTAssertEqual(items, expression)
        }
    }
    
}
