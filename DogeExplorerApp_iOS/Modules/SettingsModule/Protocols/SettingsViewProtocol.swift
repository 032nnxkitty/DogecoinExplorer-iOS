//
//  SettingsViewProtocol.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 27.04.2023.
//

import Foundation

protocol SettingsView: AnyObject {
    func showConfirmationActionSheet()
    func showOkActionSheet(title: String, message: String)
    func setThemeIndex(_ index: Int)
    func openLink(url: URL)
    func changeTheme()
}
