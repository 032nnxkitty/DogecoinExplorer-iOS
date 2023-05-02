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
    
    private let openDogechainButton: UIButton  = {
        let button = UIButton(configuration: .filled())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("More info about transaction", for: .normal)
        return button
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
        view.addSubview(openDogechainButton)
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            openDogechainButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            openDogechainButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            openDogechainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        
        infoLabel.center = view.center
        title = R.LocalizableStrings.transactionTitle
        view.backgroundColor = .systemBackground
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

