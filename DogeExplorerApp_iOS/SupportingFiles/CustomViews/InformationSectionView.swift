//
//  InformationSectionView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 20.07.2023.
//

import UIKit

final class InformationSectionView: UIStackView {
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font = .dogeSans(size: 14, style: .footnote)
        label.textColor = .black
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font = .dogeSans(size: 17, style: .body)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    // MARK: - Public Properties
    var value: String = "..." {
        didSet {
            valueLabel.text = value
        }
    }
    
    // MARK: - Init
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        configureAppearance()
    }
    
    required init(coder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    // MARK: - Private Methods
    private func configureAppearance() {
        distribution = .equalSpacing
        axis = .vertical
        spacing = 6
        [titleLabel, valueLabel].forEach { addArrangedSubview($0) }
    }
}
