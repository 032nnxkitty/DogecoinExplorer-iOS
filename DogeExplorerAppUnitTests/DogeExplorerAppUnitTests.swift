//
//  DogeExplorerAppUnitTests.swift
//  DogeExplorerAppUnitTests
//
//  Created by Arseniy Zolotarev on 26.04.2023.
//

import XCTest
@testable import DogeExplorerApp_iOS

final class DogeExplorerAppUnitTests: XCTestCase {
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    // MARK: - Extensions Tests
    func testShortenAddress() throws {
        // Given
        let givenAddress = "D5RpQhaVkpHHT4n8HrPahoVWbwmSohNpEt"
        let expectedResult = "D5RpQh...ohNpEt"
        
        // When
        let result = givenAddress.shorten(prefix: 6, suffix: 6)
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func testSumFormattingWithFloatPoint() throws {
        // Given
        let givenSum = "105730562.124"
        let expectedResult = "105 730 562,12"
        
        // When
        let result = givenSum.formatNumberString()
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func testSumFormattingWithoutFloatPoint() throws {
        // Given
        let givenSum = "440"
        let expectedResult = "440,00"
        
        // When
        let result = givenSum.formatNumberString()
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
}
