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


