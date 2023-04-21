//
//  SettingsViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

protocol SettingsView: AnyObject {
    func showConfirmationActionSheet()
    func showOkActionSheet(title: String, message: String)
    
    func setThemeIndex(_ index: Int)
    func openLink(url: URL)
    func changeTheme()
}

final class SettingsViewController: UIViewController {
    public var presenter: SettingsPresenter!
    
    // MARK: - UI Elements
    private let settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: R.Identifiers.settingsCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var themeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Device", "Dark", "Light"])
        segmentedControl.addTarget(self, action: #selector(themeChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewAppearance()
        configureSettingsTableView()
    }
}

// MARK: - Private Methods
private extension SettingsViewController {
    func configureViewAppearance() {
        title = "Settings"
        view.backgroundColor = .systemBackground
    }
    
    func configureSettingsTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        view.addSubview(settingsTableView)
        NSLayoutConstraint.activate([
            settingsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Actions
@objc private extension SettingsViewController {
    func themeChanged(_ sender: UISegmentedControl) {
        presenter.themeIndexDidChange(to: sender.selectedSegmentIndex)
    }
}

// MARK: - SettingsView Protocol
extension SettingsViewController: SettingsView {
    func openLink(url: URL)  {
        UIApplication.shared.open(url)
    }
    
    func showConfirmationActionSheet() {
        let deleteAlert = UIAlertController(title: "Are u sure?", message: "Delete all tracked addresses", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.presenter.deleteAllTrackedAddresses()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        present(deleteAlert, animated: true)
    }
    
    func showOkActionSheet(title: String, message: String) {
        let deleteAlert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        deleteAlert.addAction(okAction)
        present(deleteAlert, animated: true)
    }
    
    func setThemeIndex(_ index: Int) {
        themeSegmentedControl.selectedSegmentIndex = index
    }
    
    func changeTheme() {
        view.window?.overrideUserInterfaceStyle = UserDefaults.standard.theme.userInterfaceStyle
    }
}
// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Identifiers.settingsCell, for: indexPath)
        var cellContent = cell.defaultContentConfiguration()
        presenter.configureCell(at: indexPath) { title, iconName, isThemeCell in
            cellContent.image = UIImage(systemName: iconName) 
            cellContent.text = title
            
            guard isThemeCell else { return }
            cell.accessoryView = self.themeSegmentedControl
            cell.selectionStyle = .none
        }
        cellContent.imageProperties.maximumSize = CGSize(width: 25, height: 25)
        cell.contentConfiguration = cellContent
        cell.backgroundColor = .systemGray6
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        presenter.getTitleForFooter(in: section)
    }
}
