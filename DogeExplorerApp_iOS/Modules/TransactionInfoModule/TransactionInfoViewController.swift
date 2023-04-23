//
//  TransactionInfoViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 22.04.2023.
//

import UIKit

protocol TransactionInfoView: AnyObject {
    
}

final class TransactionInfoViewController: UIViewController {
    var presenter: TransactionInfoPresenter!
    
    // MARK: - UI Elements
    private lazy var informationTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: R.Identifiers.transactionInfoCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewAppearance()
    }
}

// MARK: - Private Methods
private extension TransactionInfoViewController {
    func configureViewAppearance() {
        title = "Transaction"
        view.backgroundColor = .systemBackground
        
        view.addSubview(informationTableView)
        NSLayoutConstraint.activate([
            informationTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            informationTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            informationTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            informationTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - TransactionInfoView Protocol
extension TransactionInfoViewController: TransactionInfoView {
    
}

// MARK: - UITableViewDataSource
extension TransactionInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Identifiers.transactionInfoCell, for: indexPath)
        cell.backgroundColor = .systemGray6
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Info"
        case 1: return "Inputs"
        case 2: return "Outputs"
        default: return nil
        }
    }
}

// MARK: - UITableViewDelegate
extension TransactionInfoViewController: UITableViewDelegate {
    
}
