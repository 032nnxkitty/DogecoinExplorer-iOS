//
//  InformationCardView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 24.04.2023.
//

import UIKit

final class InformationCardView: UIView {
    // MARK: - UI Elements
    private var addressSection = InformationSectionView(title: "Address")
    
    private var balanceSection = InformationSectionView(title: "Balance")
    
    private var transactionsSection = InformationSectionView(title: "Transactions")
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
        configureStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    // MARK: - Public Properties
    var address: String = "..." {
        didSet {
            addressSection.value = address
        }
    }
    
    var balance: String = "..." {
        didSet {
            balanceSection.value = balance
        }
    }
    
    var transactionsCount: String = "..." {
        didSet {
            transactionsSection.value = transactionsCount
        }
    }
}

// MARK: - Private Methods
private extension InformationCardView {
    func configureAppearance() {
        backgroundColor =  R.Colors.accent
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    func configureStack() {
        let containerStack = UIStackView()
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        containerStack.axis = .vertical
        containerStack.spacing = 10
        
        addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
        [balanceSection, addressSection, transactionsSection].forEach {
            containerStack.addArrangedSubview($0)
        }
        
        containerStack.addHorizontalSeparators(of: R.Colors.lightGray)
    }
}
