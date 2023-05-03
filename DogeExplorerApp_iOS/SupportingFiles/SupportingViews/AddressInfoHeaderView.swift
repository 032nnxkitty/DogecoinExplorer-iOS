//
//  AddressInfoHeaderView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 24.04.2023.
//

import UIKit

class AddressInfoHeaderView: UIView {
    
    // MARK: - UI Elements
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private var addressLabel: UILabel!
    private var balanceLabel: UILabel!
    private var transactionsLabel: UILabel!
    
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
        balanceLabel.text = dogeBalance
        transactionsLabel.text = transactionsCount
    }
}

// MARK: - Private Methods
private extension AddressInfoHeaderView {
    func configureAppearance() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
        
        addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        addressLabel = configureValueLabel()
        
        balanceLabel = configureValueLabel()
        balanceLabel.font = .preferredFont(forTextStyle: .headline)
        balanceLabel.textColor = .label
        
        transactionsLabel = configureValueLabel()
        
        containerStack.addArrangedSubview(createSection(sectionTitle: "Address", valueLabel: addressLabel))
        containerStack.addArrangedSubview(createSection(sectionTitle: "Balance", valueLabel: balanceLabel))
        containerStack.addArrangedSubview(createSection(sectionTitle: "Transactions", valueLabel: transactionsLabel))
    }
    
    func configureValueLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "..."
        label.textAlignment = .right
        return label
    }
    
    func createSection(sectionTitle: String, valueLabel: UILabel) -> UIStackView {
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.font = .preferredFont(forTextStyle: .footnote)
        sectionTitleLabel.text = sectionTitle + ":"
        sectionTitleLabel.textColor = .secondaryLabel
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.addArrangedSubview(sectionTitleLabel)
        stack.addArrangedSubview(valueLabel)
        
        return stack
    }
}
