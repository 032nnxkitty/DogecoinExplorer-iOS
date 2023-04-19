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

extension UserDefaults: AddressTrackingService {
    private var trackedAddresses: TrackedAddresses {
        get {
            guard let data = object(forKey: "trackedAddresses") as? Data else { return [] }
            guard let addresses = try? JSONDecoder().decode(TrackedAddresses.self, from: data) else { return [] }
            return addresses
        } set {
            guard let addressesData = try? JSONEncoder().encode(newValue) else { return }
            set(addressesData, forKey: "trackedAddresses")
        }
    }
    
    // MARK: - Public Methods
    func getAllTrackedAddresses() -> TrackedAddresses {
        return trackedAddresses
    }
    
    func addNewTrackedAddress(_ addressModel: TrackedAddress) {
        trackedAddresses = ([addressModel] + trackedAddresses)
    }
    
    func getTrackedAddressModel(for address: String) -> TrackedAddress? {
        return trackedAddresses.first(where: { $0.address == address })
    }
    
    func deleteTracking(_ addressToDelete: String) {
        trackedAddresses = trackedAddresses.filter { $0.address != addressToDelete }
    }
    
    func renameAddress(_ address: String, to newName: String) {
        guard let addressModel = getTrackedAddressModel(for: address) else { return }
        guard let index = trackedAddresses.firstIndex(of: addressModel) else { return }
        trackedAddresses[index].name = newName
    }
    
    func deleteAllTrackedAddresses() {
        trackedAddresses = []
    }
    
    func addMockData() {
        deleteAllTrackedAddresses()
        let mockAddresses = [
            TrackedAddress(name: "Andrew",  address: "DEpFaVzjmQVYh4RWiCDSwnc6XyvQaxuyr8"),
            TrackedAddress(name: "Martin",  address: "9ssX8XqDX6yTxW8rfLw6VHnbAnVUp8xtYY"),
            TrackedAddress(name: "Luke",    address: "DR2SpAVZPwJDVxJgTkJvGej3HC5aLBhQBM"),
            TrackedAddress(name: "Josh",    address: "DTsBpxfR9otQTRJEXc7dW4HmuNVgutc6fW"),
            TrackedAddress(name: "Pablo",   address: "DPHAELEVeUxCCWEg9rUpTxcXxyrh1evNwP"),
            TrackedAddress(name: "Ondrej",  address: "DLEeNyDDw9bTNnDRbaY2yuooyq8SUSJSLW"),
            TrackedAddress(name: "Nasty",   address: "DSiyxmXxW5z4GQ3jHgorMTGLJBrGYAckEh"),
            TrackedAddress(name: "Ja",      address: "D5RpQhaVkpHHT4n8HrPahoVWbwmSohNpEt")
        ]
        for address in mockAddresses {
            addNewTrackedAddress(address)
        }
    }
}
