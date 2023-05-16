//
//  AddressInfoHeaderView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 24.04.2023.
//

import UIKit

class AddressBaseInfoView: UIView {
    // MARK: - UI Elements
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
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
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    // MARK: - Public Methods
    func setInfo(address: String, dogeBalance: String, transactionsCount: String) {
        addressLabel.text = address
        balanceLabel.text = dogeBalance
        transactionsLabel.text = transactionsCount
    }
}

// MARK: - Private Methods
private extension AddressBaseInfoView {
    func configureAppearance() {
        backgroundColor =  R.Colors.accent
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
        balanceLabel = configureValueLabel()
        balanceLabel.font = .dogeSans(size: 25, style: .largeTitle)
        
        addressLabel = configureValueLabel()
        transactionsLabel = configureValueLabel()
    
        containerStack.addArrangedSubview(createSection(sectionTitle: "Balance", valueLabel: balanceLabel))
        containerStack.addArrangedSubview(createSection(sectionTitle: "Address", valueLabel: addressLabel))
        containerStack.addArrangedSubview(createSection(sectionTitle: "Transactions", valueLabel: transactionsLabel))
        
        containerStack.addHorizontalSeparators(of: R.Colors.lightGray)
    }
    
    func configureValueLabel() -> UILabel {
        let label = UILabel()
        label.text = "..."
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .dogeSans(size: 17, style: .body)
        label.textColor = .black
        return label
    }
    
    func createSection(sectionTitle: String, valueLabel: UILabel) -> UIStackView {
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.font = .dogeSans(size: 14, style: .footnote)
        sectionTitleLabel.text = sectionTitle
        sectionTitleLabel.textColor = .black
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.addArrangedSubview(sectionTitleLabel)
        stack.addArrangedSubview(valueLabel)
        
        return stack
    }
    
}
