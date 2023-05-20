//
//  UIStackView+Separators.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.05.2023.
//

import UIKit

extension UIStackView {
    func addHorizontalSeparators(of color: UIColor) {
        var i = arrangedSubviews.count - 1
        while i >= 1 {
            let separator = createSeparator(of: color)
            insertArrangedSubview(separator, at: i)
            separator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
            i -= 1
        }
    }
    
    fileprivate func createSeparator(of color: UIColor) -> UIView {
        let separator = UIView()
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = color
        return separator
    }
}
