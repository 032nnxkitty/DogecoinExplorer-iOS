//
//  NoTrackedAddressesView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 18.05.2023.
//

import UIKit

final class EmptyView: UIView {
    // MARK: - UI Elements
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.Colors.accent
        label.font = .dogeSans(style: .largeTitle)
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
    
    // MARK: - Public Properties
    var text: String = "No tracked addresses :(" {
        didSet {
            textLabel.text = text
        }
    }
    
    // MARK: - Private Methods
    private func configureAppearance() {
        textLabel.text = text
        
        addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        [sadDogImageView, textLabel].forEach { containerStack.addArrangedSubview($0) }
    }
}
