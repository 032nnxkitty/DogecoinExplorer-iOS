//
//  DogeExplorerAppUITests.swift
//  DogeExplorerAppUITests
//
//  Created by Arseniy Zolotarev on 26.04.2023.
//

import XCTest

final class DogeExplorerAppUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
        
    }

    override func tearDownWithError() throws {
        
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
}
