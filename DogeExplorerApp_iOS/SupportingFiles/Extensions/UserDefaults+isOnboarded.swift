//
//  UserDefaults+isOnboarded.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 19.07.2023.
//

import Foundation

extension UserDefaults {
    fileprivate var isOnboardedKey: String { "isOnboardedKey" }
    
    var isOnboarded: Bool {
        get {
            return bool(forKey: isOnboardedKey)
        }
        set {
            set(newValue, forKey: isOnboardedKey)
        }
    }
}
