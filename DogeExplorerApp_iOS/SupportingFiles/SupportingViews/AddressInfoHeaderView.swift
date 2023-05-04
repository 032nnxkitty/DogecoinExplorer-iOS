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
        backgroundColor =  R.Colors.uiElement
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        addressLabel = configureValueLabel()
        
        balanceLabel = configureValueLabel()
        
        transactionsLabel = configureValueLabel()
        
        containerStack.addArrangedSubview(createSection(sectionTitle: "Address", valueLabel: addressLabel))
        containerStack.addArrangedSubview(createSection(sectionTitle: "Balance", valueLabel: balanceLabel))
//        containerStack.addArrangedSubview(createSection(sectionTitle: "Amount sent", valueLabel: configureValueLabel()))
//        containerStack.addArrangedSubview(createSection(sectionTitle: "Amount received", valueLabel: configureValueLabel()))
        containerStack.addArrangedSubview(createSection(sectionTitle: "Transactions", valueLabel: transactionsLabel))
        
        let iv = UIImageView(image: UIImage(named: "dogeLogo"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        addSubview(iv)
        NSLayoutConstraint.activate([
            iv.trailingAnchor.constraint(equalTo: trailingAnchor),
            iv.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 80),
            iv.heightAnchor.constraint(equalToConstant: 150),
            iv.widthAnchor.constraint(equalToConstant: 150)
        ])
        
    }
    
    func configureValueLabel() -> UILabel {
        let label = UILabel()
        label.text = "..."
        label.numberOfLines = 0
        //label.textAlignment = .right
        //label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }
    
    func createSection(sectionTitle: String, valueLabel: UILabel) -> UIStackView {
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.font = .preferredFont(forTextStyle: .footnote)
        sectionTitleLabel.text = sectionTitle + ":"
        sectionTitleLabel.textColor = .secondaryLabel
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.addArrangedSubview(sectionTitleLabel)
        stack.addArrangedSubview(valueLabel)
        
        return stack
    }
}
