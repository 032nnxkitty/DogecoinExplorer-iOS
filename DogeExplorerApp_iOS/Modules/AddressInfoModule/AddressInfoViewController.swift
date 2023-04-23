//
//  AddressInfoViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

protocol AddressInfoView: AnyObject {
    func reloadData()
    
    func configureInfoSection()
    func configureTransactionsSection()
    func configureIfAddressTracked(name: String)
    func configureIfAddressNotTracked(shortenAddress: String)
    
    func animateCentralLoader(_ isAnimated: Bool)
    func animateLoadTransactionLoader(_ isAnimated: Bool)
    
    func showOkActionSheet(title: String, message: String)
    func showAddTrackingAlert()
    func showDeleteAlert()
    func showRenameAlert()
    func showTransactionInfoViewController()
    
    func hideLoadTransactionsButton()
}

final class AddressInfoViewController: UIViewController {
    public var presenter: AddressInfoPresenter!
    
    // MARK: - UI Elements
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var sectionSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Info", "Transactions"])
        segmentedControl.addTarget(self, action: #selector(sectionDidChange), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private lazy var informationTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: R.Identifiers.addressInfoCell)
        tableView.layoutMargins = UIEdgeInsets(top: 0.1, left: 0.1, bottom: 0.1, right: 0.1)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.sectionHeaderHeight = 0
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        return loader
    }()
    
    private lazy var tableViewRefresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var addTrackingButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "star"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(trackingStateDidChange))
        return button
    }()
    
    private lazy var deleteTrackingButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash,
                                     target: self,
                                     action: #selector(trackingStateDidChange))
        return button
    }()
    
    private lazy var renameButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .compose,
                                     target: self,
                                     action: #selector(renameButtonDidTap))
        return button
    }()
    
    private lazy var loadTransactionsButton: LoaderButton = {
        let button = LoaderButton(configuration: .plain())
        button.setTitle("Load more transactions", for: .normal)
        button.addTarget(self, action: #selector(loadTransactionsButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewAppearance()
        configureContainerStack()
        configureLoader()
    }
}

// MARK: - Private Methods
private extension AddressInfoViewController {
    func configureViewAppearance() {
        view.backgroundColor = .systemBackground
        informationTableView.refreshControl = tableViewRefresh
    }
    
    func configureContainerStack() {
        view.addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        containerStack.addArrangedSubview(sectionSegmentedControl)
        containerStack.addArrangedSubview(informationTableView)
    }
    
    func configureLoader() {
        view.addSubview(loader)
        loader.center = view.center
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
    func sectionDidChange(_ sender: UISegmentedControl) {
        presenter.sectionDidChange(to: sender.selectedSegmentIndex)
    }
    
    func renameButtonDidTap() {
        presenter.renameButtonDidTap()
    }
    
    func trackingStateDidChange() {
        presenter.trackingStateDidChange()
    }
    
    func loadTransactionsButtonDidTap() {
        presenter.loadTransactionsButtonDidTap()
    }
    
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableViewRefresh.endRefreshing()
        }
    }
}

// MARK: - AddressInfoView Protocol
extension AddressInfoViewController: AddressInfoView {
    func reloadData() {
        informationTableView.reloadData()
    }
    
    func configureInfoSection() {
        
    }
    
    func configureTransactionsSection() {
        
    }
    
    func configureIfAddressTracked(name: String) {
        title = name
        navigationItem.rightBarButtonItems = [deleteTrackingButton, renameButton]
    }
    
    func configureIfAddressNotTracked(shortenAddress: String) {
        title = shortenAddress
        navigationItem.rightBarButtonItems = [addTrackingButton]
    }
    
    func showOkActionSheet(title: String, message: String) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        actionSheet.addAction(action)
        present(actionSheet, animated: true)
    }
    
    func animateCentralLoader(_ isAnimated: Bool) {
        isAnimated ? loader.startAnimating() : loader.stopAnimating()
    }
    
    func animateLoadTransactionLoader(_ isAnimated: Bool) {
        isAnimated ? loadTransactionsButton.startLoading() : loadTransactionsButton.stopLoading()
    }
    
    func showAddTrackingAlert() {
        let trackingAlert = createTextFieldAlert(title: "Add name to address", message:  "If field will be empty..", placeHolder: "Enter name") { name in
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
        let renameAlert = createTextFieldAlert(title: "Enter new name", message: "If field will be empty..", placeHolder: "Enter new name") { name in
            self.presenter.renameAddress(newName: name)
        }
        present(renameAlert, animated: true)
    }
    
    func hideLoadTransactionsButton() {
        loadTransactionsButton.isHidden = true
    }
    
    func showTransactionInfoViewController() {
        let transactionVC = UINavigationController(rootViewController: ModuleBuilder.createTransactionModule())
        if let sheetController = transactionVC.sheetPresentationController {
            sheetController.detents = [.medium(), .large()]
            sheetController.prefersGrabberVisible = true
            sheetController.preferredCornerRadius = 20
        }
        present(transactionVC, animated: true)
        
    }
}

// MARK: - UITableViewDataSource
extension AddressInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Identifiers.addressInfoCell, for: indexPath)
        var cellContent = cell.defaultContentConfiguration()
        switch sectionSegmentedControl.selectedSegmentIndex {
        case 0:
            presenter.configureInfoCell(at: indexPath) { title, value in
                cellContent.text = title
                cellContent.secondaryText = value
            }
            cellContent.textProperties.font = .preferredFont(forTextStyle: .subheadline)
            cellContent.textProperties.color = .gray
            cellContent.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
            cell.selectionStyle = .none
            cell.accessoryType = .none
        case 1:
            presenter.configureTransactionCell(at: indexPath) { title, value, imageName in
                cellContent.text = title
                cellContent.secondaryText = value
                cellContent.image = UIImage(systemName: imageName)
                cellContent.textProperties.color = title == "Received" ? .systemGreen : .systemRed
                cellContent.imageProperties.tintColor = title == "Received" ? .systemGreen : .systemRed
            }
            
            cellContent.textProperties.font = .preferredFont(forTextStyle: .headline)
            cellContent.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
            cellContent.secondaryTextProperties.color = .gray
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        default:
            break
        }
        cell.backgroundColor = .systemGray6
        cell.contentConfiguration = cellContent
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard presenter.isLoadMoreButtonVisible(section) else { return 10 }
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard presenter.isLoadMoreButtonVisible(section) else { return nil }
        return loadTransactionsButton
    }
}

// MARK: - UITableViewDelegate
extension AddressInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presenter.didSelectRow(at: indexPath)
    }
}
