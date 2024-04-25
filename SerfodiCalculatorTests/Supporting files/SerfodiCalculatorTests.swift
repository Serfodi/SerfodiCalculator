//
//  SerfodiCalculatorTests.swift
//  SerfodiCalculatorTests
//
//  Created by Сергей Насыбуллин on 24.04.2024.
//

import XCTest
@testable import SerfodiCalculator

final class SerfodiCalculatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialViewControllerIsTaskListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as? ViewController
        XCTAssertNotNil(vc)
    }
}
