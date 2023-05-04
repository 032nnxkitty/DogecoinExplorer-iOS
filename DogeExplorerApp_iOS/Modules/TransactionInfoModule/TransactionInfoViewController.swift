//
//  TransactionInfoViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 22.04.2023.
//

import UIKit

protocol TransactionInfoView: AnyObject {
    
}

class TransactionInfoViewController: UIViewController {
    var presenter: TransactionInfoPresenter!
    
    // MARK: - UI Elements
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Here will be information about the transaction"
        return label
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
        view.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
        ])
        
        infoLabel.center = view.center
        title = R.LocalizableStrings.transactionTitle
        view.backgroundColor = R.Colors.background
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
    }
}

// MARK: - Private Methods
@objc private extension TransactionInfoViewController {
    func close() {
        dismiss(animated: true)
    }
}

// MARK: - TransactionInfoView Protocol
extension TransactionInfoViewController: TransactionInfoView {
    
}

