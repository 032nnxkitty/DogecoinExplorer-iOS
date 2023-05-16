//
//  CoreDataManager.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 22.04.2023.
//

import CoreData

protocol AddressTrackingService {
    func getAllTrackedAddresses() -> [(address: String, name: String)]
    func deleteAllTrackedAddresses()
    
    func addNewTrackedAddress(address: String, name: String)
    func deleteTracking(_ addressToDelete: String)
    func renameAddress(_ address: String, to newName: String)
    func getTrackingName(for address: String) -> String?
    
    func addMockData()
}

class CoreDataManager {
    static let shared = CoreDataManager()
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
extension CoreDataManager: AddressTrackingService {
    func addNewTrackedAddress(address: String, name: String) {
        let newAddressEntity = TrackedAddressEntity(context: persistentContainer.viewContext)
        newAddressEntity.address = address
        newAddressEntity.name = name
        saveContext()
    }
    
    func getAllTrackedAddresses() -> [(address: String, name: String)] {
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        guard let entitiesArray = try? viewContext.fetch(fetchRequest), !entitiesArray.isEmpty else { return [] }
        var result: [(String, String)] = []
        for trackedAddressesEntity in entitiesArray {
            if let name = trackedAddressesEntity.name, let address = trackedAddressesEntity.address {
                result.append((address, name))
            }
        }
        return result.reversed()
    }
    
    func deleteAllTrackedAddresses() {
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        guard let entitiesArray = try? viewContext.fetch(fetchRequest), !entitiesArray.isEmpty else { return }
        for entity in entitiesArray {
            viewContext.delete(entity)
        }
        saveContext()
    }
    
    func deleteTracking(_ addressToDelete: String) {
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "address == %@", addressToDelete)
        guard let entitiesArray = try? viewContext.fetch(fetchRequest), !entitiesArray.isEmpty else { return }
        viewContext.delete(entitiesArray[0])
        saveContext()
    }
    
    func getTrackingName(for address: String) -> String? {
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "address == %@", address)
        guard let entitiesArray = try? viewContext.fetch(fetchRequest),
              !entitiesArray.isEmpty,
              let name = entitiesArray[0].name else { return nil }
        return name
    }
    
    func renameAddress(_ address: String, to newName: String) {
        let fetchRequest = TrackedAddressEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "address == %@", address)
        guard let entitiesArray = try? viewContext.fetch(fetchRequest), !entitiesArray.isEmpty else { return }
        entitiesArray[0].name = newName
        saveContext()
    }
    
    func addMockData() {
        deleteAllTrackedAddresses()
        addNewTrackedAddress(address: "DQL55LjFkYagcCdx9HXztYAepcXY3jb6Wa", name: "Andrew, Dubai expo")
        addNewTrackedAddress(address: "DKQJ5X3scmBqv37kvAYjWRRhTFDiXFdzz6", name: "Martin")
        addNewTrackedAddress(address: "DNqp3QBLpc8SCXV2Ww9YeMxZPfjwci1uZ1", name: "Luke")
        addNewTrackedAddress(address: "DTsBpxfR9otQTRJEXc7dW4HmuNVgutc6fW", name: "Josh")
        addNewTrackedAddress(address: "9wYpKfWNaWFtZ3KCqgoZM5AyYCz7S7juLV", name: "Pablo")
        addNewTrackedAddress(address: "DAwJBoNqkHoT523p9h8gUjWJYSPc4RdDsr", name: "Tesla California")
        addNewTrackedAddress(address: "DNqos1BcjPSZGxQn51nhcKydjA73nxohwC", name: "Eliška")
        addNewTrackedAddress(address: "D5RpQhaVkpHHT4n8HrPahoVWbwmSohNpEt", name: "My wallet")
    }
}
