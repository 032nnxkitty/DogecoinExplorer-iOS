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
    case theme           = "circle.righthalf.filled"
    case deleteAddresses = "trash.fill"
    case github          = "swift"
    case feedback        = "paperplane.fill"
    case rateApp         = "hand.thumbsup.fill"
    case supportMe       = "heart.fill"
}

typealias SettingsSection = [SettingsCell]

struct SettingsModel {
    var model: [SettingsSection] {
        return [
            [
                SettingsCell(title: R.LocalizableStrings.language,   style: .language),
                SettingsCell(title: R.LocalizableStrings.theme,      style: .theme),
                SettingsCell(title: R.LocalizableStrings.deleteAll,  style: .deleteAddresses)
            ],
            [
                SettingsCell(title: R.LocalizableStrings.sourceCode, style: .github),
                SettingsCell(title: R.LocalizableStrings.feedback,   style: .feedback),
                SettingsCell(title: R.LocalizableStrings.appStore,   style: .rateApp),
                SettingsCell(title: R.LocalizableStrings.support,    style: .supportMe),
            ]
        ]
    }
}
