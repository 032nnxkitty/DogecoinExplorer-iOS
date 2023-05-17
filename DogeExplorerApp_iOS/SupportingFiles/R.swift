//
//  R.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit.UIColor

enum R {
    enum Identifiers {
        static let trackedCell        = "trackingCellIdentifier"
        static let settingsCell        = "settingsCellIdentifier"
        static let addressInfoCell     = "addressInfoCellIdentifier"
        static let transactionInfoCell = "transactionInfoCellIdentifier"
    }
    
    enum Colors {
        static let background: UIColor = .black
        static let accent: UIColor = .init(red: 254/255, green: 243/255, blue: 195/255, alpha: 1)
        static let backgroundGray: UIColor = .init(red: 41/255, green: 43/255, blue: 47/255, alpha: 1)
        static let lightGray: UIColor = .init(red: 171/255, green: 171/255, blue: 171/255, alpha: 1)
    }
}
