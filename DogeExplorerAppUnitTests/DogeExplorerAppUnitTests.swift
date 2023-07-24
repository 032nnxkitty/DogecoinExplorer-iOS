//
//  DogeExplorerAppUnitTests.swift
//  DogeExplorerAppUnitTests
//
//  Created by Arseniy Zolotarev on 26.04.2023.
//

import XCTest
@testable import DogeExplorerApp_iOS

final class DogeExplorerAppUnitTests: XCTestCase {
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
    
    func testUnixTimeShortenFormatting() throws {
        // Given
        let givenTime1: Int = 1386273600
        let givenTime2: Int = 1554197040
        
        let expectedResult1 = "6 Dec 2013"
        let expectedResult2 = "2 Apr 2019"
        
        // When
        let result1 = givenTime1.formatUnixTime(style: .shorten)
        let result2 = givenTime2.formatUnixTime(style: .shorten)
        
        // Then
        XCTAssertEqual(result1, expectedResult1)
        XCTAssertEqual(result2, expectedResult2)
    }
    
    func testUnixTimeDetailedFormatting() throws {
        // Given
        let givenTime1: Int = 1386273600
        let givenTime2: Int = 1554197040
        
        let expectedResult1 = "2013-12-06 12:00:00 +0400"
        let expectedResult2 = "2019-04-02 12:24:00 +0300"
        
        // When
        let result1 = givenTime1.formatUnixTime(style: .detailed)
        let result2 = givenTime2.formatUnixTime(style: .detailed)
        
        // Then
        XCTAssertEqual(result1, expectedResult1)
        XCTAssertEqual(result2, expectedResult2)
    }
}
