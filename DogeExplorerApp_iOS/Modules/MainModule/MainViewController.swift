//
//  MainViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

protocol MainView: AnyObject {
    func showSettingsViewController()
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
        navigationItem.largeTitleDisplayMode = .never
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

}

// MARK: - MainView Protocol
extension MainViewController: MainView {
    func showSettingsViewController() {
        let settingsVC = ModuleBuilder.createSettingsModule()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

// MARK: -
extension MainViewController: UISearchBarDelegate {
    
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
}
