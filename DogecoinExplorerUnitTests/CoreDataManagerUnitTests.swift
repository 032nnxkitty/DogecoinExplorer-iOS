//
//  CoreDataManagerUnitTests.swift
//  DogeExplorerAppUnitTests
//
//  Created by Arseniy Zolotarev on 27.04.2023.
//

import XCTest
@testable import DogeExplorerApp_iOS

final class CoreDataManagerUnitTests: XCTestCase {
    var sut: CoreDataStorageManager!
    
    override func setUpWithError() throws {
        sut = CoreDataStorageManager.shared
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
        sut.addNewAddress(address: address, name: name)
        let addresses = sut.trackedAddresses
        
        // Then
        XCTAssertEqual(addresses.count, 1)
        XCTAssertEqual(addresses.first?.address, address)
        XCTAssertEqual(addresses.first?.name, name)
    }
    
    func testGetAllTrackedAddresses() throws {
        // Given
        let address1 = "DQL55LjFkYagcCdx9HXztYAepcXY3jb6Wa"
        let name1 = "Andrew"
        sut.addNewAddress(address: address1, name: name1)
        
        let address2 = "9wYpKfWNaWFtZ3KCqgoZM5AyYCz7S7juLV"
        let name2 = "Pablo"
        sut.addNewAddress(address: address2, name: name2)
        
        // When
        let addresses = sut.trackedAddresses
        
        // Then
        XCTAssertEqual(addresses.count, 2)
    }
    
    func testDeleteAllTrackedAddresses() throws {
        // Given
        let address1 = "DQL55LjFkYagcCdx9HXztYAepcXY3jb6Wa"
        let name1 = "Andrew"
        sut.addNewAddress(address: address1, name: name1)
        
        let address2 = "9wYpKfWNaWFtZ3KCqgoZM5AyYCz7S7juLV"
        let name2 = "Pable"
        sut.addNewAddress(address: address2, name: name2)
        
        // When
        sut.deleteAllTrackedAddresses()
        let addresses = sut.trackedAddresses
        
        // Then
        XCTAssertEqual(addresses.count, 0)
    }
    
    func testDeleteTracking() throws {
        // Given
        let address1 = "DQL55LjFkYagcCdx9HXztYAepcXY3jb6Wa"
        let name1 = "Andrew"
        sut.addNewAddress(address: address1, name: name1)
        
        let address2 = "9wYpKfWNaWFtZ3KCqgoZM5AyYCz7S7juLV"
        let name2 = "Pable"
        sut.addNewAddress(address: address2, name: name2)
        
        // When
        sut.deleteAddress(address1)
        let addresses = sut.trackedAddresses
        
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
        sut.addNewAddress(address: address, name: name)
        
        // When
        sut.renameAddress(address, newName: newName)
        let addresses = sut.trackedAddresses
        
        // Then
        XCTAssertEqual(addresses.count, 1)
        XCTAssertEqual(addresses[0].address, address)
        XCTAssertEqual(addresses[0].name, newName)
    }
    
    func testGetTrackingName() throws {
        // Given
        let address = "DQL55LjFkYagcCdx9HXztYAepcXY3jb6Wa"
        let name = "Andrew"
        sut.addNewAddress(address: address, name: name)
        
        // When
        let trackingName = sut.getName(for: address)
        
        // Then
        XCTAssertEqual(name, trackingName)
    }
}
