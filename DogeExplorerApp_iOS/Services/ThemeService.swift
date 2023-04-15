//
//  ThemeService.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 15.04.2023.
//

import UIKit

enum Theme: Int {
    case dark
    case light
    case device
}

extension Theme {
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .dark:
            return .dark
        case .light:
            return .light
        case .device:
            return .unspecified
        }
    }
}

extension UserDefaults {
    var theme: Theme {
        get {
            let currentThemeIndex = integer(forKey: "themeService")
            return Theme(rawValue: currentThemeIndex) ?? .dark
        } set {
            set(newValue.rawValue, forKey: "themeService")
        }
    }
}

