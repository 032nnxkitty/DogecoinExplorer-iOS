//
//  TrackedAddressCell.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.05.2023.
//

import UIKit

class TrackedAddressCell: UITableViewCell {
    // MARK: - UI Elements
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
        
        var configuration = UIBackgroundConfiguration.listPlainCell()
        configuration.backgroundInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        configuration.backgroundColor = R.Colors.backgroundGray
        configuration.cornerRadius = 20
        backgroundConfiguration =  configuration
        
        [nameLabel, addressLabel].forEach { labelsStack.addArrangedSubview($0) }
        
        contentView.addSubview(labelsStack)
        NSLayoutConstraint.activate([
            labelsStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            labelsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            labelsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            labelsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25)
        ])
    }
}
