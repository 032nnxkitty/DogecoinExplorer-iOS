//
//  TransactionCell.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 23.04.2023.
//

import UIKit

enum TransactionStyle {
    case sent
    case received
}

class TransactionCell: UITableViewCell {
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    private let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let sumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let fromToLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(style: TransactionStyle, value: String, date: String, hash: String) {
        switch style {
        case .sent:
            stateLabel.text = R.LocalizableStrings.sent
            sumLabel.textColor = .label
        case .received:
            stateLabel.text = R.LocalizableStrings.received
            sumLabel.textColor = .systemGreen
        }
        sumLabel.text = value
        timeLabel.text = date
        fromToLabel.text = hash
    }
}

// MARK: - Private Methods
private extension TransactionCell {
    func configureAppearance() {
        backgroundColor = R.Colors.uiElement
        
        addSubview(containerStack)
        NSLayoutConstraint.activate([
            
            containerStack.topAnchor.constraint(equalTo: self.topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        containerStack.addArrangedSubview(topStack)
        containerStack.addArrangedSubview(bottomStack)
        
        topStack.addArrangedSubview(stateLabel)
        topStack.addArrangedSubview(sumLabel)
        
        bottomStack.addArrangedSubview(fromToLabel)
        bottomStack.addArrangedSubview(timeLabel)
    }
}
