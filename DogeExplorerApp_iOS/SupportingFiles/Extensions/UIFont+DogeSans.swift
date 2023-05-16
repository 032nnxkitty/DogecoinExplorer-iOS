//
//  UIFont+DogeSans.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.05.2023.
//

import UIKit

extension UIFont {
    class func dogeSans(style: UIFont.TextStyle) -> UIFont {
        guard let customFont = UIFont(name: "DogeSans-Regular", size: 17) else {
            return .preferredFont(forTextStyle: style)
        }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: customFont)
    }
}
