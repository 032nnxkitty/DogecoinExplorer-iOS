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
}

final class AddressInfoViewController: UIViewController {
    public var presenter: AddressInfoPresenter!
    
    // MARK: - UI Elements
    private lazy var sectionSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Info", "Transactions"])
        segmentedControl.addTarget(self, action: #selector(sectionDidChange), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let informationTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "InfoCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.sectionFooterHeight = 0
        return tableView
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewAppearance()
        configureInfoTableView()
    }
}

// MARK: - Private Methods
private extension AddressInfoViewController {
    func configureViewAppearance() {
        navigationItem.titleView = sectionSegmentedControl
        view.backgroundColor = .systemBackground
        
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
}

// MARK: - Actions
@objc private extension AddressInfoViewController {
    func sectionDidChange(_ sender: UISegmentedControl) {
        presenter.sectionDidChange(to: sender.selectedSegmentIndex)
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
    }
    
    func configureIfAddressNotTracked(shortenAddress: String) {
        title = shortenAddress
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
            cellContent.image =  UIImage(systemName: "arrow.up.to.line.alt")
            cell.selectionStyle = .default
        default:
            break
        }
        
        cell.backgroundColor = .systemGray6
        cell.contentConfiguration = cellContent
        return cell
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
