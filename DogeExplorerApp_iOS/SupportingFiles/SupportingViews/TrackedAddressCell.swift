//
//  TrackedAddressCell.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 04.05.2023.
//

import UIKit

class TrackedAddressCell: UITableViewCell {
    var text: String? {
        didSet {
            self.nameLabel.text = text
        }
    }
    
    var secondaryText: String? {
        didSet {
            self.addressLabel.text = text
        }
    }
    
    private var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let letterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        letterImageView.layer.cornerRadius = letterImageView.frame.size.height / 2
    }
    
    func configureAppearance() {
        addSubview(letterImageView)
        addSubview(containerStack)
        NSLayoutConstraint.activate([
            letterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            letterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            letterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            letterImageView.widthAnchor.constraint(equalTo: letterImageView.heightAnchor),
            
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: letterImageView.trailingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        containerStack.addArrangedSubview(nameLabel)
        containerStack.addArrangedSubview(addressLabel)
    }
}
