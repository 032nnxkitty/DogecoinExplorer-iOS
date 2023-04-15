//
//  MainViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

protocol MainView: AnyObject {
    func showSettingsViewController()
    func reloadData()
}

final class MainViewController: UIViewController {
    public var presenter: MainPresenter!
    
    private let addressSearchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = "Enter the address to search"
        bar.searchTextField.layer.masksToBounds = true
        bar.searchTextField.layer.cornerRadius = 18
        bar.backgroundImage = UIImage()
        return bar
    }()
    
    private let trackedAddressesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "trackedIdentifier")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var settingsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(settingsButtonDidTap))
        return button
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureSearchBar()
        configureTableView()
    }
}

@objc private extension MainViewController {
    func settingsButtonDidTap() {
        presenter?.settingsButtonDidTap()
    }
}

// MARK: - Private Methods
private extension MainViewController {
    func configureAppearance() {
        title = "Doge explorer"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    func configureSearchBar() {
        addressSearchBar.delegate = self
        
        view.addSubview(addressSearchBar)
        NSLayoutConstraint.activate([
            addressSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addressSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            addressSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func configureTableView() {
        trackedAddressesTableView.dataSource = self
        trackedAddressesTableView.delegate = self
        
        view.addSubview(trackedAddressesTableView)
        NSLayoutConstraint.activate([
            trackedAddressesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackedAddressesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trackedAddressesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackedAddressesTableView.topAnchor.constraint(equalTo: addressSearchBar.bottomAnchor)
        ])
    }

    func showRenameAlertForAddress(at indexPath: IndexPath) {
        let renameAlert = UIAlertController(title: "Enter new name", message: "If field will be empty..", preferredStyle: .alert)
        renameAlert.addTextField { textField in
            textField.placeholder = "Enter new name"
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { action in
            let name = renameAlert.textFields?[0].text
            self.presenter.renameAddress(at: indexPath, newName: name)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        renameAlert.addAction(confirmAction)
        renameAlert.addAction(cancelAction)
        present(renameAlert, animated: true)
    }
}

// MARK: - MainView Protocol
extension MainViewController: MainView {
    func showSettingsViewController() {
        let settingsVC = ModuleBuilder.createSettingsModule()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func reloadData() {
        trackedAddressesTableView.reloadData()
    }
}

// MARK: -
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchButtonDidTap(with: searchBar.text)
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfTrackedAddresses()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackedIdentifier", for: indexPath)
        var cellContent = cell.defaultContentConfiguration()
        presenter.configureCell(at: indexPath) { name, address in
            cellContent.text = name
            cellContent.secondaryText = address
        }
        cellContent.image = UIImage(systemName: "eyes")
        cellContent.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        
        cellContent.textProperties.adjustsFontForContentSizeCategory = true
        cellContent.textProperties.numberOfLines = 1
        
        cellContent.secondaryTextProperties.adjustsFontForContentSizeCategory = true
        cellContent.secondaryTextProperties.color = .darkGray
        
        cell.contentConfiguration = cellContent
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            self.presenter.deleteTrackingForAddress(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .right)
            completion(true)
        }
        delete.backgroundColor = .systemRed
        
        let rename = UIContextualAction(style: .normal, title: "Rename") { _, _, completion in
            self.showRenameAlertForAddress(at: indexPath)
            completion(true)
        }
        rename.backgroundColor = .systemPurple
        return UISwipeActionsConfiguration(actions: [delete, rename])
    }
}
