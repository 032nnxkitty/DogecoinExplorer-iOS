//
//  TitleView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 18.05.2023.
//

import UIKit

class TitleView: UIView {
    private let titleLabel = UILabel()
    private var height: CGFloat!
    
    // MARK: - Init
    convenience init(title: String, height: CGFloat) {
        self.init(frame: .zero)
        self.titleLabel.text = title
        self.height = height
        configureAppearance()
    }
    
    // MARK: - Private Methods
    private func configureAppearance() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .dogeSans(size: 17, style: .body)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
}
