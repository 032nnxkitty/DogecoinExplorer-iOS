//
//  LoaderButton.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 20.04.2023.
//

import UIKit

class LoadTransactionsButton: UIButton {
    private let loader = UIActivityIndicatorView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
        configureLoader()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    // MARK: - Public Methods
    func startLoading() {
        loader.startAnimating()
        titleLabel?.alpha = 0
        imageView?.alpha = 0
    }
    
    func stopLoading() {
        loader.stopAnimating()
        titleLabel?.alpha = 1
        imageView?.alpha = 1
    }
    
    // MARK: - Private Methods
    private func configureAppearance() {
        configuration = UIButton.Configuration.filled()
        configuration?.baseBackgroundColor = R.Colors.backgroundGray
        configuration?.baseForegroundColor = .white
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        configuration?.background.cornerRadius = 20
        setTitle("Load more", for: .normal)
        titleLabel?.font = .dogeSans(size: 17, style: .body)
    }
    
    private func configureLoader() {
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

