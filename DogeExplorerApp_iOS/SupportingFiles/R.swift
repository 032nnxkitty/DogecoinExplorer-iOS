//
//  R.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit.UIColor

enum R {
    enum Identifiers {
        static let trackedCell         = "trackingCellIdentifier"
        static let transactionCell     = "transactionInfoCellIdentifier"
    }
    
    enum Colors {
        static let background:     UIColor = .RGBColor(r: 0,   g: 0,   b: 0)
        static let backgroundGray: UIColor = .RGBColor(r: 31,  g: 33,  b: 37)
        static let lightGray:      UIColor = .RGBColor(r: 171, g: 171, b: 171)
        static let accent:         UIColor = .RGBColor(r: 254, g: 243, b: 195)
    }
}
