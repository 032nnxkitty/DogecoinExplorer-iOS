//
//  MainViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

final class MainViewController: UIViewController {
    private var viewModel: MainViewModel
    
    // MARK: - UI Elements
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.searchTextField.font = .dogeSans(size: 17, style: .body)
        bar.searchTextField.backgroundColor = .clear
        bar.backgroundColor = R.Colors.elementBackground
        bar.placeholder = "Enter the address to search"
        bar.backgroundImage = UIImage()
        bar.layer.cornerRadius = 20
        bar.delegate = self
        return bar
    }()
    
    private lazy var trackedAddressesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TrackedAddressCell.self, forCellReuseIdentifier: TrackedAddressCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let emptyView = EmptyView()
    
    private let supportView = SupportView()
    
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
        configureUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackedAddressesTableView.reloadData()
    }
    
    // MARK: - Event Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

// MARK: - Actions
@objc private extension MainViewController {
    func didTapSupportLabel() {
        viewModel.didTapSupportView()
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
    
    func configureUIElements() {
        supportView.translatesAutoresizingMaskIntoConstraints = false
        supportView.addTarget(self, action: #selector(didTapSupportLabel))
        
        [searchBar, trackedAddressesTableView, supportView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 55),
            
            supportView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            supportView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            supportView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            trackedAddressesTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            trackedAddressesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackedAddressesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trackedAddressesTableView.bottomAnchor.constraint(equalTo: supportView.topAnchor)
            
        ])
    }
    
    func showEmptyView() {
        trackedAddressesTableView.isHidden = true
        
        emptyView.alpha = 0
        emptyView.transform = .init(scaleX: 0.8, y: 0.8)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            emptyView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        UIView.animate(withDuration: 0.3) {
            self.emptyView.alpha = 1
            self.emptyView.transform = .identity
        }
    }
    
    func hideEmptyView() {
        emptyView.removeFromSuperview()
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didTapSearchButton(text: searchBar.text)
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfAddresses = viewModel.trackedAddresses.count
        
        numberOfAddresses == 0 ? showEmptyView() : hideEmptyView()
        
        return numberOfAddresses
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackedAddressCell.identifier, for: indexPath) as! TrackedAddressCell
        let (address, name) = viewModel.trackedAddresses[indexPath.row]
        cell.configure(name: name, address: address)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TitleView(title: "Tracked addresses", height: 55)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completion in
            guard let self else { return }
            viewModel.deleteAddress(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .right)
            completion(true)
        }
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = R.Colors.background
        
        let renameAction = UIContextualAction(style: .normal, title: "") { [weak self] _, _, completion in
            guard let self else { return }
            let oldName = viewModel.trackedAddresses[indexPath.row].name
            presentTextFieldAlert(title: "Enter a new name", message: nil, textFieldText: oldName) { text in
                self.viewModel.renameAddress(at: indexPath, newName: text)
                tableView.reloadData()
            }
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
//        viewModel.didSelectAddress(at: indexPath)
        let vc = Assembly.setupAddressInfoModule(model: .init(
            address: "",
            balanceModel: .init(
                balance: "",
                confirmed: "",
                unconfirmed: "",
                success: -1
            ),
            transactionsCountModel: .init(
                info: .init(
                    sent: -1,
                    received: -1,
                    total: -1),
                success: -1
            ),
            transactions: [])
        )
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
