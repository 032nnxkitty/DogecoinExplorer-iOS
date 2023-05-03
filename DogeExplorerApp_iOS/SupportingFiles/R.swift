//
//  R.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit.UIColor

enum R {
    enum Identifiers {
        static let trackingCell        = "trackingCellIdentifier"
        static let settingsCell        = "settingsCellIdentifier"
        static let addressInfoCell     = "addressInfoCellIdentifier"
        static let transactionInfoCell = "transactionInfoCellIdentifier"
    }
    
    enum Colors {
        static let background: UIColor = .systemBackground
    }
    
    enum Keys {
        static let theme = "themeKey"
        static let trackingAddresses = "trackedAddressesKey"
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
