//
//  MakeWithLoveView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 27.06.2023.
//

import UIKit

final class MakeWithLoveView: UIView {
    // MARK: - UI Elements
    let gradientLayer = CAGradientLayer()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Made with ❤️ and ☕️ by Arseniy Zolotarev"
        label.font = .dogeSans(size: 17, style: .body)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureGradient()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

// MARK: - Private Methods
private extension MakeWithLoveView {
    func configureGradient() {
        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor.black.cgColor
        
        gradientLayer.locations = [0, 1]
        gradientLayer.colors = [colorTop, colorBottom]
        
        self.layer.addSublayer(gradientLayer)
    }
    
    func configureLabel() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
