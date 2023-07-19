//
//  LoaderView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 19.07.2023.
//

import UIKit

final class LoaderView: UIView {
    private let loader = UIActivityIndicatorView()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .darkGray
        layer.cornerRadius = 20
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.style = .large
        loader.color = .white
        
        addSubview(loader)
        NSLayoutConstraint.activate([
            loader.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            loader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            loader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            loader.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    // MARK: - Public Methods
    func startLoading(on view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        transform = .init(scaleX: 0.8, y: 0.8)
        alpha = 0
        
        view.addSubview(self)
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        loader.startAnimating()
        
        UIView.animate(withDuration: 0.6) {
            self.transform = .identity
            self.alpha = 1
        }
    }
    
    func stopLoading() {
        UIView.animate(withDuration: 0.6) {
            self.transform = .init(scaleX: 0.8, y: 0.8)
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}



