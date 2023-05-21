//
//  NoTrackedAddressesView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 18.05.2023.
//

import UIKit

class NoTrackedAddressesView: UIView {
    // MARK: - UI Elements
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    private let noAddressesLabel: UILabel = {
        let label = UILabel()
        label.text = "No tracked addresses :("
        label.textColor = R.Colors.accent
        label.font = .dogeSans(size: 25, style: .largeTitle)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let sadDogImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sadDog")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    // MARK: - Private Methods
    private func configureAppearance() {
        addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        containerStack.addArrangedSubview(sadDogImageView)
        containerStack.addArrangedSubview(noAddressesLabel)
    }
}
