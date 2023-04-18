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
    func showOkActionSheet(title: String, message: String)
    func animateLoader(_ isAnimated: Bool)
    
    func showAddTrackingAlert()
    func showDeleteAlert()
    func showRenameAlert()
    
    func hideLoadTransactionsButton()
}

final class AddressInfoViewController: UIViewController {
    public var presenter: AddressInfoPresenter!
    
    // MARK: - UI Elements
    private lazy var sectionSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Info", "Transactions"])
        segmentedControl.addTarget(self, action: #selector(sectionDidChange), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let informationTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "InfoCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        //tableView.sectionFooterHeight = 0
        return tableView
    }()
    
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        return loader
    }()
    
    private lazy var addTrackingButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(trackingStateDidChange))
        return button
    }()
    
    private lazy var deleteTrackingButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trackingStateDidChange))
        return button
    }()
    
    private lazy var renameButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(renameButtonDidTap))
        return button
    }()
    
    private lazy var loadTransactionsButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("button", for: .normal)
        button.addTarget(self, action: #selector(loadTransactionsButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewAppearance()
        configureInfoTableView()
        configureLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

// MARK: - Private Methods
private extension AddressInfoViewController {
    func configureViewAppearance() {
        //navigationItem.titleView = sectionSegmentedControl
        view.backgroundColor = .systemBackground
    }
    
    func configureLoader() {
        view.addSubview(loader)
        loader.center = view.center
    }
    
    func configureInfoTableView() {
        informationTableView.dataSource = self
        informationTableView.delegate = self
        
        view.addSubview(informationTableView)
        NSLayoutConstraint.activate([
            informationTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            informationTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            informationTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            informationTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        print("here")
        presenter.loadTransactionsButtonDidTap()
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
    
    func animateLoader(_ isAnimated: Bool) {
        isAnimated ? loader.startAnimating() : loader.stopAnimating()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
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
        case 1:
            presenter.configureTransactionCell(at: indexPath) { title, value in
                cellContent.text = title
                cellContent.secondaryText = value
            }
            cellContent.textProperties.font = .preferredFont(forTextStyle: .headline)
            cellContent.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
            cellContent.secondaryTextProperties.color = .gray
            cellContent.image = UIImage(systemName: "arrow.up.to.line.alt")
            cell.selectionStyle = .default
        default:
            break
        }
        
        cell.backgroundColor = .systemGray6
        cell.contentConfiguration = cellContent
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let stack = UIStackView()
        stack.isLayoutMarginsRelativeArrangement =  true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        stack.addArrangedSubview(sectionSegmentedControl)
        return stack
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard sectionSegmentedControl.selectedSegmentIndex == 1,
              section == presenter.getNumberOfSections() - 1 else { return nil }
        let stack = UIStackView()
        stack.isLayoutMarginsRelativeArrangement =  true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        stack.addArrangedSubview(loadTransactionsButton)
        return stack
    }
}

// MARK: - UITableViewDelegate
extension AddressInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if sectionSegmentedControl.selectedSegmentIndex == 1 {
            let controller = UIViewController()
            // if available ios 15
            controller.view.backgroundColor = .systemBackground
            controller.title = "Transaction information"
            if let sheetController = controller.sheetPresentationController {
                sheetController.detents = [.medium()]
                sheetController.prefersGrabberVisible = true
                sheetController.preferredCornerRadius = 20
            }
            present(controller, animated: true)
        }
    }
}
