//
//  MainViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

final class MainViewController: UIViewController {
    public let viewModel: MainViewModel
    
    // MARK: - UI Elements
    private let searchBar: LoaderSearchBar = {
        let bar = LoaderSearchBar()
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
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let noTrackedAddressesView = NoTrackedAddressesView()
    
    // MARK: - Init
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        configureSearchBar()
        configureTableView()
        configureNoAddressesView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackedAddressesTableView.reloadData()
    }
    
    // MARK: - Event Hadling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

// MARK: - Private Methods
private extension MainViewController {
    func configureAppearance() {
        title = "Dogeexplorer"
        view.backgroundColor = R.Colors.background
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.dogeSans(size: 17, style: .body)
        ]
    }
    
    func configureSearchBar() {
        searchBar.delegate = self
        
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    func configureTableView() {
        view.addSubview(trackedAddressesTableView)
        NSLayoutConstraint.activate([
            trackedAddressesTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            trackedAddressesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackedAddressesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trackedAddressesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureNoAddressesView() {
        noTrackedAddressesView.isHidden = true
        noTrackedAddressesView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(noTrackedAddressesView)
        NSLayoutConstraint.activate([
            noTrackedAddressesView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            noTrackedAddressesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            noTrackedAddressesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            noTrackedAddressesView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func showRenameAlertForAddress(at indexPath: IndexPath) {
        let renameAlert = UIAlertController(title: "Enter a new name", message: "", preferredStyle: .alert)
        renameAlert.addTextField { [weak self] textField in
            textField.text = "..."
        }
        renameAlert.addAction(.init(title: "Cancel", style: .cancel))
        renameAlert.addAction(.init(title: "Confirm", style: .default) { [weak self] action in
            let name = renameAlert.textFields?[0].text
            //self?.presenter?.renameAddress(at: indexPath, newName: name)
        })
        present(renameAlert, animated: true)
    }
    
    func checkNumberOfAddresses(_ numberOfAddresses: Int) {
        let isEmpty = numberOfAddresses == 0
        trackedAddressesTableView.isHidden = isEmpty
        noTrackedAddressesView.isHidden = !isEmpty
    }
}

// MARK: - MainView Protocol
extension MainViewController {
    func showInfoViewController(for address: String, addressInfo: (BalanceModel, TransactionsCountModel)) {
        searchBar.text = nil
        let addressInfoVC = ModuleBuilder.createAddressInfoModule(address: address, addressInfo: addressInfo)
        navigationController?.pushViewController(addressInfoVC, animated: true)
    }
    
    func reloadData() {
        trackedAddressesTableView.reloadData()
    }
    
    func showOkActionSheet(title: String, message: String) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actionSheet.addAction(.init(title: "Ok", style: .cancel))
        present(actionSheet, animated: true)
    }
    
    func showNoTrackedAddressesView(_ isVisible: Bool) {
        noTrackedAddressesView.isHidden = !isVisible
        trackedAddressesTableView.isHidden = isVisible
    }
    
    func animateLoader(_ isAnimated: Bool) {
        isAnimated ? searchBar.startAnimating() : searchBar.stopAnimating()
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchButtonDidTap(text: searchBar.text)
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfAddresses = viewModel.numberOfTrackedAddresses
        checkNumberOfAddresses(numberOfAddresses)
        return numberOfAddresses
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Identifiers.trackedCell, for: indexPath) as! TrackedAddressCell
        let cellViewModel = viewModel.getViewModelForAddress(at: indexPath)
        cell.configure(viewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TitleView(title: "Tracked addresses", height: 55)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completion in
            guard let self else { return }
            self.viewModel.deleteAddress(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .right)
            completion(true)
        }
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = R.Colors.background
        
        let renameAction = UIContextualAction(style: .normal, title: "") { [weak self] _, _, completion in
            self?.showRenameAlertForAddress(at: indexPath)
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
       // ..
    }
}
