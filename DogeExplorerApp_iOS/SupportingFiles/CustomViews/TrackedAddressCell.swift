//
//  TrackedAddressCell.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.05.2023.
//

import UIKit

class TrackedAddressCell: UITableViewCell {
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.backgroundGray
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font = .dogeSans(size: 25, style: .largeTitle)
        label.textColor = R.Colors.accent
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font = .dogeSans(size: 17, style: .body)
        label.textColor = R.Colors.lightGray
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
    func configure(name: String, address: String) {
        nameLabel.text = name
        addressLabel.text = address
    }
}

// MARK: - Private Methods
private extension TrackedAddressCell {
    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(labelsStack)
        NSLayoutConstraint.activate([
            labelsStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            labelsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            labelsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            labelsStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        labelsStack.addArrangedSubview(nameLabel)
        labelsStack.addArrangedSubview(addressLabel)
    }
}
