//
//  AddressInfoHeaderView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 24.04.2023.
//

import UIKit

final class AddressInfoHeaderView: UIView {
    
    // MARK: - UI Elements
    private let infoLabelsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dogeBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = "... DOGE"
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    private let usdBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = "= ... $"
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let transactionsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Transactions: ..."
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setInfo(address: String, dogeBalance: String, transactionsCount: String) {
        addressLabel.text = address
        dogeBalanceLabel.text = dogeBalance
        transactionsCountLabel.text = transactionsCount
    }
}

// MARK: - Private Methods
private extension AddressInfoHeaderView {
    func configureAppearance() {
        addSubview(infoLabelsStack)
        
        NSLayoutConstraint.activate([
            infoLabelsStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            infoLabelsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            infoLabelsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            infoLabelsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        infoLabelsStack.addArrangedSubview(addressLabel)
        infoLabelsStack.addArrangedSubview(dogeBalanceLabel)
        //infoLabelsStack.addArrangedSubview(usdBalanceLabel)
        infoLabelsStack.addArrangedSubview(transactionsCountLabel)
    }
}
