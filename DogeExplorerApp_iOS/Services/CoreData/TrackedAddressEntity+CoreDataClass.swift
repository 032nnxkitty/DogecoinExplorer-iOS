//
//  TrackedAddressEntity+CoreDataClass.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 22.04.2023.
//
//

import Foundation
import CoreData

@objc(TrackedAddressEntity)
public class TrackedAddressEntity: NSManagedObject {

}

extension TrackedAddressEntity {
    @NSManaged public var name: String?
    @NSManaged public var address: String?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackedAddressEntity> {
        return NSFetchRequest<TrackedAddressEntity>(entityName: "TrackedAddressEntity")
    }
}

extension TrackedAddressEntity : Identifiable {

}
