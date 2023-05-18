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
    fileprivate let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.backgroundGray
        view.layer.cornerRadius = 20
        return view
    }()
    
    fileprivate let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    fileprivate let topStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    fileprivate let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    fileprivate let stateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .dogeSans(size: 20, style: .headline)
        return label
    }()
    
    fileprivate let sumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .dogeSans(size: 20, style: .headline)
        return label
    }()
    
    fileprivate let destinationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .dogeSans(size: 14, style: .footnote)
        label.textColor = .secondaryLabel
        return label
    }()
    
    fileprivate let timeLabel: UILabel = {
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
fileprivate extension TransactionCell {
    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            containerStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            containerStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            containerStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        topStack.addArrangedSubview(stateLabel)
        topStack.addArrangedSubview(sumLabel)
        
        bottomStack.addArrangedSubview(destinationLabel)
        bottomStack.addArrangedSubview(timeLabel)
        
        containerStack.addArrangedSubview(topStack)
        containerStack.addArrangedSubview(bottomStack)
    }
}
