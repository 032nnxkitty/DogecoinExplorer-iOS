//
//  TrackedAddressCell.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.05.2023.
//

import UIKit

final class TrackedAddressCell: UITableViewCell {
    static let identifier = "tracked.cell.identifier"
    
    // MARK: - UI Elements
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font = .dogeSans(style: .largeTitle)
        label.textColor = R.Colors.accent
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font = .dogeSans(style: .body)
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
    func configure(address: String, name: String) {
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
        configuration.backgroundColor = R.Colors.elementBackground
        configuration.cornerRadius = 20
        backgroundConfiguration =  configuration
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 8
        
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25)
        ])
        
        [nameLabel, addressLabel].forEach {
            stack.addArrangedSubview($0)
        }
    }
}
