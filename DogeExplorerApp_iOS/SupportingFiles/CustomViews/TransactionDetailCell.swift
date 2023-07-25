//
//  TransactionDetailCell.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.07.2023.
//

import UIKit

final class TransactionDetailCell: UITableViewCell {
    static let identifier = "transaction.detail.cell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font = .dogeSans(style: .body)
        label.textColor = R.Colors.lightGray
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font = .dogeSans(style: .headline)
        label.textColor = .white
        label.numberOfLines = 0
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
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    // MARK: - Private Methods
    private func configureAppearance() {
        backgroundColor = R.Colors.elementBackground
        selectionStyle = .none
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = 6
        
        [titleLabel, valueLabel].forEach { stack.addArrangedSubview($0) }
        
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
