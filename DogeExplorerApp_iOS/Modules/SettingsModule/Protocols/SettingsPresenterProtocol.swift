//
//  SettingsPresenterProtocol.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 27.04.2023.
//

import Foundation

typealias SettingsPresenter = SettingsPresenterActions & SettingsPresenterEventHandling & SettingsPresenterViewConfiguring

protocol SettingsPresenterActions {
    func deleteAllTrackedAddresses()
}

protocol SettingsPresenterEventHandling {
    func didSelectRow(at indexPath: IndexPath)
    func themeIndexDidChange(to index: Int)
}

protocol SettingsPresenterViewConfiguring {
    func getNumberOfSection() -> Int
    func getNumberOfRows(in section: Int) -> Int
    func configureCell(at indexPath: IndexPath, completion: @escaping (_ title: String, _ iconName: String, _ isThemeCell: Bool) -> Void)
    func getTitleForFooter(in section: Int) -> String?
}
