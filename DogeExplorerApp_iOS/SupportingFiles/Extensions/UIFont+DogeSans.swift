//
//  UIFont+DogeSans.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.05.2023.
//

import UIKit

extension UIFont {
    static func dogeSans(style: UIFont.TextStyle) -> UIFont {
        var fontSize: CGFloat
        switch style {
        case .largeTitle:
            fontSize = 25
        case .headline:
            fontSize = 20
        case .body:
            fontSize = 17
        case .footnote:
            fontSize = 14
        default:
            fontSize = 17
        }
        guard let customFont = UIFont(name: "DogeSans-Regular", size: fontSize) else {
            return .preferredFont(forTextStyle: style)
        }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: customFont)
    }
}
