//
//  LoaderButton.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 20.04.2023.
//

import UIKit

class LoaderButton: UIButton {
    private let loader = UIActivityIndicatorView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    // MARK: - Public Methods
    func startLoading() {
        loader.startAnimating()
        titleLabel?.alpha = 0
    }
    
    func stopLoading() {
        loader.stopAnimating()
        titleLabel?.alpha = 1
    }
    
    // MARK: - Private Methods
    private func configure() {
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

