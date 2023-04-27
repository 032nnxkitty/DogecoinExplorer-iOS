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

    // MARK: - Tests
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
        let givenSum = "105730562.40957393"
        let expectedResult = "105,730,562.410"
        
        // When
        let result = givenSum.formatNumberString()
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func testSumFormattingWithoutFloatPoint() throws {
        // Given
        let givenSum = "440"
        let expectedResult = "440"
        
        // When
        let result = givenSum.formatNumberString()
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func testBalanceEndpointCreating() throws {
        // Given
        let givenAddress = "D5RpQhaVkpHHT4n8HrPahoVWbwmSohNpEt"
        let expectedResult = URL(string: "address/balance/D5RpQhaVkpHHT4n8HrPahoVWbwmSohNpEt", relativeTo: URL(string: "https://dogechain.info/api/v1/"))
        
        // When
        let result = DogechainAPIEndpoint.balance(address: givenAddress).url
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func testTransactionInfoEndpointCreating() throws {
        // Given
        let givenHash = "ade40b69b9d9cebedfb006f5dea3e83cdd5be2d5d8a659e8906278b3441be064"
        let expectedResult = URL(string: "transaction/ade40b69b9d9cebedfb006f5dea3e83cdd5be2d5d8a659e8906278b3441be064", relativeTo: URL(string: "https://dogechain.info/api/v1/"))
        
        // When
        let result = DogechainAPIEndpoint.transactionInfo(hash: givenHash).url
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
}
