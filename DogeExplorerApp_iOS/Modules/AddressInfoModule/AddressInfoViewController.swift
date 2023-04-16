//
//  AddressInfoViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

protocol AddressInfoView: AnyObject {
    
}

final class AddressInfoViewController: UIViewController {
    public var presenter: AddressInfoPresenter?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewAppearance()
    }
}

// MARK: - Private Methods
private extension AddressInfoViewController {
    func configureViewAppearance() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        title = "Address"
    }
}

// MARK: - AddressInfoView Protocol
extension AddressInfoViewController: AddressInfoView {
    
}
