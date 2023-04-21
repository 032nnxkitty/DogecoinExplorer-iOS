//
//  ThemeService.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 15.04.2023.
//

import UIKit

enum Theme: Int {
    case device
    case dark
    case light
}

extension Theme {
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .device:
            return .unspecified
        case .dark:
            return .dark
        case .light:
            return .light
        }
    }
}

extension UserDefaults {
    var theme: Theme {
        get {
            let currentThemeIndex = integer(forKey: R.Keys.theme)
            return Theme(rawValue: currentThemeIndex) ?? .dark
        } set {
            set(newValue.rawValue, forKey: R.Keys.theme)
        }
    }
}

