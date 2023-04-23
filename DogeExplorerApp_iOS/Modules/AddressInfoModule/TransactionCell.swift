//
//  TransactionCell.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 22.04.2023.
//

import UIKit

final class TransactionCell: UITableViewCell {
    
    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    let stateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureInfoStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, time: String) {
        stateLabel.text = title
        timeLabel.text = time
    }
}

private extension TransactionCell {
    func configureInfoStack() {
        contentView.addSubview(infoStack)
        NSLayoutConstraint.activate([
            infoStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        infoStack.addArrangedSubview(stateLabel)
        infoStack.addArrangedSubview(timeLabel)
    }
}
