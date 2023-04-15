//
//  String+Formatting.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 15.04.2023.
//

import UIKit

extension String {
    func shortenAddress() -> String {
        return "\(prefix(8))...\(suffix(5))"
    }
}
