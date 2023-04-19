//
//  SettingsModel.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 15.04.2023.
//

import Foundation


struct SettingsCell {
    let title: String
    let style: CellStyle
}

// MARK: Raw Value = Image Name
enum CellStyle: String {
    case language        = "globe"
    case theme           = "sun.max"
    case deleteAddresses = "trash"
    case github          = "github"
    case feedback        = "paperplane"
    case rateApp         = "hand.thumbsup"
    case supportMe       = "heart"
}

typealias SettingsSection = [SettingsCell]

struct SettingsModel {
    var model: [SettingsSection] {
        return [
            [
                SettingsCell(title: "Language",                     style: .language),
                SettingsCell(title: "Theme",                        style: .theme),
                SettingsCell(title: "Delete all tracked addresses", style: .deleteAddresses)
            ],
            [
                SettingsCell(title: "Source code",                  style: .github),
                SettingsCell(title: "Feedback",                     style: .feedback),
                SettingsCell(title: "Rate App in the App Store",    style: .rateApp),
                SettingsCell(title: "My dogecoin address :)",       style: .supportMe),
            ]
        ]
    }
}
