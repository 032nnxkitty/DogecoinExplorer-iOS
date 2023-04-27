//
//  CoreDataManagerUnitTests.swift
//  DogeExplorerAppUnitTests
//
//  Created by Arseniy Zolotarev on 27.04.2023.
//

import XCTest
@testable import DogeExplorerApp_iOS

final class CoreDataManagerUnitTests: XCTestCase {
    var sut: AddressTrackingService!
    
    override func setUpWithError() throws {
        sut = CoreDataManager.shared
        sut.deleteAllTrackedAddresses()
    }
    
    override func tearDownWithError() throws {
        sut.deleteAllTrackedAddresses()
        sut = nil
    }
    
    // MARK: - Tests
    func testAddNewTrackedAddress() throws {
        // Given
        let address = "DQL55LjFkYagcCdx9HXztYAepcXY3jb6Wa"
        let name = "Andrew"
        
        // When
        sut.addNewTrackedAddress(address: address, name: name)
        let addresses = sut.getAllTrackedAddresses()
        
        // Then
        XCTAssertEqual(addresses.count, 1)
        XCTAssertEqual(addresses.first?.address, address)
        XCTAssertEqual(addresses.first?.name, name)
    }
    
    func testGetAllTrackedAddresses() throws {
        // Given
        let address1 = "DQL55LjFkYagcCdx9HXztYAepcXY3jb6Wa"
        let name1 = "Andrew"
        sut.addNewTrackedAddress(address: address1, name: name1)
        
        let address2 = "9wYpKfWNaWFtZ3KCqgoZM5AyYCz7S7juLV"
        let name2 = "Pablo"
        sut.addNewTrackedAddress(address: address2, name: name2)
        
        // When
        let addresses = sut.getAllTrackedAddresses()
        
        // Then
        XCTAssertEqual(addresses.count, 2)
    }
    
    func testDeleteAllTrackedAddresses() throws {
        // Given
        let address1 = "DQL55LjFkYagcCdx9HXztYAepcXY3jb6Wa"
        let name1 = "Andrew"
        sut.addNewTrackedAddress(address: address1, name: name1)
        
        let address2 = "9wYpKfWNaWFtZ3KCqgoZM5AyYCz7S7juLV"
        let name2 = "Pable"
        sut.addNewTrackedAddress(address: address2, name: name2)
        
        // When
        sut.deleteAllTrackedAddresses()
        let addresses = sut.getAllTrackedAddresses()
        
        // Then
        XCTAssertEqual(addresses.count, 0)
    }
    
    func testDeleteTracking() throws {
        // Given
        let address1 = "DQL55LjFkYagcCdx9HXztYAepcXY3jb6Wa"
        let name1 = "Andrew"
        sut.addNewTrackedAddress(address: address1, name: name1)
        
        let address2 = "9wYpKfWNaWFtZ3KCqgoZM5AyYCz7S7juLV"
        let name2 = "Pable"
        sut.addNewTrackedAddress(address: address2, name: name2)
        
        // When
        sut.deleteTracking(address1)
        let addresses = sut.getAllTrackedAddresses()
        
        // Then
        XCTAssertEqual(addresses.count, 1)
        XCTAssertEqual(addresses[0].address, address2)
        XCTAssertEqual(addresses[0].name, name2)
    }
    
    func testRenameAddress() throws {
        // Given
        let address = "DQL55LjFkYagcCdx9HXztYAepcXY3jb6Wa"
        let name = "Andrew"
        let newName = "Andrej"
        sut.addNewTrackedAddress(address: address, name: name)
        
        // When
        sut.renameAddress(address, to: newName)
        let addresses = sut.getAllTrackedAddresses()
        
        // Then
        XCTAssertEqual(addresses.count, 1)
        XCTAssertEqual(addresses[0].address, address)
        XCTAssertEqual(addresses[0].name, newName)
    }
    
    func testGetTrackingName() throws {
        // Given
        let address = "DQL55LjFkYagcCdx9HXztYAepcXY3jb6Wa"
        let name = "Andrew"
        sut.addNewTrackedAddress(address: address, name: name)
        
        // When
        let trackingName = sut.getTrackingName(for: address)
        
        // Then
        XCTAssertEqual(name, trackingName)
    }
}
