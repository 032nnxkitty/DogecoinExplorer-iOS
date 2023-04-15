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
    func deleteAllTrackedAddresses()
    func themeIndexDidChange(to index: Int)
}

final class SettingsPresenterImp: SettingsPresenter {
    private weak var view: SettingsView?
    private let settingsModel: [SettingsSection]
    private let trackingService: AddressTrackingService
    
    init(view: SettingsView) {
        self.view = view
        self.settingsModel = SettingsModel().model
        self.trackingService = UserDefaults.standard
        initialize()
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
        let currentCell = cell(at: indexPath)
        switch currentCell.style {
        case .language:
            print("language cell")
        case .theme:
            break
        case .deleteAddresses:
            didTapDeleteTrackingCell()
        case .github:
            openLink("https://github.com/032nnxkitty/DogeExplorerApp_iOS")
        case .feedback:
            break
        case .rateApp:
            break
        case .supportMe:
            break
        }
    }
    
    func deleteAllTrackedAddresses() {
        trackingService.deleteAllTrackedAddresses()
    }
    
    func themeIndexDidChange(to index: Int) {
        UserDefaults.standard.theme = Theme(rawValue: index) ?? .device
        view?.changeTheme()
    }
}

// MARK: - Private Methods
private extension SettingsPresenterImp {
    func initialize() {
        let selectedThemeIndex = UserDefaults.standard.theme.rawValue
        view?.setThemeIndex(selectedThemeIndex)
    }
    
    func cell(at indexPath: IndexPath) -> SettingsCell {
        return settingsModel[indexPath.section][indexPath.row]
    }
    
    func openLink(_ stringUrl: String) {
        guard let url = URL(string: stringUrl) else { return }
        view?.openLink(url: url)
    }
    
    func didTapDeleteTrackingCell() {
        if trackingService.getAllTrackedAddresses().isEmpty {
            view?.showOkActionSheet(title: "No tracked addresses", message: ":/")
        } else {
            view?.showConfirmationActionSheet()
        }
    }
}
