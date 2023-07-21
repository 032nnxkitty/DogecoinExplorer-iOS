//
//  ToastView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 18.07.2023.
//

import UIKit

final class ToastView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .dogeSans(style: .body)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    // MARK: - Init
    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        configureAppearance()
    }
    
    required init(coder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    // MARK: - Public Methods
    func present(on view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        transform = .init(scaleX: 0.8, y: 0.8)
        alpha = 0
        
        view.addSubview(self)
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        UIView.animate(withDuration: 0.6) {
            self.transform = .identity
            self.alpha = 1
        } completion: { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.dismiss()
            }
        }
    }
    
    // MARK: - Private Methods
    private func configureAppearance() {
        backgroundColor = .systemGray5
        layer.cornerRadius = 20
        
        addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.6) {
            self.transform = .init(scaleX: 0.8, y: 0.8)
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}
