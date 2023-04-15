//
//  SettingsPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

protocol SettingsPresenter {
    init(view: SettingsView)
    func getNumberOfSection() -> Int
    func getNumberOfRows(in section: Int) -> Int
    func configureCell(at indexPath: IndexPath, completion: @escaping (_ title: String, _ iconName: String, _ isThemeCell: Bool) -> Void)
    func getTitleForFooter(in section: Int) -> String?
    func didSelectRow(at indexPath: IndexPath)
}

final class SettingsPresenterImp: SettingsPresenter {
    private weak var view: SettingsView?
    private let settingsModel: [SettingsSection]
    private let trackingService: AddressTrackingService
    
    init(view: SettingsView) {
        self.view = view
        self.settingsModel = SettingsModel().model
        self.trackingService = UserDefaults.standard
    }
    
    func getNumberOfSection() -> Int {
        return settingsModel.count
    }
    
    func getNumberOfRows(in section: Int) -> Int {
        return settingsModel[section].count
    }
    
    func configureCell(at indexPath: IndexPath, completion: @escaping (_ title: String, _ iconName: String, _ isThemeCell: Bool) -> Void) {
        let currentCell = cell(at: indexPath)
        completion(currentCell.title, currentCell.style.rawValue, currentCell.title == "Theme")
    }
    
    func getTitleForFooter(in section: Int) -> String? {
        return section == settingsModel.count - 1 ? "Developed by Arseniy Zolotarev\nPowered by Dogechain.info" : nil
    }
    
    func didSelectRow(at indexPath: IndexPath) {
      
    }
}

// MARK: - Private Methods
private extension SettingsPresenterImp {
    func cell(at indexPath: IndexPath) -> SettingsCell {
        return settingsModel[indexPath.section][indexPath.row]
    }
}
