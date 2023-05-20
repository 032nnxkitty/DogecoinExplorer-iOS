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
    // MARK: - UI Elements
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
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
        label.font = .dogeSans(size: 20, style: .headline)
        return label
    }()
    
    private let sumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .dogeSans(size: 20, style: .headline)
        return label
    }()
    
    private let destinationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .dogeSans(size: 14, style: .footnote)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .dogeSans(size: 14, style: .footnote)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    // MARK: - Public Methods
    func configure(style: TransactionStyle, value: String, date: String, hash: String) {
        switch style {
        case .sent:
            stateLabel.text = "Sent"
            sumLabel.textColor = .label
        case .received:
            stateLabel.text = "Received"
            sumLabel.textColor = R.Colors.accent
        }
        sumLabel.text = value
        timeLabel.text = date
        destinationLabel.text = hash
    }
}

// MARK: - Private Methods
private extension TransactionCell {
    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
        
        var configuration = UIBackgroundConfiguration.listPlainCell()
        configuration.backgroundInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        configuration.backgroundColor = R.Colors.backgroundGray
        configuration.cornerRadius = 20
        backgroundConfiguration =  configuration
        
        contentView.addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25)
        ])
        
        topStack.addArrangedSubview(stateLabel)
        topStack.addArrangedSubview(sumLabel)
        
        bottomStack.addArrangedSubview(destinationLabel)
        bottomStack.addArrangedSubview(timeLabel)
        
        containerStack.addArrangedSubview(topStack)
        containerStack.addArrangedSubview(bottomStack)
    }
}
