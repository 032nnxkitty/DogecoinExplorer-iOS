//
//  CoreDataManager.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 22.04.2023.
//

import CoreData

protocol StorageManager {
    var trackedAddresses: [TrackedAddressEntity] { get }
    
    func addNewAddress(address: String, name: String)
    
    func deleteAddress(_ addressToDelete: String)
    
    func renameAddress(_ addressToRename: String, newName: String)
    
    func getName(for address: String) -> String?
    
    func addMockData()
}

final class CoreDataStorageManager {
    static let shared = CoreDataStorageManager()
    private init() {}
    
    private var entityName: String {
        return String(describing: TrackedAddressEntity.self)
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AddressesTrackingDataModel")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    private lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    private func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}

// MARK: - Address Tracking Service Methods
extension CoreDataStorageManager: StorageManager {
    var trackedAddresses: [TrackedAddressEntity] {
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        guard let entitiesArray = try? viewContext.fetch(fetchRequest), !entitiesArray.isEmpty else {
            return []
        }
        return entitiesArray.reversed()
    }
    
    func addNewAddress(address: String, name: String) {
        let newAddressEntity = TrackedAddressEntity(context: viewContext)
        newAddressEntity.address = address
        newAddressEntity.name = name
        saveContext(backgroundContext: viewContext)
    }
    
    func deleteAddress(_ addressToDelete: String) {
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "address == %@", addressToDelete)
        guard let entitiesArray = try? viewContext.fetch(fetchRequest), !entitiesArray.isEmpty else { return }
        viewContext.delete(entitiesArray[0])
        saveContext(backgroundContext: viewContext)
    }
    
    func getName(for address: String) -> String? {
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "address == %@", address)
        guard let entitiesArray = try? viewContext.fetch(fetchRequest),
              !entitiesArray.isEmpty,
              let name = entitiesArray[0].name else { return nil }
        return name
    }
    
    func renameAddress(_ addressToRename: String, newName: String) {
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "address == %@", addressToRename)
        guard let entitiesArray = try? viewContext.fetch(fetchRequest), !entitiesArray.isEmpty else { return }
        entitiesArray[0].name = newName
        
        saveContext(backgroundContext: viewContext)
    }
    
    func deleteAllTrackedAddresses() {
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        guard let entitiesArray = try? viewContext.fetch(fetchRequest), !entitiesArray.isEmpty else { return }
        entitiesArray.forEach { viewContext.delete($0) }
        
        saveContext(backgroundContext: viewContext)
    }
    
    func addMockData() {
        deleteAllTrackedAddresses()
        addNewAddress(address: "DQL55LjFkYagcCdx9HXztYAepcXY3jb6Wa", name: "Andrew, Dubai expo")
        addNewAddress(address: "DKQJ5X3scmBqv37kvAYjWRRhTFDiXFdzz6", name: "Martin")
        addNewAddress(address: "DNqp3QBLpc8SCXV2Ww9YeMxZPfjwci1uZ1", name: "Luke")
        addNewAddress(address: "DTsBpxfR9otQTRJEXc7dW4HmuNVgutc6fW", name: "Josh")
        addNewAddress(address: "9wYpKfWNaWFtZ3KCqgoZM5AyYCz7S7juLV", name: "Pablo")
        addNewAddress(address: "DAwJBoNqkHoT523p9h8gUjWJYSPc4RdDsr", name: "Tesla California")
        addNewAddress(address: "DNqos1BcjPSZGxQn51nhcKydjA73nxohwC", name: "Eliška")
        addNewAddress(address: "D5RpQhaVkpHHT4n8HrPahoVWbwmSohNpEt", name: "My wallet")
    }
}
