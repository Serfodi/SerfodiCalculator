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
    
    
}
