//
//  AddressTrackingService.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 15.04.2023.
//

import Foundation

struct TrackedAddress: Codable, Equatable {
    var name: String
    var address: String
}

typealias TrackedAddresses = [TrackedAddress]

protocol AddressTrackingService {
    func getAllTrackedAddresses() -> TrackedAddresses
    func getTrackedAddressModel(for address: String) -> TrackedAddress?
    
    func addNewTrackedAddress(_ addressModel: TrackedAddress)
    func renameAddress(_ address: String, to newName: String)
    func deleteTracking(_ addressToDelete: String)
    func deleteAllTrackedAddresses()
    
    func addMockData()
}
