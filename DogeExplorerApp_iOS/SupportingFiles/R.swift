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
    
    enum LocalizableStrings {
        static let searchBar     = NSLocalizedString("addressSearchBar", comment: "")
        
        static let settingsTitle = NSLocalizedString("settingsTitle", comment: "")
        static let language      = NSLocalizedString("language", comment: "")
        static let theme         = NSLocalizedString("theme", comment: "")
        static let deleteAll     = NSLocalizedString("deleteAll", comment: "")
        static let sourceCode    = NSLocalizedString("sourceCode", comment: "")
        static let feedback      = NSLocalizedString("feedback", comment: "")
        static let appStore      = NSLocalizedString("appStore", comment: "")
        static let support       = NSLocalizedString("support", comment: "")
        static let appInfo       = NSLocalizedString("appInfo", comment: "")
        
        static let device      = NSLocalizedString("device", comment: "")
        static let dark        = NSLocalizedString("dark", comment: "")
        static let light       = NSLocalizedString("light", comment: "")
        
        static let transactionTitle = NSLocalizedString("transactionTitle", comment: "")
        static let sent             = NSLocalizedString("sent", comment: "")
        static let received         = NSLocalizedString("received", comment: "")
        static let loadMore         = NSLocalizedString("loadMore", comment: "")
    }
}
