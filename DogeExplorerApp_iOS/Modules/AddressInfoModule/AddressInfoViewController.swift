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
    private var infoHeader: AddressBaseInfoView!
    
    private lazy var transactionsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(TransactionCell.self, forCellReuseIdentifier: R.Identifiers.addressInfoCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = R.Colors.background
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.alpha = 0
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        return loader
    }()
    
    private lazy var shareBarButton: UIBarButtonItem = {
        let button = UIButton(configuration: .filled())
        button.configuration?.baseBackgroundColor = R.Colors.backgroundGray
        button.tintColor = .white
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.addTarget(self, action: #selector(share), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    private lazy var renameBarButton: UIBarButtonItem = {
        let button = UIButton(configuration: .filled())
        button.configuration?.baseBackgroundColor = R.Colors.backgroundGray
        button.tintColor = .white
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.addTarget(self, action: #selector(renameButtonDidTap), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    private lazy var backBarButton: UIBarButtonItem = {
        let button = UIButton(configuration: .filled())
        button.configuration?.baseBackgroundColor = R.Colors.backgroundGray
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    private lazy var trackingStateButton: TrackingStateButton = {
        let button = TrackingStateButton()
        button.addTarget(self, action: #selector(trackingStateDidChange), for: .touchUpInside)
        return button
    }()
    
    private lazy var loadTransactionsButton: LoadTransactionsButton = {
        let button = LoadTransactionsButton(configuration: .plain())
        button.addTarget(self, action: #selector(loadTransactionsButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewAppearance()
        configureLoader()
        configureTableView()
    }
}

// MARK: - Private Methods
private extension AddressInfoViewController {
    func configureViewAppearance() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = backBarButton
        view.backgroundColor = R.Colors.background
        infoHeader = AddressBaseInfoView()
    }
    
    func configureLoader() {
        view.addSubview(loader)
        loader.center = view.center
    }
    
    func configureTableView() {
        transactionsTableView.refreshControl = refreshControl
        
        view.addSubview(transactionsTableView)
        NSLayoutConstraint.activate([
            transactionsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            transactionsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            transactionsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            transactionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func createTextFieldAlert(title: String, message: String, placeHolder: String, completion: @escaping (String?) -> Void) -> UIAlertController  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textField in textField.placeholder = placeHolder }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { action in
            completion(alert.textFields?[0].text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        return alert
    }
}

// MARK: - Actions
@objc private extension AddressInfoViewController {
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func popBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func trackingStateDidChange() {
        presenter.trackingStateDidChange()
    }
    
    func renameButtonDidTap() {
        presenter.renameButtonDidTap()
    }
    
    func loadTransactionsButtonDidTap() {
        presenter.loadTransactionsButtonDidTap()
    }
    
    func share() {
        let textToShare = presenter.getAddressInfoToShare()
        let avc = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        present(avc, animated: true)
    }
}

// MARK: - AddressInfoView Protocol
extension AddressInfoViewController: AddressInfoView {
    func reloadData() {
        transactionsTableView.reloadData()
    }
    
    func configureIfAddressTracked(name: String) {
        title = name
        navigationItem.rightBarButtonItems = [shareBarButton, renameBarButton]
        trackingStateButton.setTrackingState()
    }
    
    func configureIfAddressNotTracked(shortenAddress: String) {
        title = shortenAddress
        navigationItem.rightBarButtonItems = [shareBarButton]
        trackingStateButton.setNonTrackingState()
    }
    
    func animateCentralLoader(_ isAnimated: Bool) {
        isAnimated ? loader.startAnimating() : loader.stopAnimating()
    }
    
    func animateLoadTransactionLoader(_ isAnimated: Bool) {
        isAnimated ? loadTransactionsButton.startLoading() : loadTransactionsButton.stopLoading()
    }
    
    func setAddressInfo(address: String, dogeBalance: String, transactionsCount: String) {
        transactionsTableView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.transactionsTableView.alpha = 1
        }
        infoHeader.setInfo(address: address, dogeBalance: dogeBalance, transactionsCount: transactionsCount)
    }
    
    func showOkActionSheet(title: String, message: String) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        actionSheet.addAction(action)
        present(actionSheet, animated: true)
    }
    
    func showAddTrackingAlert() {
        let trackingAlert = createTextFieldAlert(title: "Add name to address",
                                                 message:  "If field will be empty..",
                                                 placeHolder: "Enter name") { name in
            self.presenter.addTracking(with: name)
        }
        present(trackingAlert, animated: true)
    }
    
    func showDeleteAlert() {
        let deleteAlert = UIAlertController(title: "Are u sure?", message: "", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.presenter.deleteTracking()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        present(deleteAlert, animated: true)
    }
    
    func showRenameAlert() {
        let renameAlert = createTextFieldAlert(title: "Enter new name",
                                               message: "If field will be empty..",
                                               placeHolder: "Enter new name") { name in
            self.presenter.renameAddress(newName: name)
        }
        present(renameAlert, animated: true)
    }
    
    func hideLoadTransactionsButton() {
        loadTransactionsButton.isHidden = true
    }
}

// MARK: - UITableViewDataSource
extension AddressInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfTransactions()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Identifiers.addressInfoCell, for: indexPath) as! TransactionCell
        presenter.configureTransactionCell(at: indexPath) { style, value, time, hash in
            cell.configure(style: style, value: value, date: time, hash: hash)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerStack = UIStackView()
        containerStack.axis = .vertical
        containerStack.spacing = 10
        containerStack.isLayoutMarginsRelativeArrangement = true
        containerStack.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        containerStack.addArrangedSubview(infoHeader)
        containerStack.addArrangedSubview(trackingStateButton)
        return containerStack
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let containerStack = UIStackView()
        containerStack.alignment = .center
        containerStack.isLayoutMarginsRelativeArrangement = true
        containerStack.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        containerStack.addArrangedSubview(loadTransactionsButton)
        return containerStack
    }
}

// MARK: - UITableViewDelegate
extension AddressInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectTransaction(at: indexPath)
    }
}
