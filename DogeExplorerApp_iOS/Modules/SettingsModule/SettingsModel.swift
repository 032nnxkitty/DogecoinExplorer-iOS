//
//  SettingsModel.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 15.04.2023.
//

import Foundation

struct SettingsCell {
    let title: String
    let iconName: String
}

typealias SettingsSection = [SettingsCell]

struct SettingsModel {
    var model: [SettingsSection] {
        return [
            [
                SettingsCell(title: "Language",                     iconName: "language"),
                SettingsCell(title: "Theme",                        iconName: "theme"),
                SettingsCell(title: "Delete all tracked addresses", iconName: "delete")
            ],
            [
                SettingsCell(title: "Source code",                  iconName: "github"),
                SettingsCell(title: "Feedback",                     iconName: "feedback"),
                SettingsCell(title: "Rate App in the App Store",    iconName: "rate"),
                SettingsCell(title: "My dogecoin address :)",       iconName: "love")
            ]
        ]
    }
}
