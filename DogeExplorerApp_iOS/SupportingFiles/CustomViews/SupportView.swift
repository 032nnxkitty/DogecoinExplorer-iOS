//
//  SupportView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 18.07.2023.
//

import UIKit

final class SupportView: UIView {
    // MARK: - UI Elements
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.font = .dogeSans(style: .footnote)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    // MARK: - Public Method
    func addTarget(_ target: Any?, action: Selector) {
        label.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
    // MARK: - Private Methods
    private func configureView() {
        backgroundColor = R.Colors.background
    }
    
    private func configureLabel() {
        let labelText = "Made with ☕️ and ❤️ by Arseniy Zolotarev"
        let coloredText = "Arseniy Zolotarev"
        let range = labelText.getRange(of: coloredText)
        
        let attributedString = NSMutableAttributedString(string: labelText)
        
        attributedString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: R.Colors.accent,
            range: range
        )
        
        attributedString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: 1,
            range: range
        )
        
        label.attributedText = attributedString
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

