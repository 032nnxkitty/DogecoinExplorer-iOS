//
//  TrackedAddressCell.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.05.2023.
//

import UIKit

class TrackedAddressCell: UICollectionViewCell {
    // MARK: - UI Elements
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
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
        label.adjustsFontForContentSizeCategory = true
        label.textColor = R.Colors.lightGray
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        backgroundColor = R.Colors.backgroundGray
        layer.cornerRadius = 20
        
        addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        containerStack.addArrangedSubview(nameLabel)
        containerStack.addArrangedSubview(addressLabel)
    }
}
