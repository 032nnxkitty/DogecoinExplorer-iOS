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

enum CellStyle: String {
    case language
    case theme
    case deleteAddresses
    case github
    case feedback
    case rateApp
    case supportMe
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
