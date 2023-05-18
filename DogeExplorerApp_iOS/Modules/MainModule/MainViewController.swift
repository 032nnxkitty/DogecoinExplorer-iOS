//
//  MainViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

class MainViewController: UIViewController {
    public var presenter: MainPresenter!
    
    // MARK: - UI Elements
    private let addressSearchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.searchTextField.font = .dogeSans(size: 17, style: .body)
        bar.searchTextField.backgroundColor = .clear
        bar.backgroundColor = R.Colors.backgroundGray
        bar.placeholder = "Enter the address to search"
        bar.backgroundImage = UIImage()
        bar.layer.cornerRadius = 20
        return bar
    }()
    
    private lazy var trackedAddressesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TrackedAddressCell.self, forCellReuseIdentifier: R.Identifiers.trackedCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var supportButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "heart"))
        button.tintColor = R.Colors.backgroundGray
        return button
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureSearchBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

// MARK: - Actions
@objc private extension MainViewController {
    
}

// MARK: - Private Methods
private extension MainViewController {
    func configureAppearance() {
        title = "Dogeexplorer"
        view.backgroundColor = R.Colors.background
        
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = supportButton
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.dogeSans(size: 17, style: .body)
        ]
    }
    
    func configureSearchBar() {
        addressSearchBar.delegate = self
        
        view.addSubview(addressSearchBar)
        NSLayoutConstraint.activate([
            addressSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addressSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            addressSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            addressSearchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureTableView() {
        view.addSubview(trackedAddressesTableView)
        NSLayoutConstraint.activate([
            trackedAddressesTableView.topAnchor.constraint(equalTo: addressSearchBar.bottomAnchor, constant: 10),
            trackedAddressesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackedAddressesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trackedAddressesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func showRenameAlertForAddress(at indexPath: IndexPath) {
        let renameAlert = UIAlertController(title: "Enter new name", message: "", preferredStyle: .alert)
        renameAlert.addTextField { [weak self] textField in
            textField.text = self?.presenter?.getNameForAddress(at: indexPath)
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] action in
            let name = renameAlert.textFields?[0].text
            self?.presenter?.renameAddress(at: indexPath, newName: name)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        renameAlert.addAction(confirmAction)
        renameAlert.addAction(cancelAction)
        present(renameAlert, animated: true)
    }
}

// MARK: - MainView Protocol
extension MainViewController: MainView {
    func showInfoViewController(for address: String) {
        let addressInfoVC = ModuleBuilder.createAddressInfoModule(address)
        navigationController?.pushViewController(addressInfoVC, animated: true)
    }
    
    func reloadData() {
        trackedAddressesTableView.reloadData()
    }
    
    func showOkActionSheet(title: String, message: String) {
        addressSearchBar.resignFirstResponder()
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        actionSheet.addAction(action)
        present(actionSheet, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchButtonDidTap(with: searchBar.text)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Identifiers.trackedCell, for: indexPath) as! TrackedAddressCell
        presenter.configureCell(at: indexPath) { name, address in
            cell.configure(name: name, address: address)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TitleView(title: "Tracked addresses")
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { _, _, completion in
            self.presenter.deleteTrackingForAddress(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .right)
            completion(true)
        }
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = R.Colors.background
        
        let renameAction = UIContextualAction(style: .normal, title: "") { _, _, completion in
            self.showRenameAlertForAddress(at: indexPath)
            completion(true)
        }
        renameAction.image = UIImage(named: "rename")
        renameAction.backgroundColor = R.Colors.background
        
        return UISwipeActionsConfiguration(actions: [deleteAction, renameAction])
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectAddress(at: indexPath)
    }
}
