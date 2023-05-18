//
//  NoTrackedAddressesView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 18.05.2023.
//

import UIKit

class NoTrackedAddressesView: UIView {
    // MARK: - UI Elements
    fileprivate let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    fileprivate let noAddressesLabel: UILabel = {
        let label = UILabel()
        label.text = "No tracked addresses :("
        label.textColor = R.Colors.accent
        label.font = .dogeSans(size: 25, style: .largeTitle)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let sadDogImageView: UIImageView = {
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
    fileprivate func configureAppearance() {
        addSubview(containerStack)
        containerStack.frame = self.bounds
        containerStack.addArrangedSubview(sadDogImageView)
        containerStack.addArrangedSubview(noAddressesLabel)
    }
}
