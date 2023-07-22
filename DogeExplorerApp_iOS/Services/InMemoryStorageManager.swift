//
//  InMemoryStorageManager.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.07.2023.
//

import Foundation

final class InMemoryStorageManager: StorageManager {
    static let shared = InMemoryStorageManager()
    
    private let storageManager: StorageManager
    
    private var inMemoryStorage: [(address: String?, name: String?)] = []
    
    private var needUpdateInMemoryStorage: Bool = true
    
    // MARK: - Init
    private init(storageManger: StorageManager = CoreDataStorageManager.shared) {
        self.storageManager = storageManger
    }
    
    // MARK: - Storage Manager Protocol
    var trackedAddresses: [(address: String?, name: String?)] {
        if needUpdateInMemoryStorage {
            inMemoryStorage = storageManager.trackedAddresses
            needUpdateInMemoryStorage = false
        }
        return inMemoryStorage
    }
    
    func addNewAddress(address: String, name: String) {
        storageManager.addNewAddress(address: address, name: name)
        
        inMemoryStorage.append((address, name))
    }
    
    func deleteAddress(_ addressToDelete: String) {
        storageManager.deleteAddress(addressToDelete)
        
        inMemoryStorage = inMemoryStorage.filter { $0.address != addressToDelete }
    }
    
    func renameAddress(_ addressToRename: String, newName: String) {
        storageManager.renameAddress(addressToRename, newName: newName)
        
        inMemoryStorage = inMemoryStorage.map {
            if $0.address == addressToRename {
                return ($0.address, newName)
            } else {
                return $0
            }
        }
    }
    
    func getName(for address: String) -> String? {
        let name = inMemoryStorage.filter { $0.address == address }.first?.name
        return name
    }
    
    func addMockData() {
        storageManager.addMockData()
    }
}
