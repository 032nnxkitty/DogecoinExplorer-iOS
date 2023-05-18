//
//  AddressInfoViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

class AddressInfoViewController: UIViewController {
    var presenter: AddressInfoPresenter!
    
    // MARK: - UI Elements
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshUI), for: .valueChanged)
        return refresh
    }()
    
    private let containerStack: ScrollableStackView = {
        let stack = ScrollableStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.showsVerticalScrollIndicator = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.alpha = 0
        stack.delaysContentTouches = false
        return stack
    }()
    
    private lazy var transactionsTableView: SelfSizedTableView = {
        let tableView = SelfSizedTableView()
        tableView.register(TransactionCell.self, forCellReuseIdentifier: R.Identifiers.transactionInfoCell)
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let renameButton: UIBarButtonItem = {
        let button = UIButton(configuration: .filled())
        button.configuration?.background.cornerRadius = 5
        button.configuration?.baseBackgroundColor = R.Colors.backgroundGray
        button.setTitle("Rename", for: .normal)
        return UIBarButtonItem(customView: button)
    }()
    
    private let baseAddressInfoView = AddressBaseInfoView()
    private let trackingStateButton = TrackingStateButton()
    private let loadTransactionButton = LoadTransactionsButton()
    private let loader = UIActivityIndicatorView()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureScrollableStack()
    }
}

// MARK: - Private Methods
private extension AddressInfoViewController {
    func configureAppearance() {
        view.backgroundColor = R.Colors.background
        navigationItem.rightBarButtonItem = renameButton
        
        view.addSubview(loader)
        loader.center = view.center
        
        trackingStateButton.addTarget(self, action: #selector(trackingStateDidChange), for: .touchUpInside)
        loadTransactionButton.addTarget(self, action: #selector(loadTransactionsButtonDidTap), for: .touchUpInside)
    }
    
    func configureScrollableStack() {
        containerStack.refreshControl = refreshControl
        
        view.addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            containerStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            containerStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        containerStack.addArrangedSubview(baseAddressInfoView)
        containerStack.addArrangedSubview(trackingStateButton)
        containerStack.addArrangedSubview(transactionsTableView)
        containerStack.addArrangedSubview(loadTransactionButton)
    }
}

@objc private extension AddressInfoViewController {
    func refreshUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    func trackingStateDidChange() {
        presenter.trackingStateDidChange()
    }
    
    func loadTransactionsButtonDidTap() {
        presenter.loadTransactionsButtonDidTap()
    }
}

// MARK: - AddressInfoView Protocol
extension AddressInfoViewController: AddressInfoView {
    func reloadData() {
        transactionsTableView.reloadData()
    }
    
    func configureIfAddressTracked(name: String) {
        title = name
        navigationItem.rightBarButtonItem = renameButton
        trackingStateButton.setTrackingState()
    }
    
    func configureIfAddressNotTracked(shortenAddress: String) {
        title = shortenAddress
        navigationItem.rightBarButtonItem = nil
        trackingStateButton.setNonTrackingState()
    }
    
    func setAddressInfo(address: String, dogeBalance: String, transactionsCount: String) {
        transactionsTableView.reloadData()
        baseAddressInfoView.setInfo(address: address, dogeBalance: dogeBalance, transactionsCount: transactionsCount)
        UIView.animate(withDuration: 0.3) {
            self.containerStack.alpha = 1
        }
    }
    
    func showOkActionSheet(title: String, message: String) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        actionSheet.addAction(action)
        present(actionSheet, animated: true)
    }
    
    func showAddTrackingAlert() {
        
    }
    
    func showDeleteAlert() {
        
    }
    
    func showRenameAlert() {
        
    }
    
    func animateCentralLoader(_ isAnimated: Bool) {
        isAnimated ? loader.startAnimating() : loader.stopAnimating()
    }
    
    func animateLoadTransactionLoader(_ isAnimated: Bool) {
        isAnimated ? loadTransactionButton.startLoading() : loadTransactionButton.stopLoading()
    }
    
    func hideLoadTransactionsButton() {
        loadTransactionButton.isHidden = true
    }
}

// MARK: - UITableViewDataSource
extension AddressInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfTransactions()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // change on view model !!
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Identifiers.transactionInfoCell, for: indexPath) as! TransactionCell
        presenter.configureTransactionCell(at: indexPath) { style, value, time, hash in
            cell.configure(style: style, value: value, date: time, hash: hash)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddressInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TitleView(title: "Transactions")
    }
}


