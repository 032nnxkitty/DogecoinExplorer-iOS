//
//  CoreDataManager.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 22.04.2023.
//

import CoreData

protocol StorageManager {
    var trackedAddresses: [(address: String?, name: String?)] { get }
    
    func addNewAddress(address: String, name: String)
    
    func deleteAddress(_ addressToDelete: String)
    
    func renameAddress(_ addressToRename: String, newName: String)
    
    func getName(for address: String) -> String?
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
    var trackedAddresses: [(address: String?, name: String?)] {
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        guard let entitiesArray = try? viewContext.fetch(fetchRequest), !entitiesArray.isEmpty else {
            return []
        }
        return entitiesArray
            .map { ($0.address, $0.name) }
            .reversed()
    }
    
    func addNewAddress(address: String, name: String) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        
        let newAddressEntity = TrackedAddressEntity(context: backgroundContext)
        newAddressEntity.address = address
        newAddressEntity.name = name
        
        saveContext(backgroundContext: backgroundContext)
    }
    
    func deleteAddress(_ addressToDelete: String) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "address == %@", addressToDelete)
        guard let entitiesArray = try? backgroundContext.fetch(fetchRequest), !entitiesArray.isEmpty else { return }
        backgroundContext.delete(entitiesArray[0])
        
        saveContext(backgroundContext: backgroundContext)
    }
    
    func getName(for address: String) -> String? {
        let backgroundContext = persistentContainer.newBackgroundContext()
        
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "address == %@", address)
        guard let entitiesArray = try? backgroundContext.fetch(fetchRequest),
              !entitiesArray.isEmpty,
              let name = entitiesArray[0].name else { return nil }
        return name
    }
    
    func renameAddress(_ addressToRename: String, newName: String) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "address == %@", addressToRename)
        guard let entitiesArray = try? backgroundContext.fetch(fetchRequest), !entitiesArray.isEmpty else { return }
        entitiesArray[0].name = newName
        
        saveContext(backgroundContext: backgroundContext)
    }
    
    // MARK: - Methods to delete
    func deleteAllTrackedAddresses() {
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        guard let entitiesArray = try? viewContext.fetch(fetchRequest), !entitiesArray.isEmpty else { return }
        entitiesArray.forEach { viewContext.delete($0) }
        
        saveContext(backgroundContext: viewContext)
    }
}
