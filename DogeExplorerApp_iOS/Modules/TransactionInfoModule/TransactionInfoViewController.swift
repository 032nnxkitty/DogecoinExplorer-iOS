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
    }
}

// MARK: - TransactionInfoView Protocol
extension TransactionInfoViewController: TransactionInfoView {
    
}

