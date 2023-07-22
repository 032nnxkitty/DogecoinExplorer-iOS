//
//  TransactionInOutputCell.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.07.2023.
//

import UIKit

final class TransactionInOutputCell: UITableViewCell {
    static let identifier = "transaction.inputoutput.cell"
    
    private lazy var destinationTitleLabel = setupTitleLabel()
    private lazy var destinationValueLabel = setupValueLabel()
    private lazy var amountTitleLabel = setupTitleLabel()
    private lazy var amountValueLabel = setupValueLabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    // MARK: - Public Methods
    func configure(isOutput: Bool, address: String, amount: String) {
        destinationTitleLabel.text = isOutput ? "To:" : "From:"
        amountTitleLabel.text = "Amount:"
        amountValueLabel.text = amount
        
        let underlinedAddress = address.getUnderlinedString()
        destinationValueLabel.attributedText = underlinedAddress
        destinationValueLabel.textColor = R.Colors.accent
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    private func configureAppearance() {
        backgroundColor = R.Colors.elementBackground
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = 6
        
        [destinationTitleLabel, destinationValueLabel, amountTitleLabel, amountValueLabel].forEach {
            stack.addArrangedSubview($0)
        }
        
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func setupTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "..."
        label.font = .dogeSans(style: .body)
        label.textColor = R.Colors.lightGray
        return label
    }
    
    private func setupValueLabel() -> UILabel {
        let label = UILabel()
        label.text = "..."
        label.font = .dogeSans(style: .headline)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }
}
