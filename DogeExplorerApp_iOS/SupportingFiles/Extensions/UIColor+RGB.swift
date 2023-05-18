//
//  UIColor+RGB.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 18.05.2023.
//

import UIKit

extension UIColor {
    class func RGBColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
