//
//  TransactionCell.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 23.04.2023.
//

import UIKit

final class TransactionCell: UITableViewCell {
    static let identifier = "transaction.cell.identifier"
    
    // MARK: - UI Elements
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .dogeSans(style: .headline)
        return label
    }()
    
    private let sumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .dogeSans(style: .headline)
        return label
    }()
    
    private let destinationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .dogeSans(style: .footnote)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .dogeSans(style: .footnote)
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
    func configure(viewModel: TransactionCellViewModel) {
        stateLabel.text = viewModel.style.rawValue.capitalized
        sumLabel.textColor = viewModel.style == .sent ? .white : R.Colors.accent
        sumLabel.text = viewModel.value
        dateLabel.text = viewModel.date
        destinationLabel.text = viewModel.hash
    }
}

// MARK: - Private Methods
private extension TransactionCell {
    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
        
        var configuration = UIBackgroundConfiguration.listPlainCell()
        configuration.backgroundInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        configuration.backgroundColor = R.Colors.elementBackground
        configuration.cornerRadius = 20
        backgroundConfiguration =  configuration
        
        
        let containerStack = UIStackView()
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        containerStack.distribution = .fillEqually
        containerStack.axis = .vertical
        containerStack.spacing = 4
        
        let topStack = UIStackView()
        topStack.axis = .horizontal
    
        let bottomStack = UIStackView()
        bottomStack.axis = .horizontal
    
        contentView.addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25)
        ])
        
        [stateLabel, sumLabel].forEach { topStack.addArrangedSubview($0) }
        
        [destinationLabel, dateLabel].forEach { bottomStack.addArrangedSubview($0) }
        
        [topStack, bottomStack].forEach { containerStack.addArrangedSubview($0) }
    }
}
